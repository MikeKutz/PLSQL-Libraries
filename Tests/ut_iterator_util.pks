create or REPLACE
package ut_iterator_util
as
 --%suite(Iterator Utilities)
 --%suitepath(MKLibrary)

  --%test( Array of Objects )
  PROCEDURE works_for_object;

  --%test( Array of Strings )
  PROCEDURE works_for_string;

  --%test( empty Iterator on NULL Hash )
  --%disabled(Not implemented)
    PROCEDURE empty_null_hash;
  --%test( empty Iterator on NULL key )
  --%disabled(Not implemented)
  PROCEDURE empty_null_key;
  --%test( empty Iterator if key is not an array )
  --%disabled(Not implemented)
  PROCEDURE empty_not_array;
  --%test( empty Iterator if array has zero elements )
  --%disabled(Not implemented)
  PROCEDURE empty_0_array;
  --test( empty Iterator if array is not Scalar/Object)
  --%disabled( should not be logically possible)
  PROCEDURE empty_not_object_or_array;

  --%beforeall
  procedure init_pkg;

end ut_iterator_util;
/
