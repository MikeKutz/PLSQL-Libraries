create or replace
package Constants
    authid current_user
as
    /**
    * Constants
    *
    * Constants used throughout the MKLibrary code.
    *
    * @headcom
    **/
    
    /* tokens are used for various forms of parameter */
    subtype "Token" is varchar2(2000);
    
    /* Regular Expression for finding Whitespace (beyond `\s`) */
    regexp_whitespace     constant "Token" := '[' ||chr(32) || chr(10) || chr(13) || chr(8) || ']+';

    /* Logging parameters used in `STDERR_t` */
    param_log_level  constant "Token" := 'log-level';
    param_log_output constant "Token" := 'log-output'; -- boolean - default false
    
    /* valid value for `param_log_level */
    log_level_off    constant "Token" := 'off'; -- everything is skipped
    log_level_on     constant "Token" := 'on';  -- default
    log_level_debug  constant "Token" := 'debug'; -- default + `"debug"`
    log_level_verbose constant "Token" := 'verbose'; -- everything is shown
    
    /* valid values for `log_type` for `Log_utils."generic"` */
    log_type_info    constant "Token" := 'info';
    log_type_warning constant "Token" := 'warning';
    log_type_error   constant "Token" := 'error';
    log_type_debug   constant "Token" := 'verbose';
    log_type_verbose constant "Token" := 'verbose';
end Constants;
/
