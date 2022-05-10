create or replace
package generate_series
    authid definer
as
    /* package of SQL_MACROS for generating series of values
    *
    * @headcom
    */
    
    /* Generates a series of integers.
    *
    * @param   start_value initial integer
    * @param   n           The number of row to generate
    * @return              Series of integers
    */
    function of_numbers( start_value in int, n in int ) return varchar2 SQL_MACRO(TABLE);

    /* Generates a series of integers.
    *
    * @param   start_value initial date
    * @param   n           The number of row to generate
    * @return              Series of integers
    */
    function of_dates( start_value in date, n in int ) return varchar2 SQL_MACRO(table);
end;
/

create or replace
package body generate_series
as
    function of_numbers( start_value in int, n in int ) return varchar2 SQL_MACRO(TABLE)
    as
    begin
        return q'[select of_numbers.start_value + (level - 1) number_series
        from dual
        connect by level <= of_numbers.n]';
    end;
    
    function of_dates( start_value in date, n in int ) return varchar2 SQL_MACRO(table)
    as
    begin
        return q'[select of_dates.start_value + (level - 1)  date_series
        from dual
        connect by level <= of_dates.n]';
    end;
end;
/
