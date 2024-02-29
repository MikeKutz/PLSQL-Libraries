create or REPLACE
function short_validate (source_table     dbms_tf.table_t
                        ,column_names     dbms_tf.columns_t
                        ,string_validate  dbms_tf.columns_t
                        ,do_debug         int default 0
                        ) return CLOB
    sql_macro(table)
as
    final_sql        clob;
BEGIN


         final_sql :=  q'[select *
from (
    select distinct column_name, column_value
    from (
        select rownum rn, #column#
        from source_table
        where rownum < 10
    )  unpivot (COLUMN_VALUE
        for column_name in (
          #column#      
        )
    )
) a
cross  apply (
    select '#domain#' as domain_name
        ,case
            when domain_check_type( #domain#, column_value ) is false then 'value is too long'
            when domain_check( #domain#, column_value ) is false then 'value fails CHECK'
            when domain_check( #domain#, column_value ) is true then null
            else 'unkown error'
        end error_text
    from dual where column_name=ltrim(rtrim( '#column#' ,'"'), '"')
)
]';

    final_sql := replace(replace(final_sql, '#domain#', string_validate(1)), '#column#', column_names(1));

    -- return Select clause based on value of  DO_DEBUG
    <<final_destination>>
    if do_debug = 0 then
        return final_sql;
    else
        dbms_output.put_line( 'sql =' || chr(10) || final_sql);

        return 'select 1 array_count';
    end if;

end;
/
