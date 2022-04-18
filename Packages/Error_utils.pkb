create or replace
package  body "Error Utils"
as
    procedure "_sql_error_6009";
    PRAGMA SUPPRESSES_WARNING_6009("_sql_error_6009");
    
    clob_buffer  clob; -- used for inter-Procedure communication (6009)

    function "_get_time" return "MKLibrary Constants"."Token"
    as
    begin
        -- get current local timestamp
        return current_timestamp;
    end;
    
    function "_rpad"( log_type "MKLibrary Constants"."Token" ) return "MKLibrary Constants"."Token"
    as
    begin
        return rpad(log_type, 10);
    end;
    
    function "_show_entry"( log_type in "MKLibrary Constants"."Token" ) return boolean
    as
    begin
        return true;
        case
            when "MKLibrary Runtime".runtime.get_string( "MKLibrary Constants".param_log_level ) = "MKLibrary Constants".log_level_off
            then
                return false;
            when "MKLibrary Runtime".runtime.get_string( "MKLibrary Constants".param_log_level ) = "MKLibrary Constants".log_level_debug
            then
                return true;
            when "MKLibrary Runtime".runtime.get_string( "MKLibrary Constants".param_log_level ) =  "MKLibrary Constants".log_level_on
                          and log_type in ("MKLibrary Constants".log_type_warning
                                          ,"MKLibrary Constants".log_type_info
                                          ,"MKLibrary Constants".log_type_error)
            then
                return true;
            else
                return false;
        end case;
    end;

    procedure "generic"( main_str in out nocopy clob, log_type in "MKLibrary Constants"."Token", log_txt clob)
    as
        log_entry  clob;
        log_header clob;
    begin
        if "_show_entry"( log_type )
        then
            log_header := '[' || "_rpad"(log_type) || "_get_time"  || ' ]:';

            if main_str is not null
            then
                main_str := main_str || chr(10);
            end if;
            
            log_entry  := log_txt; -- ???

            if instr(log_entry, chr(10) ) > 0
            then
                main_str := main_str || log_header ||  chr(10) || rpad( '-', 80, '-') || chr(10) ;

                -- indent for easier read
              teJSON_clob_util.indent_block(log_entry); -- found in output_t

                main_str := main_str || log_entry;
            else
                main_str := main_str || log_header || log_entry;
            end if;

--            if "MKLibrary Runtime".runtime.get_boolean( "MKLibrary Constants".param_logging_output )
            if false
            then
                dbms_output.put_line( log_header || log_entry );
            end if;
        end if;
        
    end "generic";
    
    procedure "error"( main_str in out nocopy clob, log_txt clob)
    as
    begin
        "generic"( main_str, "MKLibrary Constants".log_type_error, log_txt );
    end "error";
    
    procedure "debug"( main_str in out nocopy clob, log_txt clob)
    as
    begin
        "generic"( main_str, "MKLibrary Constants".log_type_debug, log_txt );
    end "debug";
    
    procedure "info"( main_str in out nocopy clob, log_txt clob)
    as
    begin
        "generic"( main_str, "MKLibrary Constants".log_type_info, log_txt );
    end "info";
    
    procedure "verbose"( main_str in out nocopy clob, log_txt clob)
    as
    begin
        "generic"( main_str, "MKLibrary Constants".log_level_verbose, log_txt );
    end "verbose";

    procedure "sql_error"( main_str in out nocopy clob )
    as
    begin
        clob_buffer := null;
        "_sql_error_6009";
        "generic"( main_str, "MKLibrary Constants".log_type_error, clob_buffer );
    end "sql_error";

    procedure "_sql_error_6009"
    as
    begin
        -- do something
        clob_buffer := DBMS_UTILITY.format_error_stack;
    end;

-- INITIALIZE PACKAGE GLOBALS
begin
    runtime := new "Hash"();
    
    runtime.put_value( "MKLibrary Constants".param_log_level, "MKLibrary Constants".log_level_on );
    runtime.put_value( "MKLibrary Constants".param_log_output, false );
end "Error Utils";
/

    