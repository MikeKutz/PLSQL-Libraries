create or replace
package JSON_Path_utils
    authid definer
as
    /*
        JSON Path utils
        
        JSON Path manipulation utilities
        
        - ltrim_path -- removes left most level
        - rtrim_path -- removes right most level
        
        - lpop_path -- retruns left most level
        - rpop_path -- return right most level
        
        - translate_path - returns absolute path given Current Path and Relative Path
        
        
    */

    -- move to JSON_data_utils
    function get_top_node( j in out nocopy json_object_t ) return varchar2;
    -- list_top_nodes()
    
    procedure rename_node( j in out nocopy JSON, node_path in varchar2, new_name in varchar2 );
    -- **** NEED ALSO ****
    -- put_value( key, val )
    -- put_val( key, json_val )
    -- put_array( key, array )
    -- put_array_val( key, n, val )
    -- put_array_val( key, n, json_val )
    
    -- new_json_array
    -- new_json_object === new JSON();
    
    -- node_exists
    -- value_node_exists
    -- object_node_exists
    -- array_node_exists
    
    
                            

    /* retruns the right most node name
        '$.' is ignored
        '@.' returns 'this'
        '@.this.' is treated as '@.'
        TODO - rename to rpop_path
    */
    function rpop_path( j_path in varchar2 ) return varchar2;

    /*
        removes the left most node name. ignores `$.` and `@.`
        '$.' only will return '$.'
        '@.' only will raise an error
        TODO - rename to rtrim_path
    */
    function rtrim_path( j_path in varchar2 ) return varchar2;

    /* removes the left most node name.
        ignores `$.`
        `@.` is treated as 'this' and will return 'this' (??)
    */
    function ltrim_path( j_path in varchar2 ) return varchar2;
    
    /* retruns the left most node name
        '$.' is ignored
        '@.' returns 'this'
        '@.this.' is treated as '@.'
    */
     function lpop_path( j_path in varchar2 ) return varchar2;
        
        
    /*
      adjust @.xxx according to current_location
      always returns an absolute path starting with '$.'

      Current Location must be an absolute path ( `$.` )

      this_path supports both relative ( @. ) and absolute ( $. ) paths
      absolute paths return as-is
      
      this_path starting with '@.', 'this.', or 'supper.' are treated as a relative path
      all other are treated as absolute

      NULL values for current_location and this_path are treated as `$.` and `@.` respectively

    */
    function translate_path( this_path in varchar2, current_loc in varchar2 ) return varchar2;
    
end JSON_Path_utils;
/
