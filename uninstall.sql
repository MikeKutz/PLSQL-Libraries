-- CLEAN UP SCRIPT

-- remove public synonym
drop public synonym "Output";
drop public synonym "Error";
drop public synonym "Iterator";
drop public synonym "Hash";
drop public synonym "CLOB Array";
drop public synonym "INT Array";

-- drop Packages
drop package "CLOB utils";
drop package "Error utils";

-- drop UDTs
drop type "Error";
drop type "Output";
drop type "Iterator";
drop type "Hash";
drop type "CLOB Array";
drop type "INT Array";

-- drop Constants and Exceptions
drop package "MKLibrary Constants";
