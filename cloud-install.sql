whenever sqlerror exit failure;

-- install script
prompt Creating User MKLibrary and applying grant
@@./admin_grants-for-owner.sql

alter session set current_schema=MKLibrary;

-- Constants and Errors
prompt defining Constants
@@./Packages/MKLibrary_constants.pks

-- install UDT Specs
prompt installing Type Specifications
@@./UDTs/CLOB_array.pks
@@./UDTs/INT_array.pks
@@./UDTs/Hash.pks
@@./UDTs/Iterator.pks
@@./UDTs/Output.pks
@@./UDTs/Error.pks

-- install Package Specs
prompt installing Package Specifications
@@./Packages/Error_utils.pks
@@./Packages/CLOB_utils.pks
@@./Packages/JSON_Path_utils.pks
@@./Packages/generate_series.pks

-- install UDT Bodies
prompt installing Type Bodies
@@./UDTs/Hash.pkb
@@./UDTs/Iterator.pkb
@@./UDTs/Output.pkb
@@./UDTs/Error.pkb

-- install Package Bodies
prompt installing Package Bodies
@@./Packages/Error_utils.pkb
@@./Packages/CLOB_utils.pkb
@@./Packages/JSON_Path_utils.pkb
@@./Packages/generate_series.pkb

-- apply grants
prompt Applying grants
@@./UDTs/grants.sql
@@./Packages/grants.sql

-- create public synonyms
prompt Installing Synonyms
@@./UDTs/synonyms.sql
@@./UDTs.synonyms.sql

-- install UT Specs
prompt Installing UT Packages
@@./Tests/ut_hash_t.pks
@@./Tests/ut_hash_t.pkb
@@./Tests/ut_logging.pks
@@./Tests/ut_logging.pkb
@@./Tests/ut_path_manipulation.pks
@@./Tests/ut_path_manipulation.pkb

-- run UTs