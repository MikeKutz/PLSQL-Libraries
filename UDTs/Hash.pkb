create or replace
type body "Hash"
as
    constructor function "Hash" return self as result
    as
        j json_object_t;
    begin
        j := new json_object_t();
        
        self.json_clob := j.to_clob;
        
        return;
    end "Hash";
    
    member procedure reset_properties
    as
    begin
        self := new "Hash"();
    end reset_properties;
    
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

    member procedure put_value( key_str in varchar2, val_hash in out nocopy "Hash" )
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
        ret_val varchar2(4000);
    begin
        if key_str is null
        then
            -- log.verbose( 'Fetching NULL Key' );
            return null;
        end if;

    
        j := new json_object_t( json_clob );
        
        if j.has(key_str) then
            ret_val := j.get_string( key_str );
        end if;
    
        return ret_val;
    end get_string;
        
    member function  get_boolean( key_str in varchar2 ) return boolean
    as
        j json_object_t;
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
    
    member function  get_hash( key_str in varchar2 ) return "Hash"
    as
        j json_object_t;
        k json_object_t;
        ret_val "Hash";
    begin
        if key_str is null
        then
            -- log.verbose( 'Fetching NULL Key' );
            return null;
        end if;

    
        j := new json_object_t( json_clob );
        k := j.get_object( key_str );
        
        ret_val := new "Hash";
        ret_val.json_clob := k.to_clob();

        return ret_val;
    end get_hash;

    
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

    member procedure merge_other( self in out nocopy "Hash", new_hash in out nocopy "Hash", name_prefix in varchar2 default null )
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

end "Hash";
/
