-- DS Interval
create domain if not exists dsinterval_colon as varchar2(100)
    check (regexp_like( dsinterval_colon, '^[+\-]?([[:digit:]]{1,4} )?([[:digit:]]+:)?([[:digit:]]+:)?[[:digit:]]+(.[[:digit:]]+)?$'))
    ANNOTATIONS ( description 'validates string is in the default day-second interval format');
    ;

create domain if not exists dsinterval_units as varchar2(100)
    check (regexp_like( dsinterval_units, '^([[:digit:]]+ ?(d|dy|days?) ?)?' ||
                                          '([[:digit:]]+ ?(h|hh|hr|hours?) ?)?' ||
                                          '([[:digit:]]+ ?(m|min?|minutes?) ?)?' ||
                                          '([[:digit:]]+(\.[[:digit:]]+) ?(s|sec|seconds?) ?)?$'
                        )
        )
    ANNOTATIONS ( description 'validates string is day-second interval format using units');

-- YM Interval
create domain if not exists yminterval_colon as varchar2(100)
    check( regexp_like(yminterval_colon, '^([[:digit:]]+(-| ))?[[:digit:]]+$'))
    ANNOTATIONS ( description 'validates string is in the default year-mont interval format');

create domain if not exists yminterval_units as varchar2(100)
    check ( regexp_like( yminterval_units, '^([[:digit:]]+ ?(y|yr|years?) ?)?([[:digit:]]+ ?(m|mon|months?) ?)?'))
    ANNOTATIONS ( description 'validates string is year-month interval format using units');

-- flexible domains
create flexible domain dsinterval_validate ( val )
    choose domain using ( p_type varchar2(10) ) from
    case lower(p_type)
        when 'ds_colon' then dsinterval_colon(val)
        when 'ds_units' then dsinterval_units(val)
    end
    ANNOTATIONS ( description 'validates string is in the specified option format',
                  options 'ds_colon ds_units' );


create flexible domain yminterval_validate ( val )
    choose domain using ( p_type varchar2(10) ) from
    case lower(p_type)
        when 'ym_colon' then yminterval_colon(val)
        when 'ym_units' then yminterval_units(val)
    end;
    ANNOTATIONS ( description 'validates string is in the specified option format',
                  options 'ym_colon ym_units' );
