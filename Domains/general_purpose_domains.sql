-- common purpose domains
create domain id_d as int
  not null
	check ( value > 0 )
;

create domain safe_id_d as int not null
	check ( value > 0 )
	display '----';

create domain object_name_d as varchar2(128 byte) strict
--  not null -- BUG 23.3
	check ( value = trim(value) and
		(value = lower(value) or value like '"%"')
    and value is not null -- fix for 23.3 bug
        );
        
create domain short_desc_d as varchar2(500 char);
create domain long_desc_d as varchar2(32767 byte);