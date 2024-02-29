create or replace
package Iterator_util
  authid definer
as
  function Hash_array_to_Iterator( h MKLibrary.hash_t, key_str varchar2 ) return MKLibrary.Iterator_t;

end Iterator_util;
/

create or replace
package body Iterator_util
as
  function Hash_array_to_Iterator( h MKLibrary.hash_t, key_str varchar2 ) return MKLibrary.Iterator_t
  as
    l_og_json    json_object_t;
    l_json_array json_array_t;
    array_size  int;
    
    log_reason   varchar2(4000);
    return_value MKLibrary.Iterator_t := new MKLibrary.Iterator_t();
    
    function convert_array_of_objects return MKLibrary.Iterator_t
    as
      j       json_object_t := new json_object_t();
      ret_val MKLibrary.Iterator_t := new MKLibrary.Iterator_t();
    begin
      j.put( 'data', l_json_array );
      ret_val.max_i := array_size - 1;
      
      
      
      ret_val.json_clob := j.to_string();
  
      return ret_val;
    end convert_array_of_objects;
    
    /* POTENTIAL BUG: Null Elements */
    function convert_array_of_scalars return MKLibrary.Iterator_t
    as
      j       json_object_t := new json_object_t();
      ja      json_array_t  := new json_array_t();
      
      ret_val MKLibrary.Iterator_t := new MKLibrary.Iterator_t();
    begin
      for i in 1 .. array_size
      loop
        declare
          lj json_object_t := new json_object_t();
          v  varchar2(1000);
        begin
          v := l_json_array.get_string( i-1 );
  
          lj.put('value', v );
          ja.append( lj );
        end;
      end loop;
    
      j.put( 'data', ja );
      
      ret_val.json_clob := j.to_string();
      ret_val.max_i     := array_size - 1;

      return ret_val;
    end convert_array_of_scalars;
    
  begin
    /** Algorithm
    1. assert key is an array
      json_object_t.get_type = 'ARRAY'
    2. get array
      json_object_t.get_array( key );
    3. get array size
      json_array_t.get_size
    assert size >= 1
    get type
      json_array_t.get_type( 0 ) TEST
    case detected_type
      'object'
        new json_object_t()
        json_object_t.put( 'data', OG json_array_t )
        -- set as Iterator and return
      'SCALAR' ??
        new json_array_t()
        loop 1 .. size
          new json_object_t
          json_obj_t.object.put('value',val)
          -- put record #
          json_array_t.append( json_obj_t )
        end loop
        json_object_t.put( 'data', ND json_array_t )
        -- set as Iterator and return
    */
    
    <<assert_input>>
    begin
      if key_str is null
      then
        log_reason := 'KEY is NULL';
        goto EOF;
      end if;
      
      l_og_json := json_object_t( h.json_clob );
      if l_og_json.get_type( key_str ) != 'ARRAY'
      then
        log_reason := 'key does not point to an array';
        goto EOF;
      end if;
    end assert_input;
    
    <<fetch_and_assert_array>>
    begin
      l_json_array := l_og_json.get_array( key_str );
      array_size := l_json_array.get_size;
      
      if not array_size >= 1
      then
        log_reason := 'No elements in array';
        goto EOF;
      end if;
    end fetch_and_assert_array;
    
    <<process_array>>
    case l_json_array.get_type( 0 ) -- this logic need to be verified as correct
      when 'OBJECT' then
        log_reason := 'Returning found Objects';
        return_value := convert_array_of_objects;
      when 'SCALAR' then
        log_reason := 'Returning found Scalars';
        return_value := convert_array_of_scalars;
      else
        log_reason := 'Not an array of Scalar or Objects';
        -- use default value
    end case process_array;
  
    <<EOF>>
    begin
      -- log.debug( log_reason );
      dbms_output.put_line( 'Hash2Interate:' ||  log_reason ); -- needs code prefix $$value
      -- assert return_value
      return return_value;
    end eof;
  end Hash_array_to_Iterator;
end Iterator_util;
/
