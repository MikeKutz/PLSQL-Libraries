create or replace
type "Error"
    authid current_user
as object (
    stderr clob,
    constructor function "Error" return self as result,
    member procedure "error"( self in out nocopy "Error", log_txt clob),
    member procedure "debug"( self in out nocopy "Error", log_txt clob),
    member procedure "info"( self in out nocopy "Error", log_txt clob),
    member procedure "verbose"( self in out nocopy "Error", log_txt clob),
    member procedure "sql_error"( self in out nocopy "Error"),
    member procedure "clear_logs"( self in out nocopy "Error"),
    member function "get_log" return clob
);
/
