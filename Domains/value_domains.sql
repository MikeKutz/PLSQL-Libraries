-- number values
create domain if not exists is_integer as number
    check ( is_integer = trunc(is_integer));
create domain if not exists is_positive as number
    check ( is_positive = trunc(is_positive) and is_positive > 0);
create domain if not exists is_0_ix as number
    check ( is_0_ix = trunc(is_0_ix) and is_0_ix >= 0);

-- date values
create domain if not exists is_day as date
    check ( is_day = trunc(is_day,'day'));
create domain if not exists is_month as date
    check ( is_month = trunc(is_month,'month'));
create domain if not exists is_year as date
    check ( is_year = trunc(is_year,'year'));

-- pair values
-- both null or both not null
create domain if not exists xand_null as ( a as varchar2(32767)
                                        ,b as varchar2(32767))
    check ( (a is null and b is null) or (a is not null and b is not null));
-- both not null
create domain if not exists xand_null as ( a as varchar2(32767) not null
                                        ,b as varchar2(32767) not null);
-- 1 and only 1 is not null
create domain if not exists xor_null as ( a as varchar2(32767)
                                        ,b as varchar2(32767))
    check ( (a is null and b is not null) or (a is not null and b is null));
