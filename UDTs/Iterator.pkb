create or replace
type body Iterator_t
as
    /*
        `i` is 0 based. It represents "current element of array"
        if i<0, then "first element" has not been fetched.
        
        `max_i` indicates maximum value of `i`.
        
        `json_clob` holds the array of `Hash_t`. format it:
        
        {
            data:[
                {key1:val1, key2:val2, ...},
                {key1:val1, key2:val2, ...},
                ...
            ]
        }
    */
    
    constructor function Iterator_t return self as result
    as
    begin
        self.init_new;
    
        return;
    end Iterator_t;

    constructor function Iterator_t( c in out nocopy sys_refcursor) return self as result
    as
    begin
        self.init_new;
        self.initialize( c );
        
        return;
    end Iterator_t;

    constructor function Iterator_t( h Hash_t, k varchar2 ) return self as result
    as
    BEGIN
        self := MKLibrary.Iterator_util.Hash_array_to_Iterator( h, k );
        
        return;
    end;

    /* assertion of underlying JSON */
    member procedure assert
    as
    begin
        /*
          pull JSON schema from Iterator_util package
          and/or use a Domain
        */
        null;
    end assert;
    
    member procedure init_new
    as
        j  json_object_t;
        k  json_array_t;
    begin
        -- initialize "json_clob"
        j := new json_object_t();
        k := new json_array_t();
        j.put( 'data', k );
        
        self.i := null;
        self.json_clob := j.stringify;
        
        -- ensure counters are not initialize
        i := null;
        max_i := null;
    end init_new;
    
    member procedure initialize ( self in out nocopy Iterator_t, c in out nocopy sys_refcursor )
    as
        j       json_object_t;
        k       json_array_t;
    begin
        -- convert cursor to JSON
        apex_json.initialize_clob_output();

        apex_json.open_object;
        apex_json.write('data', c );
        apex_json.close_object;
        
        self.json_clob := apex_json.get_clob_output();

        -- initialize "current element"
        self.i := -1;
        
        -- discover "max_i" from array
        j := json_object_t( json_clob );
        k := j.get_array( 'data' );
        max_i := k.get_size;
        
        max_i := max_i - 1;

        
    end initialize;
    
    member procedure get_next
    as
    begin
        -- i++
        self.i := nvl(self.i + 1,0);
        
        -- check for improper initialization
        if i < 0
        then
            i := 0;
        end if; -- underflow

        -- check if uninitialized
        if max_i is null
        then
            raise_application_error( -20000, 'Iterator not initialize' );
        end if;
        
        -- check for out of bounds
        if i > max_i
        then
            raise no_data_found;
        end if;
        
    end get_next;
    
    member function get_current_row return Hash_t
    as
        j       json_object_t;
        k       json_array_t;
        d       json_object_t;
        ret_val Hash_t;
    begin
        -- validate input
        if i < 0 or i is null or max_i is null
        then
            return null;
        end if;
        
        
        -- pull out element from array
        j := json_object_t( json_clob );
        k := j.get_array( 'data' );
        d := TREAT(k.get(i) AS JSON_OBJECT_T);
        
        -- copy into the Return Value
        ret_val := new Hash_t();
        ret_val.json_clob := d.to_clob();
        
        return ret_val;
    end get_current_row;
    
    member function pipe_row( self in out nocopy Iterator_t) return Hash_t
    as
    begin
        -- if there are more rows, iterate and return "current row"
        if self.has_more
        then
            self.get_next;
            
            return self.get_current_row;
        else
            raise no_data_found;
        end if;
    end pipe_row;

    member procedure garbage_collection
    as
    begin
        -- currently, just resets itself
        self := new Iterator_t();
    end garbage_collection;
    
    member function has_more return boolean
    as
    begin
        -- check for outliar cases
        if max_i is null or i is null
        then
            return false;
        end if;
        
        return self.i < self.max_i;
    end has_more;
end Iterator_t;
/
