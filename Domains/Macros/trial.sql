create or REPLACE
function test_me( p_json dbms_tf.tab_json_t ) return CLOB
    sql_macro( table )
as
    n int;
BEGIN
    if p_json is not NULL
    THEN
        n := p_json.count;
    else
        n := -1;
    end if;

    return 'select ' || n || ' as jc';
end;
/

select * from NC_VOTING.VOTER_HISTORY where ROWNUM < 10;
