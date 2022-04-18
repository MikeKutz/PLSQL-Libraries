create or replace
package body "CLOB Utils"
as
    
    function split_clob( main_str in out nocopy clob) return dbms_sql.clob_table
    as
        ret_val dbms_sql.clob_table := new dbms_sql.clob_table();
    begin
        return ret_val;
    end;

    
    procedure replace_str(main_str      in out nocopy clob
                        ,replacement_txt in out nocopy clob
                        ,replace_block  in template_chunk_t
                        )
    as
        l int := length(main_str);
    begin
        case
            when replace_block.start_pos = 1 and replace_block.end_pos < l then
                main_str := replacement_txt || substr( main_str, replace_block.end_pos );
            when replace_block.start_pos > 1 and replace_block.end_pos > l then
                main_str := substr( main_str,1,replace_block.start_pos - 1) || replacement_txt;
            when replace_block.start_pos = 1 and replace_block.end_pos > l then
                main_str := replacement_txt;
            else
                main_str := substr( main_str,1,replace_block.start_pos - 1)
                         || replacement_txt
                         || substr( main_str, replace_block.end_pos );
        end case;
    end;
                        
    procedure indent_block( main_str in out nocopy clob, indent_str in varchar2 default '    ' )
    as
    begin
        main_str := regexp_replace( main_str , '^'
                                    ,nvl(indent_str,'    '), 1, 0, 'm' );
    end;

    function find_directive_chunks( main_str in  clob ) return template_chunk_nt pipelined
    as
        ret_val template_chunk_nt;
    begin
         if not regexp_like( main_str, teJSON_const.regexp_directive_search )
        then
            return;
        end if;
   
        with chunks(start_pos,end_pos,len) as (
            select regexp_instr(main_str, teJSON_const.regexp_directive_search, 1,1,0)
                  ,regexp_instr(main_str, teJSON_const.regexp_directive_search, 1,1,1)
                  ,regexp_instr(main_str, teJSON_const.regexp_directive_search, 1,1,1) - regexp_instr(main_str, teJSON_const.regexp_directive_search, 1,1,0)
            from dual
            union all
             select regexp_instr(main_str, teJSON_const.regexp_directive_search, c.end_pos,1,0)
                  ,regexp_instr(main_str, teJSON_const.regexp_directive_search, c.end_pos,1,1)
                  ,regexp_instr(main_str, teJSON_const.regexp_directive_search, c.end_pos,1,1) - regexp_instr(main_str, teJSON_const.regexp_directive_search, c.end_pos,1,0)
            from chunks c
            where regexp_instr(main_str, teJSON_const.regexp_directive_search, c.end_pos,1,0) > 0
        )
        select length( main_str )
                ,a.start_pos
                ,a.end_pos
                ,a.len
                ,'command'
            bulk collect into ret_val
        from chunks a;
        
        for i in 1 .. ret_val.count
        loop
            pipe row (ret_val(i));
        end loop;
        
        return;
    end;

    function find_variable_chunks( main_str in clob ) return template_chunk_nt pipelined
    as
        ret_val template_chunk_nt;
        l int;
    begin
        l := length( main_str );
        
        if not regexp_like( main_str, teJSON_const.regexp_variable_search )
        then
            return;
        end if;
   
        with chunks(start_pos,end_pos,len) as (
            select regexp_instr(main_str, teJSON_const.regexp_variable_search, 1,1,0)
                  ,regexp_instr(main_str, teJSON_const.regexp_variable_search, 1,1,1)
                  ,regexp_instr(main_str, teJSON_const.regexp_variable_search, 1,1,1) - regexp_instr(main_str, teJSON_const.regexp_variable_search, 1,1,0)
            from dual
            union all
             select regexp_instr(main_str, teJSON_const.regexp_variable_search, c.end_pos,1,0)
                  ,regexp_instr(main_str, teJSON_const.regexp_variable_search, c.end_pos,1,1)
                  ,regexp_instr(main_str, teJSON_const.regexp_variable_search, c.end_pos,1,1) - regexp_instr(main_str, teJSON_const.regexp_variable_search, c.end_pos,1,0)
            from chunks c
            where regexp_instr(main_str, teJSON_const.regexp_variable_search, c.end_pos,1,0) > 0
        )
        select length(main_str)
                ,a.start_pos
                ,a.end_pos
                ,a.len
                ,'variable'
            bulk collect into ret_val
        from chunks a;
        
        for i in 1 .. ret_val.count
        loop
            pipe row (ret_val(i));
        end loop;
        
        return;
    end;

    function find_and_fill_gaps( curr in template_chunk_curr ) return template_chunk_nt
        pipelined order curr by ( start_pos ) PARALLEL_ENABLE (partition curr by hash (total_len))
    as
        prior_row     template_chunk_t;
        missing_row   template_chunk_t;
        local_buffer  template_chunk_nt;
    begin
        prior_row.end_pos := 1;
        prior_row.len     := 0;

        fetch curr bulk collect into local_buffer;
        
        for i in 1 ..local_buffer.count
        loop
            -- piping missing first chunk
            if local_buffer(i).start_pos != prior_row.end_pos
            then
                missing_row.start_pos := prior_row.end_pos;
                missing_row.end_pos   := local_buffer(i).start_pos;
                missing_row.total_len := local_buffer(i).total_len;
                missing_row.len       := missing_row.end_pos - missing_row.start_pos;
                
                pipe row (missing_row);
            end if;

            -- pipe current chunk
            pipe row (local_buffer(i));
            prior_row := local_buffer(i);
            
            -- pipe missing last chunk
            if local_buffer(i).end_pos - 1 < local_buffer(i).total_len and i=local_buffer.count
            then
                missing_row.start_pos := local_buffer(i).end_pos;
                missing_row.end_pos   := local_buffer(i).total_len +  1;
                missing_row.total_len := local_buffer(i).total_len;
                missing_row.len       := missing_row.end_pos - missing_row.start_pos;

               pipe row (missing_row);
            end if;
        end loop;

        return;
    end;
    
    function find_all_chunks( main_str in clob ) return template_chunk_nt pipelined
    as
        didnt_find_one boolean := true;
        full_code template_chunk_t;
    begin
        for curr in (
                        with data as (
                                            select *
                                            from table(find_variable_chunks(main_str))
                                            union all
                                            select *
                                            from table(find_directive_chunks(main_str))
                        )
                        select *
                        from table(find_and_fill_gaps(
                                        cursor ( select * from data )
                                ))
            )
        loop
            didnt_find_one := false;
            pipe row ( curr );
        end loop;
        
        if didnt_find_one
        then
            full_code.start_pos := 1;
            full_code.end_pos := length(main_str) + 1;
            full_code.len     := length(main_str);
            
            pipe row ( full_code );
        end if;
        
        return;
    end;

    procedure rtrim_whitespace( main_str in out nocopy clob )
    as
        ws teJSON_const.language_token := '[' || chr(10) || chr(13) || '\s]*$';
    begin
        main_str := regexp_replace( main_str, ws, '');
    end;
 
     function clob_substr( main_str in out nocopy clob, seg in template_chunk_t ) return clob
     as
        ret_val clob;
    begin
        ret_val := substr( main_str, seg.start_pos, seg.len );
        return ret_val;
    end;
   
    
end "CLOB Utils";
/