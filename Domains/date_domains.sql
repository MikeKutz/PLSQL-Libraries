-- oracle format
create domain if not exists date_oracle as varchar2(100)
    check ( to_date(date_oracle default null on conversion error, 'DD-MON-YYYY') is not null)
    ANNOTATIONS ( description 'validates string is in Oracle date format');

-- US format
create domain if not exists date_us as varchar2(100)
    check ( to_date(date_us default null on conversion error, 'MM/DD/YYYY') is not null)
    ANNOTATIONS ( description 'validates string is in US date format');

-- EU format
create domain if not exists date_eu as varchar2(100)
    check ( to_date(date_eu default null on conversion error, 'DD/MM/YYYY') is not null)
    ANNOTATIONS ( description 'validates string is in EU date format');

-- ISO format
create domain if not exists date_iso as varchar2(100)
    check ( to_date(date_iso default null on conversion error, 'YYYY-MM-DD') is not null)
    ANNOTATIONS ( description 'validates string is in ISO date format without time');

-- MONTH/YEAR formats
create domain if not exists date_my as varchar2(100)
    check ( to_date(date_my default null on conversion error, 'MM/YYYY') is not null)
    ANNOTATIONS ( description 'validates string is in MM/YYYY month-year format');

create domain if not exists date_y as varchar2(100)
    check ( regexp_like( date_y, '^[[:digit:]]{4}$'))
    ANNOTATIONS ( description 'validates string is a 4-digit year');

create flexible domain date_validate ( val )
        choose domain using ( p_type varchar2(10) ) from
        case lower(p_type)
            when 'oracle' then date_oracle(val)
            when 'us' then date_us(val)
            when 'eu' then date_eu(val)
            when 'iso' then date_iso(val)
            when 'year' then date_y(val)
            when 'my' then date_my(val)
        end;
--    annotations not supported for Flexible Domains (23.3 FREE)
--    ANNOTATIONS ( description 'validates string is a specific format'
--                    options 'oracle us eu iso year my' options 'oracle us eu iso year my' );
        