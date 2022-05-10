create or replace
package Log_utils
    authid current_user
as
    /*
    *  Log_utils
    *
    *  Log cacheing utilites similar to `DBMS_OUTPUT` for Logs
    *
    *  Single line format:
    *   YYYY-MM-DD HH:MI:SS.SSSS [LLLLLL] : {blah blah blah}
    *
    *  Multi line format:
    *   YYYY-MM-DD HH:MI:SS.SSSS [LLLLLL] :
    *   ----------------------------------------------------
    *       Lorem ipsum dolor sit amet, consectetur
    *       adipiscing elit, sed do eiusmod tempor
    *       incididunt ut labore et dolore magna aliqua.
    * 
    *  That is, the block of text is indented.
    *
    *  This is a *raw* utility procedures and do not filter the 
    *  appending to `main_str` due to Logging Level.
    *
    *  Use `STDERR_t` for that purpose.
    *
    * @headcom
    **/
    runtime   MKLibrary.Hash_t;
    
    /**
    * Primary procedure call for appending text to a clob
    *
    * @param    main_str  `log_txt` is formated and appended to this clob
    * @param    log_type  defines what is used for `[LLLLLLLL]` portion of the log entry line.
    * @param    log_txt   The text to be sent to the log
    **/
    procedure "generic"( main_str in out nocopy clob, log_type in MKLibrary.Constants."Token", log_txt clob);
    
    /**
    * Logs entry as `[ERROR ]`
    *
    * @param    main_str  `log_txt` is formated and appended to this clob
    * @param    log_txt   The text to be sent to the log
    **/
    procedure "error"( main_str in out nocopy clob, log_txt clob);
    
    /**
    * Logs entry as `[DEBUG ]`
    *
    * @param    main_str  `log_txt` is formated and appended to this clob
    * @param    log_txt   The text to be sent to the log
    **/
    procedure "debug"( main_str in out nocopy clob, log_txt clob);
    
    /**
    * Logs entry as `[INFO  ]`
    *
    * @param    main_str  `log_txt` is formated and appended to this clob
    * @param    log_txt   The text to be sent to the log
    **/
    procedure "info"( main_str in out nocopy clob, log_txt clob);
    
    /**
    * Logs entry as `[VERBOSE]`
    *
    * @param    main_str  `log_txt` is formated and appended to this clob
    * @param    log_txt   The text to be sent to the log
    **/
    procedure "verbose"( main_str in out nocopy clob, log_txt clob);
    
    /**
    * Appends the SQL_ERROR stack to the CLOB.
    *
    * @param    main_str  `log_txt` is formated and appended to this clob
    * @param    log_txt   The text to be sent to the log
    **/
    procedure "sql_error"( main_str in out nocopy clob);
end Log_utils;
/

    