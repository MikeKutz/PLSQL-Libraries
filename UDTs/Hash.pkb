create or replace
type body Hash_t
as
    constructor function Hash_t return self as result
    as
        j json_object_t;
    begin
        j := new json_object_t();
        
        self.json_clob := j.to_clob;
        
        return;
    end Hash_t;
    
    member procedure reset_properties
    as
    begin
        self := new Hash_t();
    end reset_properties;

    member function get_all_keys return json_key_list
    as
        j json_object_t;
    begin
        j := new json_object_t( json_clob );

        return j.get_keys();        
    end get_all_keys;
    
    member procedure put_value( key_str in varchar2, val_str in varchar2 )
    as
        j json_object_t;
    begin
        if key_str is null
        then
            -- log.verbose( 'Attempting to set NULL Key' );
            return;
        end if;
        
        j := new json_object_t( json_clob );
        j.put(key_str, val_str);
        
        json_clob := j.to_clob();
    end put_value;

    member procedure put_value( key_str in varchar2, val_str in boolean )
    as
        j json_object_t;
    begin
        if key_str is null
        then
            -- log.verbose( 'Attempting to set NULL Key' );
            return;
        end if;
        
        j := new json_object_t( json_clob );
        j.put(key_str, val_str);
        
        json_clob := j.to_clob();
    end put_value;

    member procedure put_value( key_str in varchar2, val_str in number )
    as
        j json_object_t;
    begin
        if key_str is null
        then
            -- log.verbose( 'Attempting to set NULL Key' );
            return;
        end if;
        
        j := new json_object_t( json_clob );
        j.put(key_str, val_str);
        
        json_clob := j.to_clob();
    end put_value;

    member procedure put_value( key_str in varchar2, val_str in date )
    as
        j json_object_t;
    begin
        if key_str is null
        then
            -- log.verbose( 'Attempting to set NULL Key' );
            return;
        end if;
        
        j := new json_object_t( json_clob );
        j.put(key_str, val_str);
        
        json_clob := j.to_clob();
    end put_value;

    member procedure put_value( key_str in varchar2, val_hash in out nocopy Hash_t )
    as
        j json_object_t;
        k json_object_t;
    begin
        -- validate input
        if key_str is null
        then
            -- log.verbose( 'Attempting to set NULL Key' );
            return;
        end if;
        
        -- convert val_hash
        if val_hash is not null
        then
            k := new json_object_t( val_hash.json_clob );
        else
            k := new json_object_t();
        end if;
        
        -- update SELF
        j := new json_object_t( json_clob );
        j.put(key_str, k);
        
        json_clob := j.to_clob();
    end put_value;
    
    member function  get_string( key_str in varchar2 ) return varchar2
    as
        j json_object_t;

        k              JSON;
        real_key       varchar2(200);
        corrected_path varchar2(4000);

        ret_val varchar2(4000);
    begin
        if key_str is null
        then
            -- log.verbose( 'Fetching NULL Key' );
            return null;
        end if;

        if instr( key_str, '.' ) = 0
        then
            j := new json_object_t( json_clob );
            
            if j.has(key_str) then
                ret_val := j.get_string( key_str );
            end if;
        else
            k := JSON ( json_clob );
            
            -- correct search path
            corrected_path := key_str;
            
            if corrected_path like '@.%'
            then
                raise zero_divide;
            elsif corrected_path not like '$.%'
            then
                real_key := '$.' || corrected_path;
            else
                real_key := corrected_path;
            end if;
            
            if json_exists( k, real_key ) -- check path
            then
                ret_val := json_value( k, real_key );
            else
                ret_val := null;
            end if;
        end if;
    
        return ret_val;
    end get_string;
        
    member function  get_boolean( key_str in varchar2 ) return boolean
    as
        j json_object_t;

        k              JSON;
        real_key       varchar2(200);
        corrected_path varchar2(4000);

        ret_val boolean;
    begin
        if key_str is null
        then
            -- log.verbose( 'Fetching NULL Key' );
            return null;
        end if;

    
        j := new json_object_t( json_clob );
        
        if j.has(key_str) then
            ret_val := j.get_boolean( key_str );
        end if;
    
        return ret_val;
    end get_boolean;

    member function  get_number( key_str in varchar2 ) return number
    as
        j json_object_t;

        k              JSON;
        real_key       varchar2(200);
        corrected_path varchar2(4000);

        ret_val number;
    begin
        if key_str is null
        then
            -- log.verbose( 'Fetching NULL Key' );
            return null;
        end if;

    
        j := new json_object_t( json_clob );
        
        if j.has(key_str) then
            ret_val := j.get_number( key_str );
        end if;
    
        return ret_val;
    end get_number;

    member function  get_date( key_str in varchar2 ) return date
    as
        j json_object_t;

        k              JSON;
        real_key       varchar2(200);
        corrected_path varchar2(4000);

        ret_val date;
    begin
        if key_str is null
        then
            -- log.verbose( 'Fetching NULL Key' );
            return null;
        end if;

    
        j := new json_object_t( json_clob );
        
        if j.has(key_str) then
            ret_val := j.get_date( key_str );
        end if;
    
        return ret_val;
    end get_date;
    
    member function  get_hash( key_str in varchar2 ) return Hash_t
    as
        j json_object_t;
        k json_object_t;
        ret_val Hash_t;
    begin
        if key_str is null
        then
            -- log.verbose( 'Fetching NULL Key' );
            return null;
        end if;

    
        j := new json_object_t( json_clob );
        k := j.get_object( key_str );
        
        ret_val := new Hash_t();
        ret_val.json_clob := k.to_clob();

        return ret_val;
    end get_hash;
    
    member function  get_array( key_str in varchar2 ) return json_array_t
    as
        j json_object_t;
        k json_object_t;
        ret_val json_array_t;
        current_key varchar2(1000);
        current_path varchar2(1000);
        final_key varchar2(1000);
    begin
        if key_str is null
        then
            -- log.verbose( 'Fetching NULL Key' );
            return null;
        end if;
        
        j := new json_object_t( json_clob );

        if key_str not like '%.%'
        then    
          final_key := key_str;
        else
          current_path := key_str;

          <<find_last>>
          LOOP
            current_key := MKLibrary.JSON_Path_utils.lpop_path( current_path );
            -- dbms_output.put_line( 'Hash - start key "' || current_key || '"' );

            if j.get_type( current_key ) = 'OBJECT'
            then
              j := j.get_object( current_key );
            else
              exit find_last;
            end if;

            current_path := MKLibrary.JSON_Path_utils.ltrim_path( key_str );
          end loop find_last;

          final_key := current_key;
        end if;
        

        <<assert_return>>
        if j.get_type( final_key ) = 'ARRAY'
        then
            -- dbms_output.put_line( 'Fond an ARRAY');
          ret_val := j.get_array( final_key );
        else
            -- dbms_output.put_line( 'no ARRAY :(');
          ret_val := new json_array_t();
        end if;

        return ret_val;
    EXCEPTION
        when others THEN
            return new json_array_t();        
    end get_array;

    
    member function key_exists( key_str in varchar2 ) return boolean
    as
        j json_object_t;
    begin
        if key_str is null
        then
            -- log.verbose( 'Fetching NULL Key' );
            return null;
        end if;
    
        j := new json_object_t( json_clob );
        
        return j.has(key_str);
    end key_exists;

    member procedure merge_other( self in out nocopy Hash_t, new_hash in out nocopy Hash_t, name_prefix in varchar2 default null )
    as
        j_self  json_object_t;
        j_sub   json_object_t;
        j_other json_object_t;
        k       json_key_list;
    begin
        -- validate input
        if new_hash.json_clob is null
        then
            return;
        end if;
        
        if self.json_clob is null
        then
            self := new_hash;
        end if;
        
        j_self  := new json_object_t( self.json_clob );
        j_other := new json_object_t( new_hash.json_clob );
        
        k := j_other.get_keys;
        
        if name_prefix is not null
        then
            j_sub := new json_object_t;
            
            for val in values of k
            loop
                j_sub.put( val, j_other.get_string(val) );
            end loop;
            
            j_self.put( name_prefix, j_sub );
        else
            for val in values of k
            loop
                j_self.put( val, j_other.get_string(val) );
            end loop;
        end if;
    end;

end Hash_t;
/
