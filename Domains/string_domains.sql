create domain if not exists string_ntl as varchar2(32767)
    not null
    check ( string_ntl = trim(lower( string_ntl)))
    ANNOTATIONS ( description 'validates string is not null trimmed lowercase' );

create domain if not exists string_ntu as varchar2(32767)
    not null
    check ( string_ntu = trim(upper( string_ntu)))
    ANNOTATIONS ( description 'validates string is not null trimmed uppercase' );

create domain if not exists string_nl as varchar2(32767)
    not null
    check ( string_nl = lower( string_nl))
    ANNOTATIONS ( description 'validates string is not null lowercase' );

create domain if not exists string_nu as varchar2(32767)
    not null
    check ( string_nu = upper( string_nu))
    ANNOTATIONS ( description 'validates string is not null uppercase' );

create domain if not exists string_nt as varchar2(32767)
    not null
    check ( string_nt = trim( string_nt))
    ANNOTATIONS ( description 'validates string is not null trimmed' );


create domain if not exists string_tu as varchar2(32767)
    check ( string_tu = upper( string_tu))
    ANNOTATIONS ( description 'validates string is trimmed uppercase' );

create domain if not exists string_tl as varchar2(32767)
    check ( string_tl = trim(lower( string_tl)));
    ANNOTATIONS ( description 'validates string is trimmed lowercase' );

create domain if not exists string_u as varchar2(32767)
    check ( string_u = upper( string_u));
    ANNOTATIONS ( description 'validates string is uppercase' );

create domain if not exists string_l as varchar2(32767)
    check ( string_l = lower( string_l));
    ANNOTATIONS ( description 'validates string is lowercase' );

create domain if not exists string_t as varchar2(32767)
    check ( string_t = trim( string_t))
    ANNOTATIONS ( description 'validates string is trimmed' );

create domain if not exists string_n as varchar2(32767)
    not null
    ANNOTATIONS ( description 'validates string is not null' );

create flexible domain string_validate ( val )
    choose domain using ( is_not_null boolean
                            ,is_trimmed boolean
                            ,upper_lower varchar2(6)) from
    case
        when is_not_null is true
            and is_trimmed is true
            and lower(upper_lower) in ('upper', 'u')
          then string_ntu(val)
        when is_not_null is true
            and is_trimmed is true
            and lower(upper_lower) in ('lower', 'l')
          then string_ntl(val)
        when is_not_null is true
            and is_trimmed is true
            and upper_lower is null
          then string_nt(val)
        when is_not_null is true
            and is_trimmed is false
            and lower(upper_lower) in ('upper', 'u')
          then string_nu(val)
        when is_not_null is true
            and is_trimmed is false
            and lower(upper_lower) in ('lower', 'l')
          then string_nl(val)
        when is_not_null is true
            and is_trimmed is false
            and upper_lower is null
          then string_n(val)

        when is_not_null is false
            and is_trimmed is true
            and lower(upper_lower) in ('upper', 'u')
          then string_tu(val)
        when is_not_null is false
            and is_trimmed is true
            and lower(upper_lower) in ('lower', 'l')
          then string_tl(val)
        when is_not_null is false
            and is_trimmed is true
            and upper_lower is null
          then string_t(val)
        when is_not_null is false
            and is_trimmed is false
            and lower(upper_lower) in ('upper', 'u')
          then string_u(val)
        when is_not_null is false
            and is_trimmed is false
            and lower(upper_lower) in ('lower', 'l')
          then string_l(val)
    end
    ANNOTATIONS ( description 'validates string fits the required format requirement',
                  parameter_1_description 'is the string NOT NULL?',
                  parameter_2_description 'is the string trimmed?',
                  parameter_3_desicription 'is the string uppercase or lowercase',
                  parameter_3_options 'upper=uppercase lower=lowercase null=not tested' );
        
