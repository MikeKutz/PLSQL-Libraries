create or replace
type body STDERR_t
as
    constructor function STDERR_t return self as result
    as
    begin
        self.log_level := MKLibrary.Constants.log_level_on;
        return;
    end STDERR_t;
    
    member procedure "error"( self in out nocopy STDERR_t, log_txt clob)
    as
    begin
        if log_level != MKLibrary.Constants.log_level_off
        then
            MKLibrary.Log_utils."error"( self.stderr, log_txt );
        end if;
    end "error";
    
    member procedure "debug"( self in out nocopy STDERR_t, log_txt clob)
    as
    begin
        if log_level in ( MKLibrary.Constants.log_level_verbose, MKLibrary.Constants.log_level_debug )
        then
            MKLibrary.Log_utils."debug"( self.stderr, log_txt );
         end if;
    end "debug";
    
    member procedure "info"( self in out nocopy STDERR_t, log_txt clob)
    as
    begin
        if log_level != MKLibrary.Constants.log_level_off
        then
            MKLibrary.Log_utils."info"( self.stderr, log_txt );
         end if;
    end "info";
    
    member procedure "verbose"( self in out nocopy STDERR_t, log_txt clob)
    as
    begin
        if log_level = MKLibrary.Constants.log_level_verbose
        then
            MKLibrary.Log_utils."verbose"( self.stderr, log_txt );
        end if;
    end "verbose";
    
    member procedure "sql_error"( self in out nocopy STDERR_t)
    as
    begin
         MKLibrary.Log_utils."sql_error"( self.stderr );
    end "sql_error";

    member procedure set_on
    as
    begin
        self.log_level := Constants.log_level_on;
    end set_on;
    
    member procedure set_off
    as
    begin
        self.log_level := Constants.log_level_off;
    end set_off;
    
    member procedure set_debug
    as
    begin
        self.log_level := Constants.log_level_debug;
    end set_debug;
    
    member procedure set_verbose
    as
    begin
        self.log_level := Constants.log_level_verbose;
    end set_verbose;
    



    
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

    member procedure merge_other( self in out nocopy STDERR_t, other_obj in out nocopy STDERR_T )
    as
    begin
        if self.stderr is not null
        then
            self.stderr := self.stderr || chr(10) || other_obj."get_log"();
        else
            self.stderr := other_obj."get_log"();
        end if;
    end merge_other;
    
end STDERR_t;
/

