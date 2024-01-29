-- oracle format
create domain if not exists date_oracle as varchar2(100)
    check ( to_date(date_oracle default null on conversion error, 'DD-MON-YYYY') is not null);

-- US format
create domain if not exists date_us as varchar2(100)
    check ( to_date(date_us default null on conversion error, 'MM/DD/YYYY') is not null);

-- EU format
create domain if not exists date_eu as varchar2(100)
    check ( to_date(date_eu default null on conversion error, 'DD/MM/YYYY') is not null);

-- ISO format
create domain if not exists date_iso as varchar2(100)
    check ( to_date(date_iso default null on conversion error, 'YYYY-MM-DD') is not null);

-- MONTH/YEAR formats
create domain if not exists date_my as varchar2(100)
    check ( to_date(date_my default null on conversion error, 'MM/YYYY') is not null);
create domain if not exists date_y as varchar2(100)
    check ( regexp_like( date_y, '^[[:digit:]]{4}$'));






