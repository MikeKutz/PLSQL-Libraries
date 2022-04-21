create or replace
package body JSON_Path_utils
as
--    procedure "_validate_node_name"( node_name in varchar2 )
--    as
--        dummy dual.dummy%type;
--    begin
--        -- TBD -- need a list of NODE TYPES
--        --     -- add NODE_TYPE to teJSON_nodes  -- node_blueprints
--        select a.dummy
--            into "_validate_node_name".dummy
--        from dual a
--        where 1 = 1;
--        
--    end;
--
--    procedure "_validate_node_type"( node_name in varchar2 )
--    as
--        dummy dual.dummy%type;
--    begin
--        -- TBD -- need a list of NODE TYPES
--        --     -- add NODE_TYPE to teJSON_nodes  -- node_blueprints
--        select a.dummy
--            into "_validate_node_type".dummy
--        from dual a
--        where 1 = 1;
--        
--    end;

    function get_top_node( j in out nocopy json_object_t ) return varchar2
    as
        key_list  JSON_KEY_LIST;
    begin
        key_list := j.get_keys();
        
        if key_list.count < 1
        then
            raise no_data_found;
        end if;
        
        return key_list(1);
    end get_top_node;
    
    procedure rename_node( j in out nocopy JSON, node_path in varchar2, new_name in varchar2 )
    as
        snippet_name varchar2(4000);
        sql_code  clob := q'[begin
            select
                json_transform( :b1,rename q'(##OLD##)' = q'(##NEW##)' ignore on missing )
                  into :b2
            from dual;
        end;]';
    begin
        snippet_name := rtrim_path(node_path) || '.' || new_name;
        
        -- set up Dynamic SQL
        sql_code := replace( sql_code, '##OLD##', node_path );
        sql_code := replace( sql_code, '##NEW##', new_name );
        
        -- debug SQL
--        dbms_output.put_line( 'sql = ' || sql_code );
        
        -- run
        execute immediate sql_code
        using in j,  out j;
        
    end rename_node;
    
/******************************************************************************
               BLUEPRINT INFO GETTER/SETTER - JSON datatype
*******************************************************************************/

--    function get_blueprint_info( j in out nocopy JSON ) return node_info_t
--    as
--        ret_val node_info_t;
--    begin
--        with  j_data as (
--                select json_dataguide( j )  l
--                from dual
--            ), id_nodes as (
--                select t.*,
--                    case when instr(node_path,'.',3) > 0 then 'blueprint_name'
--                        when  instr(node_path,'.',3) = 0 then 'blueprint_type'
--                    end as path_id
--                from j_data k,json_table( k.l , '$[*]' columns (
--                    node_path varchar2(4000) path '$."o:path"', 
--                    node_type varchar2(4000) path '$."type"' ,
--                    len       int            path '$."o:length"' ) ) t
--                where regexp_like( t.node_path, '^\$\.[^.]+(\.[^.]+)?$') and node_type = 'object'
--            )
--        select teJSON_nodes_util.rpop_path(min(decode(path_id,'blueprint_type',node_path))) blueprint_type
--              ,teJSON_nodes_util.rpop_path(min(decode(path_id,'blueprint_name',node_path))) blueprint_name
--            into ret_val.node_type, ret_val.node_name
--        from id_nodes
--        ;        
--        
--        return ret_val;
--    end;
--    
--    procedure set_blueprint_name( j in out nocopy JSON, new_name in varchar2 )
--    as
--        rcd node_info_t;
--        old_path_name  varchar2(2000);
--    begin
--        rcd := get_blueprint_info( j );
--        
--        old_path_name := '$.' || rcd.node_type || '.' || rcd.node_name;
--        
--        "_validate_node_name"( new_name );
--        
--        "_rename_node"( j, old_path_name, new_name );
--    end;
--    
--    function get_blueprint_name( j in out nocopy JSON ) return varchar2
--    as
--        rcd node_info_t;
--    begin
--        rcd := get_blueprint_info( j );
--        
--        return rcd.node_name;
--    end;
--
--    procedure set_blueprint_type( j in out nocopy JSON, new_name in varchar2 )
--    as
--        rcd node_info_t;
--        old_path_name  varchar2(2000);
--    begin
--        rcd := get_blueprint_info( j );
--        
--        old_path_name := '$.' || rcd.node_type ;
--
--        "_validate_node_type"( new_name );
--
--        "_rename_node"( j, old_path_name, new_name );
--    end;
--    
--    function get_blueprint_type( j in out nocopy JSON ) return varchar2
--    as
--        rcd node_info_t;
--    begin
--        rcd := get_blueprint_info( j );
--        
--        return rcd.node_type;
--    end;
--
--    procedure new_blueprint( j in out nocopy JSON, step_type in varchar2, step_name in varchar2 )
--    as
--        json_txt varchar2(4000);
--    begin
--        json_txt := '{"' || step_type || '":{"' || step_name || '":{"name":""}}}';
--        
--        j := json( json_txt) ;
--    end;
--
--    procedure new_blueprint( j in out nocopy JSON, step_type in varchar2 )
--    as
--        k json_object_t;
--    begin
----        new_blueprint( k, step_type );
----        
----        j := k.to_json;
--        new_blueprint( j, step_type, 'anonymous' );
--    end;

