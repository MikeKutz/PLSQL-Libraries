create or REPLACE
package macro_utils
as
    type validation_domains_rcd is record ( column_name dbms_tf.column_t
                                            ,string_validations  dbms_tf.columns_t
                                            ,value_validations   dbms_tf.columns_t);
    type validation_domains_aa is table of validation_domains_rcd;
end;
/
