create or replace
type body STDOUT_t
is

    CONSTRUCTOR function STDOUT_t( self in out nocopy STDOUT_t ) return self as result
    as
    begin
        indent_depth := 1;
        self.clear_buffer; -- sets i=1
        self.clear_tab_positions;
        
        return;
    end STDOUT_t;

    member procedure merge_other( self in out nocopy STDOUT_t, other_obj in out nocopy STDOUT_t )
    as
    begin
        self.p( other_obj.get_output_clob() );
    end merge_other;

    member procedure p( self in out nocopy STDOUT_t, val number, do_ltrim boolean default false  )
    as
    begin
        -- ignore for number
        if output_clob.exists( indent_depth )
        then
            output_clob( indent_depth )  := output_clob( indent_depth ) || to_char( val );
        else
            output_clob(indent_depth ) := to_char( val );
        end if;
    end p;
    
    member procedure p( self in out nocopy STDOUT_t, val varchar2, do_ltrim boolean default false  )
    as
        clean_val varchar2(32767);
    begin
        if do_ltrim
        then
            clean_val := regexp_replace( val, '^' || MKLibrary.Constants.regexp_whitespace );
        else
            clean_val := val;
        end if;
        
        if output_clob.exists( indent_depth )
        then
            output_clob( indent_depth )  := output_clob( indent_depth ) || clean_val;
        else
            output_clob(indent_depth ) :=  clean_val ;
        end if;
    end p;

    member procedure p( self in out nocopy STDOUT_t, val clob, do_ltrim boolean default false  )
    as
        clean_val varchar2(32767);
    begin
        if do_ltrim
        then
            clean_val := regexp_replace( val, '^' || MKLibrary.Constants.regexp_whitespace  );
        else
            clean_val := val;
        end if;

        if output_clob.exists( indent_depth )
        then
            output_clob( indent_depth )  := output_clob( indent_depth ) || clean_val;
        else
            output_clob(indent_depth ) :=  clean_val ;
        end if;
    end p;

/******************************************************************************
               CLOB STUFF
*******************************************************************************/
    member procedure rtrim_whitespace( self in out nocopy STDOUT_t )
    as
    begin
        if output_clob.exists(indent_depth)
        then
            MKLibrary.CLOB_Utils.rtrim_whitespace( output_clob( indent_depth ) );
        end if;
    end rtrim_whitespace;

    /* returns the current column possition of last line of the buffer */
    member function get_last_line_length( self in out nocopy STDOUT_t ) return int
    as
    begin
        -- if there are no \n => use current length
        if instr( output_clob( indent_depth ), chr(10) ) = 0
        then
            return length( output_clob( indent_depth ) );
        end if;
        
        -- this should probably be RETURN 1
        -- may not calculate correctly with regexp method
        if  output_clob( indent_depth ) like '%' || chr(10)
        then
            return 0;
        end if;

        -- current cursor column = Total Length - Posistion of last \n
        -- regexp = '\n[^\n]*$'
        return length( output_clob( indent_depth ) ) - regexp_instr( output_clob( indent_depth ), chr(10) || '[^' || chr(10) || ']*$' );
    end get_last_line_length;
    
    member function get_line_count( self in out nocopy STDOUT_t ) return int
    as
        total int := 0;
    begin
        -- count number of \n in 
        for i in 1 .. indent_depth
        loop
            total := total + regexp_count( output_clob( i ), chr(10) );
        end loop;
        
        return total;
    end get_line_count;

    member function get_output_clob( self in out nocopy STDOUT_t ) return clob
    as
    begin
        -- fix OOPS if unmatched "start/end_indent"
        while (indent_depth > 1)
        loop
            end_indent;
        end loop;
        
        if not output_clob.exists(1)
        then
            return null;
        end if;
        
        return output_clob(1);
    end get_output_clob;


/******************************************************************************
               GENERATOR INDENTIONS
*******************************************************************************/
    
    member procedure start_indent( self in out nocopy STDOUT_t )
    as
    begin
        indent_depth := indent_depth + 1;
        
        if indent_depth > 100 -- g_max_indention_level
        then
            raise_application_error( -20005, 'To many indentions' );
        end if;
        
        output_clob(indent_depth) := null;
    end start_indent;
    
    member procedure end_indent( self in out nocopy STDOUT_t )
    as
    begin
        if output_clob.exists( indent_depth )
        then
            -- indent buffer results
            output_clob( indent_depth ) :=
                regexp_replace( output_clob( indent_depth ) , '^'
                                ,'    ', 1, 0, 'm' );
        end if;
        
        if indent_depth > 1
        then
            -- indention level decrement
            indent_depth := greatest( indent_depth - 1, 1);
    
            -- append the upper indetion results to the lower one
            output_clob( indent_depth ) := output_clob( indent_depth ) || output_clob( indent_depth + 1 );
    
            -- clean upper (do we need to?)
            -- TBD
        end if;
    end end_indent;
    
    member procedure start_block_comment( self in out nocopy STDOUT_t )
    as
    begin
        start_indent;
    end start_block_comment;
    
    member procedure end_block_comment( self in out nocopy STDOUT_t )
    as
    begin
        if output_clob.exists( indent_depth )
        then
            -- indent buffer results
            output_clob( indent_depth ) :=
                regexp_replace( output_clob( indent_depth ) , '^'
                                ,'* ', 1, 0, 'm' );
        end if;
        
        if indent_depth > 1
        then
            -- indention level decrement
            indent_depth := greatest( indent_depth - 1, 1);
    
            -- append the upper indetion results to the lower one
            output_clob( indent_depth ) := output_clob( indent_depth ) || '/**' || output_clob( indent_depth + 1 ) || '**/';
        end if;
    end end_block_comment;

/******************************************************************************
               SIMULATE TABS
*******************************************************************************/

    /* sets current possition as tab #x */
    member procedure set_tab( self in out nocopy STDOUT_t, i int )
    as
    begin
        if i < 1 then return; end if;
        
        tab_pos(i) := get_last_line_length;
    end set_tab;
    
    /* spaces to tab #x (or not if overreached) */
    member procedure goto_tab( self in out nocopy STDOUT_t, i int )
    as
       current_pos int;
    begin
        if i < 1 then return; end if;

        current_pos := get_last_line_length;
        if tab_pos.exists(i)
        then
            if current_pos < tab_pos(i)
            then
                p( rpad( ' ', tab_pos(i) - current_pos, ' ' ) );
            end if;
        end if;
    end goto_tab;    

/******************************************************************************
               RESET GLOBALS
*******************************************************************************/

    member procedure clear_buffer( self in out nocopy STDOUT_t )
    as
    begin
--        clear_tab_positions;
        indent_depth := 1;
        
        if output_clob is null
        then
            output_clob := new CLOB_Array();
        else
            output_clob.delete;
        end if;

        output_clob.extend(100);
    end clear_buffer;
    
    member procedure clear_tab_positions( self in out nocopy STDOUT_t )
    as
    begin
        if tab_pos is null
        then
           tab_pos := new INT_Array();
        else
            tab_pos.delete;
        end if;

        tab_pos.extend(1);
        tab_pos(1) := 1;
        tab_pos.extend(100 - 1, 1);
        
    end clear_tab_positions;
end STDOUT_t;
/