/******************************************************************************
               BLUEPRINT INFO GETTER/SETTER - json_object_t
*******************************************************************************/

--    function get_node_info( j in out nocopy json_object_t ) return node_info_t
--    as
--        ret_val node_info_t;
--        temp_obj json_object_t;
--    begin
--        ret_val.node_type := "_get_top_node"( j );
--        temp_obj := j.get_object(  ret_val.node_type );
--        
--        ret_val.node_name := "_get_top_node"( temp_obj );
--        
--        return ret_val;
--    end;
--    
--    procedure set_node_name( j in out nocopy json_object_t, new_name in varchar2 )
--    as
--        old_name teJSON_const.language_token;
--        node_identifier json_object_t;
--        rcd              node_info_t;
--    begin
--        if new_name is null
--        then
--            raise no_data_found;
--        end if;
--
--        "_validate_node_name"( new_name );
--        
--        -- find top node
--        rcd := get_node_info( j );
--        node_identifier := j.get_object( rcd.node_type );
--        
--        -- rename
--        node_identifier.rename_key( rcd.node_name, new_name );
--    end;
--    
--    procedure set_node_type( j in out nocopy json_object_t, node_type in varchar2 )
--    as
--        rcd  node_info_t;
--    begin
--        rcd := get_node_info( j );
--        
--        j.rename_key( rcd.node_type, set_node_type.node_type );
--    end;
--    
--    function get_node_name( j in out nocopy json_object_t ) return varchar2
--    as
--        rcd node_info_t;
--    begin
--        rcd := get_node_info(j);
--        
--        return rcd.node_name;
--    end;
--
--    function get_node_type( j in out nocopy json_object_t ) return varchar2
--    as
--        rcd node_info_t;
--    begin
--        rcd := get_node_info(j);
--        
--        return rcd.node_type;
--    end;
--
--    /* memory cleanup of node (if needed) + initialization
--    */
--    procedure new_blueprint( j in out nocopy json_object_t, step_type in varchar2 )
--    as
--        node_identifier json_object_t;
--        node_snippets   json_object_t;
--    begin
--        -- garbage collection
--        -- TBD
--        
--        -- validate node_type
--        node_snippets := json_object_t();
--        node_snippets.put('name','');
--        
--        -- reset
--        
--        node_identifier := json_object_t();
--        node_identifier.put( 'anonymous', node_snippets );
--
--        j := new json_object_t();
--        j.put( step_type, node_identifier );
--    end;
--
--/******************************************************************************
--               SNIPPET
--*******************************************************************************/
--    procedure add_instruction_to_instruction( j in out nocopy json, k in out nocopy json, location_path in varchar2)
--    as
--        -- add Object as Attribute to an Object
--        parent_path  varchar2(4000);
--        rcd  node_info_t;
--        k_corrected    json;
--        prior_loop     json_object_t;
--        this_loop      json_object_t;
--        node_name varchar2(4000);
--        path_to_fix varchar2(4000);
--        sql_code  clob := q'[begin
--            select
--                json_mergepatch( :b1, :b2  )
--                  into :b3
--            from dual;
--        end;]';
--        
--        i int := 0;
--    begin
--        -- INCOMPLETE
--
--        -- validate input    
--        if not is_valid_snippet_path( j, location_path || '.here' )
--        then
--            dbms_output.put_line( 'Failed Path: "' || location_path || '(.here)"' );
--            dbms_output.put_line( json_serialize( j ));
--            raise no_data_found;
--        end if;
--        
--        -- build JSON Patch
--        prior_loop:= new json_object_t();
--        prior_loop.put( rpop_path(location_path), k);
--
--        path_to_fix := rtrim_path( location_path );
--        node_name := rpop_path(path_to_fix);
--
--        while (node_name is not null and path_to_fix not in ( '$.', '$') and i < 100)
--        loop
--            i := i + 1;
--            
--            this_loop := new json_object_t();
--            this_loop.put( node_name, prior_loop );
--            prior_loop := this_loop.clone();
--            
--            node_name   :=  rpop_path( path_to_fix );
--            path_to_fix := rtrim_path( path_to_fix );
--        end loop;
--        
--        k_corrected := prior_loop.to_json();
--        
--        -- run
--        execute immediate sql_code
--        using in j, in k_corrected, out j;
--    end add_instruction_to_instruction;
--
--
--    procedure update_snippet( j in out nocopy JSON, snippet_path in varchar2, snippet_data in clob )
--    as
--        parent_path  varchar2(4000);
--        snippet_name varchar2(4000);
--        sql_code  clob := q'[begin
--            select
--                json_transform( :b1, replace ##PATH## = :b2 create on missing )
--                  into :b3
--            from dual;
--        end;]';
--    begin
--        -- snippet_path assertion here
--        snippet_name := rpop_path( snippet_path );
--        parent_path  := rtrim_path( snippet_path );
--        "_validate_node_name"(snippet_name);
--
--        if not is_valid_snippet_path( j, snippet_path )
--        then
--            raise no_data_found;
--        end if;
--
--        -- set up Dynamic SQL
--        sql_code := replace( sql_code, '##PATH##', 'q''(' || snippet_path || ')''' );
--        
--        -- debug SQL
----        dbms_output.put_line( 'sql = ' || sql_code );
--        
--        -- run
--        execute immediate sql_code
--        using in j, in snippet_data, out j;
--        
--    end update_snippet;
--
--    
--    procedure update_snippet( j in out nocopy json_object_t, snippet_path in varchar2, snippet_data in clob )
--    as
--        rcd          node_info_t;
--        code_block   json_object_t;
--        name_block   json_object_t;
--        k            JSON;
--        parent_path  varchar2(4000);
--        snippet_name varchar2(4000);
--        sql_code  clob := q'[begin
--            select
--                json_transform( :b1, replace ##PATH## = :b2 create on missing )
--                  into :b3
--            from dual;
--        end;]';
--    begin
--        k := j.to_json;
--        
--        update_snippet( k, snippet_path, snippet_data );
--        
--        -- convert j to k
--        k := j.to_json;
--
--        j := new json_object_t( k );
--    end update_snippet;
--
--    function is_valid_snippet_path( j in out nocopy JSON, snippet_full_path in varchar2 ) return boolean
--    as
--        ret_val boolean := false;
--    begin
--        if json_exists( j, rtrim_path( snippet_full_path ) || '.name' )
--        then
--            ret_val := true;
--        end if;
--        
--        return ret_val;
--    end is_valid_snippet_path;
--
--    function snippet_exists( j in out nocopy JSON, snippet_full_path in varchar2 ) return boolean
--    as
--        ret_val boolean := false;
--    begin
--        if is_valid_snippet_path( j, snippet_full_path ) and json_exists(j, snippet_full_path )
--        then
--            ret_val := true;
--        else
--            ret_val := false;
--        end if;
--        
--        return ret_val;
--    end snippet_exists;
--
--    function glob_snippets(  j in out nocopy JSON, glob_full_path in varchar2 ) return teJSON_const.snippet_list_nt
--    as
--        regexp_search varchar2(4000);
--        
--        ret_val  teJSON_const.snippet_list_nt;
--        
--    begin
--        -- changes "$.some.path.*.to.glob" to "$.some.path.[^\.]+.to.glob"
--        regexp_search := regexp_replace( glob_full_path, '\.', '\\.' );
--        regexp_search := regexp_replace( regexp_search, '\$', '\\$' );
--        regexp_search := regexp_replace( regexp_search, '\*', '[^\.]+');
--
----        dbms_output.put_line( 'glob input : "' || glob_full_path || '"' );
----        dbms_output.put_line( 'glob search: "' || regexp_search || '"' );
--        
--        
--        with  j_data as (
--            select json_dataguide( j )  l
--            from dual
--        ), id_nodes as (
--            select t.*
--            from j_data k,json_table( k.l , '$[*]' columns (
--                node_path varchar2(4000) path '$."o:path"', 
--                node_type varchar2(4000) path '$."type"' ,
--                len       int            path '$."o:length"' ) ) t
--        )
--        select node_path
--            bulk collect into ret_val
--        from id_nodes
----        ;
--        where regexp_like( node_path, regexp_search );
--        
--        return ret_val;
--    end;
--    
--    function get_snippet( j in out nocopy json_object_t, snippet_path in varchar2 ) return clob
--    as
--        rcd         node_info_t;
--        actual_path varchar2(4000);
--        k           json;
--    begin
--        if snippet_path is null
--        then
--            -- log.verbose( 'null path requested' )
--            return null;
--        end if;
--
--        k := j.to_json;
--
--        -- json_exists( k, node_path )
--        if json_exists( k, snippet_path )
--        then
--            return json_value( k, snippet_path );
--        else
--            return null;
--        end if;
--    end;
--    
--    function get_snippet( j in out nocopy JSON, snippet_path in varchar2 ) return clob
--    as
--    begin
--        if is_valid_snippet_path( j, snippet_path )
--        then
--            return json_value( j, snippet_path );
--        else
--            return null;
--        end if;
--    end;
    
