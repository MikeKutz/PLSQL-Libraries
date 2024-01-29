create domain if not exists string_ntl as varchar2(32767)
    not null
    check ( string_ntl = trim(lower( string_ntl)));
create domain if not exists string_ntu as varchar2(32767)
    not null
    check ( string_ntu = trim(upper( string_ntu)));

create domain if not exists string_nl as varchar2(32767)
    not null
    check ( string_nl = lower( string_nl));
create domain if not exists string_nu as varchar2(32767)
    not null
    check ( string_nu = upper( string_nu));
create domain if not exists string_nt as varchar2(32767)
    not null
    check ( string_nt = trim( string_nt));

create domain if not exists string_tu as varchar2(32767)
    check ( string_tu = upper( string_tu));
create domain if not exists string_tl as varchar2(32767)
    check ( string_tl = trim(lower( string_tl)));

create domain if not exists string_u as varchar2(32767)
    check ( string_u = upper( string_u));
create domain if not exists string_l as varchar2(32767)
    check ( string_l = lower( string_l));
create domain if not exists string_t as varchar2(32767)
    check ( string_t = trim( string_t));
create domain if not exists string_n as varchar2(32767)
    not null;

create flexible domain string_validate ( val )
    choose domain using ( is_nullable boolean
                            ,is_trimmed boolean
                            ,upper_lower varchar2(6)) from
    case
        when is_nullable is true
            and is_trimmed is true
            and lower(upper_lower) in ('upper', 'u')
          then string_ntu(val)
        when is_nullable is true
            and is_trimmed is true
            and lower(upper_lower) in ('lower', 'l')
          then string_ntl(val)
        when is_nullable is true
            and is_trimmed is true
            and upper_lower is null
          then string_nt(val)
        when is_nullable is true
            and is_trimmed is false
            and lower(upper_lower) in ('upper', 'u')
          then string_nu(val)
        when is_nullable is true
            and is_trimmed is false
            and lower(upper_lower) in ('lower', 'l')
          then string_nl(val)
        when is_nullable is true
            and is_trimmed is false
            and upper_lower is null
          then string_n(val)

        when is_nullable is false
            and is_trimmed is true
            and lower(upper_lower) in ('upper', 'u')
          then string_tu(val)
        when is_nullable is false
            and is_trimmed is true
            and lower(upper_lower) in ('lower', 'l')
          then string_tl(val)
        when is_nullable is false
            and is_trimmed is true
            and upper_lower is null
          then string_t(val)
        when is_nullable is false
            and is_trimmed is false
            and lower(upper_lower) in ('upper', 'u')
          then string_u(val)
        when is_nullable is false
            and is_trimmed is false
            and lower(upper_lower) in ('lower', 'l')
          then string_l(val)
    end;
        
