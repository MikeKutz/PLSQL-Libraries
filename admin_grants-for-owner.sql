create user MKLibrary
    identified by Change0nInstall
-- no authentication
default tablespace DATA
temporary tablespace TEMP
quota 10M on DATA;

grant create procedure
    ,create synonym
    ,create public synonym
    ,create type
    ,create table      -- for testing
    ,create sequence   -- for testing
    ,create indextype  -- for indexing Tags
    ,create session
to MKLibrary;