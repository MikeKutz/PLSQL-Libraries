create or replace
type "Iterator"
    authid current_user
as object
(
    json_clob  clob,
    i          int,
    max_i      int,

    constructor function "Iterator" return self as result,
    constructor function "Iterator"( c in out nocopy sys_refcursor) return self as result,

    /* initialize outside of Constructor Functions */
    member procedure init_new,
    
    /* cache results of a sys_refcursor into an array of "Hash" values */
    member procedure initialize ( self in out nocopy "Iterator", c in out nocopy sys_refcursor ),
    
    /* iterates the "current element" */
    member procedure get_next,
    
    /* returns the "current element */
    member function get_current_row return "Hash",
    
    /* returns "next element" (iterates and returns) */
    member function pipe_row( self in out "Iterator" ) return "Hash",
    
    /* memory clean-up (reserved for future use) */
    member procedure garbage_collection,
    
    /* are there more elements in the array? */
    member function has_more return boolean
);
/
