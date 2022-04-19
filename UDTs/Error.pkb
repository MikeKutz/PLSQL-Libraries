create or replace
type body STDERR_t
as
    constructor function STDERR_t return self as result
    as
    begin
        return;
    end STDERR_t;
    
    member procedure "error"( self in out nocopy STDERR_t, log_txt clob)
    as
    begin
        MKLibrary.Log_utils."error"( self.stderr, log_txt );
    end "error";
    
    member procedure "debug"( self in out nocopy STDERR_t, log_txt clob)
    as
    begin
         MKLibrary.Log_utils."debug"( self.stderr, log_txt );
    end "debug";
    
    member procedure "info"( self in out nocopy STDERR_t, log_txt clob)
    as
    begin
         MKLibrary.Log_utils."info"( self.stderr, log_txt );
    end "info";
    
    member procedure "verbose"( self in out nocopy STDERR_t, log_txt clob)
    as
    begin
         MKLibrary.Log_utils."verbose"( self.stderr, log_txt );
    end "verbose";
    
    member procedure "sql_error"( self in out nocopy STDERR_t)
    as
    begin
         MKLibrary.Log_utils."sql_error"( self.stderr );
    end "sql_error";
    
    member procedure "clear_logs"( self in out nocopy STDERR_t)
    as
    begin
        self.stderr := null;
    end "clear_logs";
    
    member function "get_log" return clob
    as
    begin
        return self.stderr;
    end "get_log";
end STDERR_t;
/

