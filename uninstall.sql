-- CLEAN UP SCRIPT

-- remove public synonym
drop public synonym MKL_STDOUT_t;
drop public synonym MKL_STDERR_t;
drop public synonym MKL_Iterator_t;
drop public synonym MKL_Hash_t;
drop public synonym MKL_CLOB_Array;
drop public synonym MKL_INT_Array;

-- DROP user
drop user MKLibrary cascade;
