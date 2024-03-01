create or replace
package Iterator_util
  authid definer
as
  /*
   * Interator of an array of data within the Hash_t which is pointed  to by key_str
   *
   * @param  h  Hash_t of variables
   * @param  key_str    access to retrieve an array
   */
  function Hash_array_to_Iterator( h MKLibrary.hash_t, key_str varchar2 ) return MKLibrary.Iterator_t;

end Iterator_util;
/
