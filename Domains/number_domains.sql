create domain if not exists number_us as varchar2(100)
    check ( regexp_like( number_us, '^[[:digit:]]+(.[[:digit:]]+)?$') )
    ANNOTATIONS ( description 'validates string is in a US number format without thosand seperator')
    ;
create domain if not exists number_us_k as varchar2(100)
    check ( regexp_like( number_us_k, '^([[:digit:]]{1,3},)*[[:digit:]]{1,3}(.[[:digit:]]+)?$') )
    ANNOTATIONS ( description 'validates string is in a US number format with thosand seperator');

create domain if not exists number_us_k as varchar2(100)
    check ( regexp_like( number_us_k, '^[[:digit:]]+(,[[:digit:]]+)?$') )
    ANNOTATIONS ( description 'validates string is in an EU number format without thosand seperator');

create domain if not exists number_eu_k as varchar2(100)
    check ( regexp_like( number_eu_k, '^([[:digit:]]{1,3}.)*[[:digit:]]{1,3}(,[[:digit:]]+)?$') )
    ANNOTATIONS ( description 'validates string is in an EU number format with thosand seperator');

create flexible domain number_validate ( val )
    choose domain using ( p_type varchar2(10) ) from
    case lower(p_type)
        when 'us' then number_us( val )
        when 'us_k' then number_us_k( val ) 
        when 'eu' then number_eu( val )
        when 'eu_k' then number_eu_k( val )
    end
    ANNOTATIONS ( description 'validates string is in the specified option format',
                  options 'us us_k eu eu_k' );

