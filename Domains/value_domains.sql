-- number values
create domain if not exists is_integer as number
    check ( is_integer = trunc(is_integer))
    ANNOTATIONS ( description 'validates number is an integer');

create domain if not exists is_positive as number
    check ( is_positive = trunc(is_positive) and is_positive > 0)
    ANNOTATIONS ( description 'validates number is an non-zero positive integer');

create domain if not exists is_0_ix as number
    check ( is_0_ix = trunc(is_0_ix) and is_0_ix >= 0)
    ANNOTATIONS ( description 'validates number is a positive integer');

-- date values
create domain if not exists is_day as date
    check ( is_day = trunc(is_day,'dd'))
    ANNOTATIONS ( description 'validates date represents a day');

create domain if not exists is_week as date
    check ( is_day = trunc(is_day,'day'))
    ANNOTATIONS ( description 'validates date represents a week');

create domain if not exists is_month as date
    check ( is_month = trunc(is_month,'month'))
    ANNOTATIONS ( description 'validates date represents a month');

create domain if not exists is_year as date
    check ( is_year = trunc(is_year,'year'))
    ANNOTATIONS ( description 'validates date represents a year');

-- pair values
-- both null or both not null
create domain if not exists xand_null as ( a as varchar2(32767)
                                        ,b as varchar2(32767))
    check ( (a is null and b is null) or (a is not null and b is not null))
    ANNOTATIONS ( description 'validates both values are null or both values are not null');

-- both not null
create domain if not exists xand_null as ( a as varchar2(32767) not null
                                        ,b as varchar2(32767) not null)
    ANNOTATIONS ( description 'validates both values both values are not null');

-- 1 and only 1 is not null
create domain if not exists xor_null as ( a as varchar2(32767)
                                        ,b as varchar2(32767))
    check ( (a is null and b is not null) or (a is not null and b is null))
    ANNOTATIONS ( description 'validates that exactly one value exists');
