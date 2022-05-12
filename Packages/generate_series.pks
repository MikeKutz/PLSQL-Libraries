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

    /* Generates a series of days. (value is truncated to the DAY)
    * 
    * column | desc
    * ------|------
    * day_start | truncated date
    * day_end | ceiling date
    * day_period_end | truncated next day. for use in PERIOD FOR
    * day_n | 1-based element identity
    * day_n_0 | 0-based element identity
    *
    * @param   start_value initial date
    * @param   n           The number of row to generate
    * @return              Series of trunc(day) DATE_SERIES
    */
    function of_days( start_value in date, n in int ) return varchar2 SQL_MACRO(table);
    
    /* Generates a series of months. (value is truncated to the MONTH)
    *
    *  coumn | desc
    *  ------|-------
    *  month_start | 1st day of the month
    *  month_end | last day of the month
    *  month_period_end | 1st day of the next month. For use in PERIOD FOR
    *  month_n | 1-based element identity
    *  month_n_0 | 0-based element idenity
    *
    * @param   start_value initial date
    * @param   n           The number of row to generate
    * @return              Series of integers
    */
    function of_months( start_value in date, n in int ) return varchar2 SQL_MACRO(table);

    /* Generates a series of weeks.
    *  `week` defined by NLS Territory of session
    *
    *  coumn | desc
    *  ------|-------
    *  week_start | 1st day of the week | WW
    *  week_end | last day of the month
    *  week_period_end | 1st day of the next week. For use in PERIOD FOR
    *  week_n | 1-based element identity
    *  week_n_0 | 0-based element idenity
    *  iso_week | ISO 8601 week of year NUMBER(2) | IW
    *  iso_yeak | ISO 8601 year NUMBER(4) | IYYYY
    *  oracle_quarter | Oracle quarter | Q
    *
    * @param   start_value initial date
    * @param   n           The number of row to generate
    * @return              Series of integers
    */
    function of_weeks( start_value in date, n in int ) return varchar2 SQL_MACRO(table);

end;
/
