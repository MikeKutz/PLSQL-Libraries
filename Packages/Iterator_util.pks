create or replace
package Iterator_util
  authid definer
as
  function Hash_array_to_Iterator( h MKLibrary.hash_t, key_str varchar2 ) return MKLibrary.Iterator_t;

end Iterator_util;
/
