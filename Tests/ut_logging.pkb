create or replace
package body ut_logging
as
    /* used to "normalize" the output */
    function lorem_epsum( txt in clob ) return clob
    as  
    begin
        return regexp_replace( txt, '[[:alnum:]]', 'X' );
    end lorem_epsum;
    
    procedure test_simple
    as
        stderr clob;
        expected clob := '[XXXXX     XX-XXX-XX XX.XX.XX.XXXXXXXXX XX XXXXXXX/XXX_XXXX ]:XXXX XX XX XXXXX';
    begin
        MKLibrary.Log_utils."error"( stderr , 'This is an error' );
        stderr := lorem_epsum( stderr );
        
        ut.expect(stderr).to_equal(expected);

    end test_simple;
    
    procedure test_append
    as
        stderr clob;
        expected clob := '[XXXXX     XX-XXX-XX XX.XX.XX.XXXXXXXXX XX XXXXXXX/XXX_XXXX ]:XXXX XX XX XXXXX
[XXXXX     XX-XXX-XX XX.XX.XX.XXXXXXXXX XX XXXXXXX/XXX_XXXX ]:XXXX XX XX XXXXX';
    begin
        MKLibrary.Log_utils."error"( stderr , 'This is an error' );
        MKLibrary.Log_utils."error"( stderr , 'This is an error' );
        stderr := lorem_epsum( stderr );
        
        ut.expect(stderr).to_equal(expected);

    end test_append;

    procedure test_multiline
    as
        stderr clob;
        expected clob := '[XXXXX     XX-XXX-XX XX.XX.XX.XXXXXXXXX XX XXXXXXX/XXX_XXXX ]:
--------------------------------------------------------------------------------
    XXXX XX XX XXXXX
    XXXXXXXX XXXXXXXX XXXXX';
    begin
        MKLibrary.Log_utils."error"( stderr , 'This is an error
spanning multiple lines' );
        stderr := lorem_epsum( stderr );
        
        ut.expect(stderr).to_equal(expected);

    end test_multiline;
end ut_logging;
/
