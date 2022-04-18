-- install script

-- Constants and Errors
@@./Packages/MKLibrary_constants.pks


-- install UDT Specs
@@./UDTs/CLOB_array.pks
@@./UDTs/INT_array.pks
@@./UDTs/Hash.pks
@@./UDTs/Iterator.pks
@@./UDTs/Output.pks
@@./UDTs/Error.pks

-- install Package Specs
@@./Packages/Error_utils.pks
@@./Packages/CLOB_utils.pks

-- install UDT Bodies
@@./UDTs/Output.pkb
@@./UDTs/Hash.pkb
@@./UDTs/Iterator.pkb
@@./UDTs/Output.pkb
@@./UDTs/Error.pkb

-- install Package Bodies
@@./UDTs/Error_utils.pkb
@@./UDTs/CLOB_utils.pkb

-- apply grants for UDT
-- @@./UDTs/grants.sql
-- @@./Packages/grants.sql

-- create synonyms
-- @@./UDTs/synonyms.sql
-- @@./UDTs.synonyms.sql


-- OPTIONAL
-- install UT Specs
-- install UT Bodies

-- run UTs