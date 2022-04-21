create or replace
package ut_path_modification
    authid current_user
as
    /* Validates JSON Path manipulation */
    
    --%suite(MKLibrary Path Manipulation)
    --%suitepath( MKLibrary.JSON_Path_utils )
    
    --%test(LTrim path)
    procedure test_ltrim;
    
    --%test(LPop path)
    procedure test_lpop;
    
    --%test(RTrim path)
    procedure test_rtrim;
    
    --%test(RPop path)
    procedure test_rpop;

    --%test(LTrim path - bad data)
    procedure test_ltrim_outliers;
    
    --%test(LPop path - bad data)
    procedure test_lpop_outliers;
    
    --%test(RTrim path - bad data)
    procedure test_rtrim_outliers;
    
    --%test(RPop path  bad data)
    procedure test_rpop_outliers;
    
    --%test(Translate Path)
    procedure test_translate_path;
    
    --%test(Translate Path with bad new_path data)
    procedure test_translate_np_outliers;
    
    --%test(Translate Path with bad current_path data)
    procedure test_translate_current_outliers;
    
    --%test(Translate Path with bad current_path and new_path data)
    --%disabled(TBD)
    procedure test_translate_mixed_outliers;
end ut_path_modification;
/
