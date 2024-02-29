clear screen;
set serveroutput on;
declare
  json_txt clob := '{"acl":"hr_acl","aces":[{"principal":"hr_representive","privileges":["insert","update","select","delete","show_salary"]}]}';
  h        MKLibrary.Hash_t := new MKLibrary.Hash_t;
  h2       MKLibrary.Hash_t;
  v     varchar2(400);
  
  ja  json_array_t;
  j   json_object_t;
  je  json_element_t;
  
  j_dest_array json_array_t := new json_array_t();
  j_dest_object json_object_t := new json_object_t();
  
begin
  h.json_clob := json_txt;
  
--  j := JSON( json_txt );
-- BROKEN  h2 := h.get_hash( 'aces[0]' );
-- FAILS   v := h.get_string( 'aces' );
-- FAILS   v := h.get_string( 'aces[0]' );
  v := h.get_string( 'aces[0].principal' ); -- this works
  v := h.get_string( 'aces[0].privileges[0]' ); -- this works

  dbms_output.put_line( 'aces === %' ||v || '%' );

  ja := json_object_t( json_txt).get_array( 'aces' );

  dbms_output.put_line( 'is this and array? '  || json_object_t( json_txt).get_type( 'aces' ) );
  dbms_output.put_line( 'is this and ??? '  || json_object_t( json_txt).get_type( 'aces' ) );
  -- arry count?
  
  dbms_output.put_line( ja.get_size() );  

  for i in 1 .. ja.get_size()
  loop
    j := new json_object_t( ja.get( i - 1 ) );
    dbms_output.put_line( '[' || i || '] : principal = ' || j.get_string( 'principal' ) ) ;
  end loop;
  
  j := new json_object_t();
  j.put( 'city', 'gso' );
  j_dest_array.append( j );
  j_dest_object.put( 'data', j_dest_array );
  dbms_output.put_line( j_dest_object.to_string() );
  dbms_output.put_line( 'that is all folks!' );
end;
/

