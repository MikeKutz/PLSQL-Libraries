create or replace
type STDOUT_t
    authid current_user
as object (
    /* SQL Object used by code generating PL/SQL block.
    *   Treat as if it is a STDOUT buffer
    *   
    *   A UDT to allow easy programming of recursive template generator
    *   
    * @headcom
    */
        
    indent_depth   int, -- init := 1;
    code_clob      CLOB_Array,
    tab_pos        INT_Array,
    
    constructor function STDOUT_t( self in out nocopy STDOUT_t )  return self as result,
    
    /* txt >> STDOUT */
    member procedure p( self in out nocopy STDOUT_t, val in number, do_ltrim in boolean default false),
    member procedure p( self in out nocopy STDOUT_t, val in varchar2, do_ltrim in boolean default false  ),
    member procedure p( self in out nocopy STDOUT_t, val in clob, do_ltrim in boolean default false  ),
    
    /* indents entire block of code */
    member procedure start_indent( self in out nocopy STDOUT_t ),
    member procedure end_indent( self in out nocopy STDOUT_t ),
    
    /* entire block is treated as a block comment
       it DOES NOT indent
    */
    member procedure start_block_comment( self in out nocopy STDOUT_t ),
    member procedure end_block_comment( self in out nocopy STDOUT_t ),

    /* RTRIMs whitespace from current code.
       this includes only SPACE, TAB, CR, LF charaters
    */
    member procedure rtrim_whitespace( self in out nocopy STDOUT_t ),

    /* returns the current column possition of last line of the buffer */
    member function get_last_line_length( self in out nocopy STDOUT_t ) return int,

    
    /* sets current possition as tab #x */
    member procedure set_tab( self in out nocopy STDOUT_t, i int ),
    
    /* spaces to tab #x (or not if overreached) */
    member procedure goto_tab( self in out nocopy STDOUT_t, i int ),
    
    /* clears all STDOUT buffers */
    member procedure clear_buffer( self in out nocopy STDOUT_t ),

    /* resets all tab positions to 1 */
    member procedure clear_tab_positions( self in out nocopy STDOUT_t ),

    /* returns STDOUT
        calls `end_indent` as needed
    */
    member function get_code_clob( self in out nocopy STDOUT_t ) return clob
);
/
