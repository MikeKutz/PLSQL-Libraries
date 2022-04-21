create or replace
package ut_hash_t
    authid current_user
as
    --%suite( Testing Hash_t )
    --%suitepath( MKLibrary.hash_t )
    
    --%test( set and fetch string )
    procedure test_simple;

    --%test( set and fetch date )
    procedure test_set_get_date;

    --%test( set and fetch boolean )
    procedure test_set_get_boolean;

    --%test( set and fetch number )
    procedure test_set_get_number;
    
    --%test( Set and Fetch Multiple )
    procedure test_multiple_keys;
    
    --%test( Update Value )
    procedure test_update;
    
    --%test( Missing Key returns NULL )
    procedure test_missing;
    
    --%test( Testing Setting NULL keys )
    procedure test_null;
    
end ut_hash_t;
/
