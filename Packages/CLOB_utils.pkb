create or replace
package body CLOB_utils
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

    procedure rtrim_whitespace( main_str in out nocopy clob )
    as
        ws MKLibrary.Constants."Token" := '[' || chr(10) || chr(13) || ' ]*$';
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
   
    
end CLOB_utils;
/