create or replace
package ut_logging
    authid current_user
as
    /*  Test the logging facilities of "log" */
    --%suite(Logging Facilities test suite)
    --%suitepath( MKLibrary.Log_utiels )


    --%test(Simple Log)
    procedure test_simple;
    
    --%test(Appending Log)
    procedure test_append;
    
    --%test(Multiline Error)
    procedure test_multiline;
end ut_logging;
/
