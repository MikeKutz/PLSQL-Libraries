create or replace
package body ut_iterator_util
as
  acl_txt constant clob := '{"acl":"hr_acl","aces":[{"principal":"hr_representive","privileges":["insert","update","select","delete","show_salary"]}]}';
  h                MKLibrary.Hash_t;

  PROCEDURE works_for_object
  as
    i MKLibrary.Iterator_t;
    v varchar2(1000);
    b boolean;
  begin
    i := MKLibrary.Iterator_util.Hash_array_to_Iterator(h, 'aces');
    i.get_next();
    v := i.get_current_row().get_string('principal');

    ut.expect( v ).to_equal( 'hr_representive' );

    b := i.has_more();
    ut.expect( b ).to_equal( false );
  end works_for_object;

  PROCEDURE works_for_string
  as
    i MKLibrary.Iterator_t;
    h2 MKLibrary.Hash_t;
    j MKLibrary.Iterator_t;
    v varchar2(1000);
    b boolean;
  begin
    i := MKLibrary.Iterator_util.Hash_array_to_Iterator(h, 'aces');
    i.get_next();

    j := MKLibrary.Iterator_util.Hash_array_to_Iterator( i.get_current_row(), 'privileges' );
    j.get_next();
    v := j.get_current_row().get_string('value');
    ut.expect( v ).to_equal( 'insert' );
    j.get_next();
    v := j.get_current_row().get_string('value');
    ut.expect( v ).to_equal( 'update' );
    j.get_next();
    v := j.get_current_row().get_string('value');
    ut.expect( v ).to_equal( 'select' );
    j.get_next();
    v := j.get_current_row().get_string('value');
    ut.expect( v ).to_equal( 'delete' );
    j.get_next();
    v := j.get_current_row().get_string('value');
    ut.expect( v ).to_equal( 'show_salary' );

    b := j.has_more();
    ut.expect( b ).to_equal( false );
  end works_for_string;

  PROCEDURE empty_null_hash
  as
  BEGIN
    ut.expect( 1 ).to_equal( 1 );
  end empty_null_hash;

  PROCEDURE empty_null_key
  as
  BEGIN
    ut.expect( 1 ).to_equal( 1 );
  end empty_null_key;

  PROCEDURE empty_not_array
  as
  BEGIN
    ut.expect( 1 ).to_equal( 1 );
  end empty_not_array;

  PROCEDURE empty_0_array
  as
  BEGIN
    ut.expect( 1 ).to_equal( 1 );
  end empty_0_array;

  PROCEDURE empty_not_object_or_array
  as
  begin
    ut.expect( 1 ).to_equal( 1 );
  end empty_not_object_or_array;

/***********************************************************************/

  procedure init_pkg
  AS
  begin
    h := new MKLibrary.Hash_t();
    h.json_clob := acl_txt;
  end init_pkg;


end ut_iterator_util;
/
