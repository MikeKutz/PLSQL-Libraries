create or replace
type Iterator_t
    authid current_user
as object
(
    /**
    * Iterator_t
    *
    * Allows PL/SQL code to iterate over a collection of `Hash_t`
    *
    * This uses `APEX_JSON` under the hood.
    *
    * Input is a `SYS_REFCURSOR`.
    * `LONG` data types are viewed as Strings.
    *
    * declare
    *   i Iterator_t;
    *   h Hash_t;
    *   c sys_refcursor;
    * begin
    *   open c for select * from user_tables;
    *
    *   i := new Iterator(c);
    *   while (i.has_more)
    *   loop
    *       h := i.pop_row;
    *       dbms_output.put_line( h.get_string( 'DEFAULT_DATA' );
    *   end loop;
    * end;
    * /
    * 
    *
    * @headcom
    */
    json_clob  clob,
    i          int,
    max_i      int,

    constructor function Iterator_t return self as result,
    constructor function Iterator_t( c in out nocopy sys_refcursor) return self as result,

    /* key `k` must point to an array
     *
     * If the array elements are Objects, each iteration is the Hash_t of a single element
     * If the array elements are Strings, each iteration is a Hash_t with key as 'valuew' -- may need to be VALUE
     */
    constructor function Iterator_t( h Hash_t, k varchar2 ) return self as result,

    /* assertion of underlying JSON */
    member procedure assert,

    /* initialize outside of Constructor Functions */
    member procedure init_new,
    
    /* cache results of a sys_refcursor into an array of Hash_t values */
    member procedure initialize ( self in out nocopy Iterator_t, c in out nocopy sys_refcursor ),
    
    /* iterates the "current element" */
    member procedure get_next,
    
    /* returns the "current element */
    member function get_current_row return Hash_t,
    
    /* returns "next element" (iterates and returns) */
    member function pipe_row( self in out Iterator_t ) return Hash_t,
    
    /* memory clean-up (reserved for future use) */
    member procedure garbage_collection,
    
    /* are there more elements in the array? */
    member function has_more return boolean
);
/
