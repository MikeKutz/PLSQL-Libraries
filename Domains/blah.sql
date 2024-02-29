select * from nc_voting.voter_history;

set SERVEROUTPUT on;
select *
from validate_table( nc_voting.voter_history
    ,columns( county_desc, election_lbl )
    ,columns( string_ntu, date_us ) );



select *
from (
    select distinct column_name, column_value
    from (
        select rownum rn, county_desc, election_lbl
        from nc_voting.voter_history  -- source table_name
        where rownum < 10
    )  unpivot (COLUMN_VALUE
        for column_name in (
            COUNTY_DESC, ELECTION_LBL -- listagg columns
        )
    )
) a
cross  apply (
        select 'NTU' as domain_name, domain_check_type( string_ntu, column_value) chk_typ, domain_check( string_ntu, column_value) chk from dual where column_name='COUNTY_DESC'
        union all
        select 'date_us' as domain_name, domain_check_type( date_us, column_value) chk_typ, domain_check( date_us, column_value) chk from dual where column_name='ELECTION_LBL'
)
-- where chk_typ is false or chk is false
;

select * from all_tab_cols;

DECLARE
    in_clob clob;
    out_clob clob;
begin

in_clob := q'[select *
from validate_table( nc_voting.voter_history
    ,columns( county_desc, election_lbl, voting_method, county_id )
    ,columns( string_ntu,  date_us,      string_t,     positive_number_d )
    ,0 -- debug or real(0) query
    )
]';

DBMS_UTILITY.EXPAND_SQL_TEXT (
   in_CLOB,
   out_CLOB);

DBMS_OUTPUT.PUT_LINE(out_clob);
end;
/

select * from USER_TYPE_METHODS
where type_name=method_name;

select * from USER_TYPE_ATTRS;
select * from USER_PROCEDURES
where OBJECT_NAME=PROCEDURE_NAME;
select * from user_ARGUMENTS
where object_name='HASH_T';