create or replace
package body ut_path_modification
as
    type test_t is record ( input_value varchar2(4000), expected_value varchar2(4000) );
    type test_nt is table of test_t;

    common_current_path varchar2(4000) := '$.eh.what.is.up.doc';
    
    --%test(LTrim path)
    procedure test_ltrim
    as
        result_value varchar2(4000);
        expected_value varchar2(4000) := 'what.is.up.doc';
    begin

        result_value := MKLibrary.JSON_Path_utils.ltrim_path( 'eh.what.is.up.doc' );

        ut.expect(result_value).to_equal(expected_value);
    end test_ltrim;
    
    --%test(LPop path)
    procedure test_lpop
    as
        result_value varchar2(4000);
        expected_value varchar2(4000) := 'abc';
    begin

        result_value := MKLibrary.JSON_Path_utils.lpop_path( 'abc.def' );

        ut.expect(result_value).to_equal( 'abc' );
    end test_lpop;
    
    --%test(RTrim path)
    procedure test_rtrim
    as
        result_value varchar2(4000);
        expected_value varchar2(4000) := '$.eh.what.is.up';
    begin

        result_value := MKLibrary.JSON_Path_utils.rtrim_path( common_current_path );

        ut.expect(result_value).to_equal(expected_value);
    end test_rtrim;
    
    --%test(RPop path)
    procedure test_rpop
    as
        result_value varchar2(4000);
        expected_value varchar2(4000) := 'doc';
    begin

        result_value := MKLibrary.JSON_Path_utils.rpop_path( common_current_path );

        ut.expect(result_value).to_equal(expected_value);
    end test_rpop;

    --%test(LTrim path - bad data)
    procedure test_ltrim_outliers
    as
        result_value varchar2(4000);
        expected_value varchar2(4000) := '';
        test_set    test_nt := new test_nt(
            test_t( null, null ),
            test_t( '$.', '$.' ),
            test_t(common_current_path, '$.what.is.up.doc' ),
            test_t( '@.', null ),
            test_t( 'this', null ),
            test_t( 'last', null ) -- ? $.
        );
    begin
        for curr in values of test_set
        loop
            result_value := MKLibrary.JSON_Path_utils.ltrim_path( curr.input_value );
    
            ut.expect(result_value).to_equal(curr.expected_value);
        end loop;
    end test_ltrim_outliers;
    
    --%test(LPop path - bad data)
    procedure test_lpop_outliers
    as
        result_value varchar2(4000);
        test_set    test_nt := new test_nt(
            test_t( null, null ),
            test_t( '$.abc.def', 'abc' ),
            test_t( '$.abc', 'abc' ),
            test_t( '$.', null ),
            test_t( '@.abc.def', 'this' ),
            test_t( '@.abc', 'this' ),
            test_t( '@.', 'this' ),
            test_t( 'this.abc.def', 'this' ),
            test_t( 'this.abc', 'this' ),
            test_t( 'this', 'this' ),
            test_t( 'last', 'last' )
        );
    begin
    
        for curr in values of test_set
        loop

            result_value := MKLibrary.JSON_Path_utils.lpop_path( curr.input_value );
    
            ut.expect(result_value).to_equal(curr.expected_value);
        end loop;
        
    end test_lpop_outliers;
    
    --%test(RTrim path - bad data)
    procedure test_rtrim_outliers
    as
        result_value varchar2(4000);
        test_set    test_nt := new test_nt(
            test_t( null, null ),
            test_t( '$.', '$.' ),
            test_t( '@.', null ),
            test_t( 'this', null ),
            test_t( 'last', null ) -- ? $.
        );
    begin
    
        for curr in values of test_set
        loop

            result_value := MKLibrary.JSON_Path_utils.rtrim_path( curr.input_value );
    
            ut.expect(result_value).to_equal(curr.expected_value);
        end loop;
        
    end test_rtrim_outliers;
    
    --%test(RPop path  bad data)
    procedure test_rpop_outliers
    as
        result_value varchar2(4000);
        test_set    test_nt := new test_nt(
            test_t( null, null ),
            test_t( '$.', null ),
            test_t( '@.', 'this' ),
            test_t( 'last', 'last' ) -- ? $.
        );
    begin
        for curr in values of test_set
        loop
            result_value := MKLibrary.JSON_Path_utils.rpop_path( curr.input_value );
    
            ut.expect(result_value).to_equal(curr.expected_value);
        end loop;

    end test_rpop_outliers;
    
    --%test(Translate Path)
    procedure test_translate_path
    as
        new_path      varchar2(4000) := 'this.new.node';
        result_value varchar2(4000);
        expected_value varchar2(4000) := '$.eh.what.is.up.doc.new.node';
    begin

        result_value := MKLibrary.JSON_Path_utils.translate_path( new_path, common_current_path );

        ut.expect(result_value).to_equal(expected_value);
    end test_translate_path;
    
    --%test(Translate Path with bad new_path data)
    procedure test_translate_np_outliers
    as
        expected_value varchar2(4000) := '';
        result_value varchar2(4000);
        test_set    test_nt := new test_nt(
            test_t( null, common_current_path ),
            test_t( '$.', '$.' ),
            test_t( '@.', common_current_path ),
            test_t( '@.name', common_current_path || '.name' ),
            test_t( 'die.hard', '$.die.hard' ),
            test_t( 'last', '$.last' ),
            test_t( '$.big.bad.wolf', '$.big.bad.wolf' )
        );
    begin
        for curr in values of test_set
        loop
            result_value := MKLibrary.JSON_Path_utils.translate_path( curr.input_value, common_current_path );
    
            ut.expect(result_value).to_equal(curr.expected_value);
        end loop;
    end test_translate_np_outliers;
    
    --%test(Translate Path with bad current_path data)
    procedure test_translate_current_outliers
    as
        common_this_path varchar(4000) := 'this.new.node';
        result_value varchar2(4000);
        test_set    test_nt := new test_nt(
            test_t( null, '$.new.node' ),
            test_t( 'blah', '$.blah.new.node' ),
            test_t( 'die.hard', '$.die.hard.new.node' )
            -- test_t( '@.ghosbusters', '---' ) should RAISE ERROR
        );
    begin
        for curr in values of test_set
        loop
            result_value := MKLibrary.JSON_Path_utils.translate_path(  common_this_path, curr.input_value );
    
            ut.expect(result_value).to_equal(curr.expected_value);
        end loop;
    end test_translate_current_outliers;
    
    --%test(Translate Path with bad current_path and new_path data)
    procedure test_translate_mixed_outliers
    as
        new_path      varchar2(4000);
        result_value varchar2(4000);
        expected_value varchar2(4000) := '';
    begin

        result_value := MKLibrary.JSON_Path_utils.translate_path( new_path, common_current_path );

        ut.expect(result_value).to_equal(expected_value);
    end test_translate_mixed_outliers;
end ut_path_modification;
/
