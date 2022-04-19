create or replace
type STDERR_t
    authid current_user
as object (
    stderr clob,
    constructor function STDERR_t return self as result,
    member procedure "error"( self in out nocopy STDERR_t, log_txt clob),
    member procedure "debug"( self in out nocopy STDERR_t, log_txt clob),
    member procedure "info"( self in out nocopy STDERR_t, log_txt clob),
    member procedure "verbose"( self in out nocopy STDERR_t, log_txt clob),
    member procedure "sql_error"( self in out nocopy STDERR_t),
    member procedure "clear_logs"( self in out nocopy STDERR_t),
    member function "get_log" return clob
);
/