/******************************************************************************
               PATH MANIPULATION
*******************************************************************************/

    function translate_path( this_path in varchar2, current_loc in varchar2 ) return varchar2
    as
        ret_val    varchar2(4000);
        path_buffer varchar2(4000);
        curr_loc_buffer varchar2(4000);
    begin
        -- adjust `current_loc'
        case
            when current_loc is null then
                curr_loc_buffer := '$.';
            when current_loc like '$.%' then
                curr_loc_buffer := current_loc;
--            when lpop_path( current_loc ) in ( 'this', 'supper' ) then
--                raise invalid_number;
            else
                curr_loc_buffer := '$.' || current_loc;
        end case;
    
        -- adjust `this_path`
        case
            when this_path like '$.%' then
                return this_path;
            when this_path = '@.' then
                path_buffer := 'this';
            when path_buffer like '@.supper.%' then
                path_buffer := substr(this_path,3);
            when this_path like '@.%' then
                path_buffer := 'this.' || substr(this_path,3);
            else
                path_buffer :=  this_path;
        end case;
        
        case
            when path_buffer is null then
                ret_val := curr_loc_buffer;
            when path_buffer = 'this' then -- '@.' is normalized to 'this'
                ret_val := curr_loc_buffer;
            when path_buffer like 'this.%' and curr_loc_buffer != '$.'  then
                ret_val := curr_loc_buffer || '.' || ltrim_path( path_buffer );
            when path_buffer like 'this.%' then
                ret_val := curr_loc_buffer ||  ltrim_path( path_buffer );
            when path_buffer like 'super.%' then
                ret_val := curr_loc_buffer;
                
                while ( path_buffer like 'super.%'  )
                loop
                    ret_val := rtrim_path( ret_val );
                    path_buffer := ltrim_path( path_buffer );
                end loop;
                
                if ret_val = '$.' then
                    ret_val := ret_val || path_buffer;
                else
                    ret_val := ret_val || '.' || path_buffer;
                end if;
            else
                ret_val := '$.' || this_path;
        end case;
        
--        dbms_output.put_line( '"' || this_path || '" -> "' || path_buffer || '" -> "' || ret_val || '"' );
        
        return ret_val;
    end;

    function rpop_path( j_path in varchar2 ) return varchar2
    as
        ret_val varchar2(4000);
    begin
        case
            when j_path = '$.' then
                ret_val := null;
            when j_path = '@.' then
                ret_val := 'this';
            when instr(j_path, '.' ) > 0 then
                ret_val := ltrim(regexp_substr( j_path, '\.[^.]+?$' ),'.');
            else
                ret_val := j_path;
        end case;
        
        return ret_val;
    end;
    function rtrim_path( j_path in varchar2 ) return varchar2
    as
        ret_val varchar2(4000);
    begin
        case
            when j_path = '$.' then
                ret_val := '$.';
            when j_path = '@.' then
                ret_val := null;
            when instr(j_path,'.') > 0 then
                -- is there a substr() version?
                ret_val := rtrim( regexp_substr( j_path, '^.+\.' ), '.' ); -- replace with substr
            else
                ret_val := null;
        end case;
        
        return ret_val;
    end;
    
    
    function ltrim_path( j_path in varchar2 ) return varchar2
    as
        ret_val varchar2(4000);
    begin
        case
            when j_path like '$.%' then
                ret_val := '$.' || ltrim_path( substr( j_path, 3 ) );
            when instr(j_path, '.') > 0 then
                ret_val := substr( j_path, instr(j_path, '.') + 1 );
            else
                ret_val := null;
        end case;
        
        return ret_val;
    end;
    
     function lpop_path( j_path in varchar2 ) return varchar2
     as
        ret_val       varchar2(4000);
        j_path_buffer varchar2(4000);
    begin
        case
            when j_path like '$.%' then
                j_path_buffer := substr(j_path,3);
            when j_path = '@.' then
                j_path_buffer := 'this';
            when j_path like '@.%' then
                j_path_buffer := 'this.' || substr(j_path,3);
            else
                j_path_buffer := j_path;
        end case;
        
        if instr( j_path_buffer, '.' ) > 0
        then
            ret_val := substr( j_path_buffer, 1, instr(j_path_buffer, '.' ) -1 );
        else
            ret_val := j_path_buffer;
        end if;
        
        return ret_val;
    end;

    
end JSON_Path_utils;
/
