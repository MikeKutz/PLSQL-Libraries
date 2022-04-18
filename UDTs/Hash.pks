create or replace
type "Hash" as object (
    json_clob      clob,
    constructor function "Hash" return self as result,
    
    member procedure reset_properties,
    member procedure merge_other( self in out nocopy "Hash", new_hash in out nocopy "Hash", name_prefix in varchar2 default null ),

    member function key_exists( key_str in varchar2 ) return boolean,

    member procedure put_value( key_str in varchar2, val_str in varchar2 ),
    member procedure put_value( key_str in varchar2, val_str in boolean ),
    member procedure put_value( key_str in varchar2, val_str in number ),
    member procedure put_value( key_str in varchar2, val_str in date ),
    member procedure put_value( key_str in varchar2, val_hash in out nocopy "Hash" ),
    
    member function  get_string( key_str in varchar2 ) return varchar2,
    member function  get_boolean( key_str in varchar2 ) return boolean,
    member function  get_number( key_str in varchar2 ) return number,
    member function  get_date( key_str in varchar2 ) return date,
    member function  get_hash( key_str in varchar2 ) return "Hash"
);
/
