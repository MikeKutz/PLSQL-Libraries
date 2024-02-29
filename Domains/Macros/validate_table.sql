create or REPLACE
function validate_table (source_table     dbms_tf.table_t
                        ,column_names     dbms_tf.columns_t
                        ,string_validate  dbms_tf.columns_t
                        ,do_debug         int default 0
                        ) return CLOB
    sql_macro(table)
as
    /**
        This `sql_macro` applies the specified `domain` to the corrisponding column and returns only unique results of the form:
        - column_name
        - column_value
        - domain_name
        - error_text - why it failed

        `error_text` values | reason
        --------------------|------
        string is not null | value is null and domain has a `not null` requirement
        string is too long | domain has a `strict` requirement and the value is longer than the specified string length
        check failed | string failed any `check` constraint of the domain
        null | string passes all constraints defined by the domain
        unknown | something went wrong. please file an issue in GitHub

        `column_name` & `string_validate` arrarys must be of the same size.

        the same column can be mentioned multiple times but should be tested agains a different `domain` for each reference.

        ## sample domain
        `create domain test_domain as varchar2(10) strict not null check ( .. );`

        ## example
        ```sql
        select *
        from validate_table( some_ext_tab
                            ,columns( c001, c002, c003, c003)
                            ,columns( string_ntu, ds_interval_units, date_us, string_nt)
                            );
        ```

        - domain 'string_ntu' tests column `c001`
        - domain 'ds_interval_units' tests column `c002`
        - domain 'date_us' tests column `c003`
        - domain 'string_nt' tests column `c003`

        #TODO
        Right now, `dbms_tf` does not support `domain` objects. The workaround is to use `dbms_tf.columns_t`

        As such, the domain needs to be accessible without a schema reference.
        
        This limitation is expected to be fixed in a future version of the RDBMS.



        @param source_table validate values in this table
        @param column_names list of columns to be validate. can be duplicated
        @param string_validate name of a scalar varchar2 Domain to apply against corrisponding column_name. must be 1:1
        @param do_debug non-zero value puts code in Debug mod
    */
    type domains_nt is table of ALL_DOMAIN_COLS.domain_name%type;

    selected_columns clob;
    unpivot_columns  clob;
    domain_test      clob;
    final_sql        clob;
    col_n            int;
    str_n            int;

    not_null_domains domains_nt;
    not_vc2_columns  domains_nt;
    

    single_test CONSTANT clob := q'[select '#domain#' as domain_name
                                    ,case
                                        when domain_check_type( #domain#, column_value ) is false then 'value is too long'
                                        when domain_check( #domain#, column_value ) is false then 'value fails CHECK'
                                        when domain_check( #domain#, column_value ) is true then null
                                        else 'unkown error'
                                    end validation_error_text
                                    from dual where column_name=ltrim(rtrim( '#column#' ,'"'), '"')]';

    not_null_test CONSTANT clob := q'[select '#domain#' as domain_name
                                    ,case
                                        when column_value is null then 'value is null'
                                        when domain_check_type( #domain#, column_value ) is false then 'value is too long'
                                        when domain_check( #domain#, column_value ) is false then 'value fails CHECK'
                                        when domain_check( #domain#, column_value ) is true then null
                                        else 'unkown error'
                                    end validation_error
                                    from dual where column_name=ltrim(rtrim( '#column#' ,'"'), '"')]';

    procedure log_debug( txt in clob )
    as
    BEGIN
        if nvl(do_debug,0) != 0
        THEN
            dbms_output.put_line( txt );
        end if;
    end;    
BEGIN
    <<input_validation>>
    begin
        if column_names is NULL
        THEN    col_n := -1;
        else    col_n := column_names.count;
        end if;

        if string_validate is null
        then str_n := -2;
        else str_n := string_validate.count;
        end if;

        if str_n != col_n then raise_application_error( -20101, 'columns:domains must be 1:1'); end if;
    end;

    <<column_validations>>
    begin null; end;

    <<domain_validations>>
    begin null; end;

    <<parse_input>>
    begin
        -- cache "which domains are NOT NULL"
        -- TODO: rework for cross-schema domains
        select '"' || domain_name || '"'
            bulk collect into not_null_domains
        from ALL_DOMAIN_COLS
        where nullable='N' and column_id=1
            and (owner,domain_name) in (select user, ltrim(rtrim(value(a),'"'),'"') from table(string_validate) a );

        -- cache "which source table columns are not Varchar2"
        not_vc2_columns  := new domains_nt();

        for rec in values of source_table.column
        loop
            if rec.description.type not in (1)
            then
                not_vc2_columns.extend(1);
                not_vc2_columns( not_vc2_columns.last ) := rec.description.name;

                log_debug( 'NOT VC2 "' || rec.description.name || '"');
            end if;
        end loop;
    end;

    <<build_sql>>
    begin
        -- build strings for replacements
        for i in 1 .. column_names.count
        LOOP
            -- columns SELECTED need to be of type Varchar2()
            if column_names(i) member of not_vc2_columns
            then
                selected_columns := selected_columns
                                || case when i > 1 then  ', ' END
                                || 'cast( ' || column_names(i) || ' as varchar2(32767) ) as ' || column_names(i);
            else
                selected_columns := selected_columns
                                || case when i > 1 then  ', ' END
                                || column_names(i);
            end if;

            -- columns to be Unpivot
            unpivot_columns := unpivot_columns
                            || case when i > 1 then  ', ' END
                            || column_names(i);

            -- test for Reason Why Invalid
            if string_validate(i) member of not_null_domains
            THEN
                domain_test := domain_test
                            || '    '
                            || case when i > 1 then chr(10) || '    union all ' end
                            || replace(replace(not_null_test,'#domain#',string_validate(i)), '#column#', column_names(i));
            else
                domain_test := domain_test
                            || '    '
                            || case when i > 1 then chr(10) || '    union all ' end
                            || replace(replace(single_test,'#domain#',string_validate(i)), '#column#', column_names(i));
            end if;
        end loop;

        log_debug( 'tab  = [' || source_table.ptf_name || ']' );
        log_debug( 'cols = [' || unpivot_columns || ']');
        log_debug( 'doms = [' || domain_test || ']');


         final_sql :=  q'[select *
from (
    select distinct column_name, column_value
    from (
        select rownum rn, ]' || selected_columns || q'[
        from source_table
        where rownum < 10
    )  unpivot (COLUMN_VALUE
        for column_name in (
]' || unpivot_columns || q'[            
        )
    )
) a
cross  apply (
]' ||
domain_test || q'[
)
]';
    end;

    -- return Select clause based on value of  DO_DEBUG
    <<final_destination>>
    if do_debug = 0 then
        return final_sql;
    else
        log_debug( 'sql =' || chr(10) || final_sql);

        return 'select ' || col_n || ' array_count';
    end if;

end;
/
