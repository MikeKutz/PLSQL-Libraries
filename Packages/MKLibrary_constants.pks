create or replace
package "MKLibrary Constants"
    authid current_user
as
        subtype "Token" is varchar2(2000);
        
        param_log_level  constant "Token" := 'log-level';
        param_log_output constant "Token" := 'log-output'; -- boolean - default false
        
        log_level_off    constant "Token" := 'off';
        log_level_on     constant "Token" := 'on';  -- default
        log_level_debug  constant "Token" := 'debug';
        log_level_verbose constant "Token" := 'verbose';
        
        log_type_info    constant "Token" := 'info';
        log_type_warning constant "Token" := 'warning';
        log_type_error   constant "Token" := 'error';
        log_type_debug   constant "Token" := 'verbose';
        log_type_verbose constant "Token" := 'verbose';
end "MKLibrary Constants";
/
