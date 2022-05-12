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
    
    function of_days( start_value in date, n in int ) return varchar2 SQL_MACRO(table)
    as
    begin
        return q'[select trunc(of_days.start_value) + (level - 1)  day_start
            ,trunc(of_days.start_value) + (level) - interval '1' second  day_end
            ,trunc(of_days.start_value) + (level)  day_period_end
            ,level day_n
            ,level -1 day_n_0
        from dual
        connect by level <= of_days.n]';
    end;

    function of_months( start_value in date, n in int ) return varchar2 SQL_MACRO(table)
    as
    begin
        return q'[select add_months( trunc( of_months.start_value, 'month' ), level - 1 )  month_start
            ,add_months( trunc( of_months.start_value, 'month' ), level ) - 1 month_end
            ,level month_n
            ,level -1 month_n_0
        from dual
        connect by level <= of_months.n]';
    end;

    function of_weeks( start_value in date, n in int ) return varchar2 SQL_MACRO(table)
    as
    begin
        return q'[select trunc(of_weeks.start_value) + 1 + (level -1) * 7 - to_number( to_char( trunc(of_weeks.start_value), 'D' ) ) week_start
                ,trunc(of_weeks.start_value) + 1 + (level -1) * 7 + 6 - to_number( to_char( trunc(of_weeks.start_value), 'D' ) ) week_end
                ,trunc(of_weeks.start_value) + 1 + (level -1) * 7 + 7 - to_number( to_char( trunc(of_weeks.start_value), 'D' ) ) week_period_end
                ,level week_n
                ,level - 1 week_n_0
                ,to_number( to_char( of_weeks.start_value + (level -1) * 7, 'IW' ) ) iso_week
                ,to_number( to_char( of_weeks.start_value + (level -1) * 7, 'IYYY' ) ) iso_year
                ,to_number( to_char( of_weeks.start_value + (level -1) * 7, 'Q' ) ) oracle_quarter
            from dual
            connect by level <= of_weeks.n]';
    end;
end;
/
