create or replace
package "Error Utils"
    authid current_user
--    accessible by (package teJSON_generator
--                      ,package "execute"
--                      ,package "process"
--                      ,package teJSON_unit_test_util)
as
    /* teJSON logging facility
       all items are appended to a CLOB
    */
    runtime   "Hash";
    
    procedure "generic"( main_str in out nocopy clob, log_type in "MKLibrary Constants"."Token", log_txt clob);
    procedure "error"( main_str in out nocopy clob, log_txt clob);
    procedure "debug"( main_str in out nocopy clob, log_txt clob);
    procedure "info"( main_str in out nocopy clob, log_txt clob);
    procedure "verbose"( main_str in out nocopy clob, log_txt clob);
    procedure "sql_error"( main_str in out nocopy clob);
end "Error Utils";
/

    