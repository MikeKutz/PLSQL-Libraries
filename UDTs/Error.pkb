create or replace
type body "Error"
as
    constructor function "Error" return self as result
    as
    begin
        return;
    end "Error";
    
    member procedure "error"( self in out nocopy "Error", log_txt clob)
    as
    begin
        "log"."error"( self.stderr, log_txt );
    end "error";
    
    member procedure "debug"( self in out nocopy "Error", log_txt clob)
    as
    begin
        "log"."debug"( self.stderr, log_txt );
    end "debug";
    
    member procedure "info"( self in out nocopy "Error", log_txt clob)
    as
    begin
        "log"."info"( self.stderr, log_txt );
    end "info";
    
    member procedure "verbose"( self in out nocopy "Error", log_txt clob)
    as
    begin
        "log"."verbose"( self.stderr, log_txt );
    end "verbose";
    
    member procedure "sql_error"( self in out nocopy "Error")
    as
    begin
        "log"."sql_error"( self.stderr );
    end "sql_error";
    
    member procedure "clear_logs"( self in out nocopy "Error")
    as
    begin
        self.stderr := null;
    end "clear_logs";
    
    member function "get_log" return clob
    as
    begin
        return self.stderr;
    end "get_log";
end log_t;
/

