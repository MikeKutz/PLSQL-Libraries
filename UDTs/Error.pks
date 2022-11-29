create or replace
type STDERR_t
    authid current_user
as object (
    /**
    * Cached streaming engine for Logs (STDERR)
    *
    * @headcom
    */
    
    stderr         clob,
    log_level      varchar2(50), -- [on]/debug/verbose/off
    temporary_trace boolean, -- true == ON
    
    constructor function STDERR_t return self as result,

    member procedure set_on,
    member procedure set_off,
    member procedure set_debug,
    member procedure set_verbose,
    
    member procedure set_trace_on,
    member procedure set_trace_off,

    member procedure "error"( self in out nocopy STDERR_t, log_txt clob),
    member procedure "debug"( self in out nocopy STDERR_t, log_txt clob),
    member procedure "info"( self in out nocopy STDERR_t, log_txt clob),
    member procedure "verbose"( self in out nocopy STDERR_t, log_txt clob),
    member procedure "sql_error"( self in out nocopy STDERR_t),
    member procedure "clear_logs"( self in out nocopy STDERR_t),

    member function "get_log" return clob,
    member procedure merge_other( self in out nocopy STDERR_t, other_obj in out nocopy STDERR_T )
) NOT PERSISTABLE;
/
