create or replace
package body ut_hash_t
as
    --%suite( Testing Hash_t )
    --%suitepath( MKLibrary.Hash_t )
    
    --%test( set and fetch )
    procedure test_simple
    as
        actual    varchar2(200);
        expected  varchar2(200) := 'world';
        key_str   varchar2(200) := 'hello';
        p         MKLibrary.Hash_t;
    begin
        p := new MKLibrary.Hash_t();
        
        p.put_value( key_str, expected );
        actual := p.get_string( key_str );
        
        ut.expect(actual).to_equal(expected);
    end test_simple;
    
    --%test( Set and Fetch Multiple )
    procedure test_multiple_keys
    as
        actual    varchar2(200);
        expected  varchar2(200) := 'world';
        key_str   varchar2(200) := 'hello';
        p         MKLibrary.Hash_t;
    begin
        p := new MKLibrary.Hash_t();

        for i in 1 .. 10
        loop
            p.put_value( key_str || to_char( i, '000'), expected || to_char( i, '000') );
        end loop;
        
        for i in 1 .. 10
        loop
            actual := p.get_string( key_str || to_char( i, '000') );
            ut.expect(actual).to_equal(expected || to_char( i, '000'));
        end loop;
    end test_multiple_keys;
    
    --%test( Update Value )
    procedure test_update
    as
        actual    varchar2(200);
        expected  varchar2(200) := 'world';
        key_str   varchar2(200) := 'hello';
        p         MKLibrary.Hash_t;
    begin
        p := new MKLibrary.Hash_t();

        for i in 1 .. 10
        loop
            p.put_value( key_str, expected || to_char( i, '000') );
        end loop;

        
        p.put_value( key_str, expected );
        actual := p.get_string( key_str );
        
        ut.expect(actual).to_equal(expected);
    end test_update;
    
    --%test( Missing Key returns NULL )
    procedure test_missing
    as
        actual    varchar2(200);
        expected  varchar2(200) := null;
        key_str   varchar2(200) := 'hello';
        p         MKLibrary.Hash_t;
    begin
        p := new MKLibrary.Hash_t();
        
        actual := p.get_string( key_str );
        
        ut.expect(actual).to_equal(expected);
    end test_missing;

    procedure test_null
    as
        actual    varchar2(200);
        expected  varchar2(200) := null;
        key_str   varchar2(200) := null;
        p         MKLibrary.Hash_t;
    begin
        p := new MKLibrary.Hash_t();
        
        p.put_value( null, 'y');
        actual := p.get_string( key_str );
        
        ut.expect(actual).to_equal(expected);
    end test_null;

    --%test( Set and Fetch Number)
    procedure test_set_get_number
    as
        actual    number;
        expected  number;
        key_str   varchar2(20) := 'test';
        p         MKLibrary.Hash_t;
    begin
        p := new MKLibrary.Hash_t();
        
        p.put_value( key_str, 3.14159 );
        ut.expect( p.get_number( key_str ) ).to_equal( 3.14159 );

        p.put_value( key_str, 2.99e8 );
        ut.expect( p.get_number( key_str ) ).to_equal( 2.99e8 );
        
    end;
    
    --%test( Set and Fetch Boolean)
    procedure test_set_get_boolean
    as
        actual    boolean;
        expected  boolean;
        key_str   varchar2(20) := 'test';
        p         MKLibrary.Hash_t;
    begin
        p := new MKLibrary.Hash_t();
        
        p.put_value( key_str, true );
        ut.expect( p.get_boolean( key_str ) ).to_equal(true);

        p.put_value( key_str, false );
        ut.expect( p.get_boolean( key_str ) ).to_equal(false);

        p.put_value( key_str, cast(null as boolean) );
        ut.expect( p.get_boolean( key_str ) ).to_equal( cast(null as boolean) );
    end;
    
    --%test( Set and Fetch Date)
    procedure test_set_get_date
    as
        expected  date;
        key_str   varchar2(20) := 'test';
        p         MKLibrary.Hash_t;
    begin
        p := new MKLibrary.Hash_t();

        expected := to_date( '5-Nov-1955 11:05:30', 'dd-mon-yyyy hh24:mi:ss' );
        p.put_value( key_str, expected );
        ut.expect( p.get_date( key_str ) ).to_equal(expected);

    end;


end ut_hash_t;
/
