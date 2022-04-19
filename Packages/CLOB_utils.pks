create or replace
package CLOB_utils
    authid current_user
as
    /*
        Package of CLOB manipulation routines
    */

    type template_chunk_t is record( total_len int, start_pos int, end_pos int, len int, block_type varchar2(10));
    type template_chunk_curr is ref cursor return template_chunk_t;
    type template_chunk_nt is table of template_chunk_t;
    
    /* splits input template into multiple segments based on ${} amd <% %>
        once split, you can run syntax checking on it
    */
    function split_clob( main_str in out nocopy clob) return dbms_sql.clob_table;
    
    function clob_substr( main_str in out nocopy clob, seg in template_chunk_t ) return clob;

    
    /* replace a segment of `main_str` with `replacement_txt` */
    procedure replace_str(main_str      in out nocopy clob
                        ,replacement_txt in out nocopy clob
                        ,replace_block  in template_chunk_t
                        );
                        
    procedure rtrim_whitespace( main_str in out nocopy clob );
    
    /* prepends all lines in `main_str` with `indent_str` */
    procedure indent_block( main_str in out nocopy clob, indent_str in varchar2 default '    '  );


    -- ALL OF THESE ARE teJSON SPECIFICS    
    /* locates all positions of <% %> */
--    function find_directive_chunks( main_str in clob ) return template_chunk_nt pipelined;
    
    /* locates all positions of ${} */
--    function find_variable_chunks( main_str in clob ) return template_chunk_nt pipelined;
    
    /* locates and identifies if the chunk of text is `variable` ( `${}` ) or `command` ( `<% %>` ) */
--    function find_all_chunks( main_str in clob ) return template_chunk_nt pipelined;
    
    /* calls `find_all_chunks` then fills in the gaps such that
         there are no islands in the array of (`start_pos`,`end_pos`)
    */
--    function find_and_fill_gaps( curr in template_chunk_curr ) return template_chunk_nt
--        pipelined order curr by ( start_pos ) PARALLEL_ENABLE (partition curr by hash (total_len));
    
end CLOB_utils;
/
