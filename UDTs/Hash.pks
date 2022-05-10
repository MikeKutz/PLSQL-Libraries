create or replace
type Hash_t as object (
    /**
    * Hash_t
    *
    * A clasic Hash data type implemented as a UDT
    * It uses JSON data type for storing the collection.
    *
    * Current limitations require it to be a CLOB.
    * This UDT handles all the conversion between CLOB and JSON data types.
    *
    * @headcom
    */
    json_clob      clob,
    constructor function Hash_t return self as result,
    
    member procedure reset_properties,
    member procedure merge_other( self in out nocopy Hash_t, new_hash in out nocopy Hash_t, name_prefix in varchar2 default null ),

    member function key_exists( key_str in varchar2 ) return boolean,

    member procedure put_value( key_str in varchar2, val_str in varchar2 ),
    member procedure put_value( key_str in varchar2, val_str in boolean ),
    member procedure put_value( key_str in varchar2, val_str in number ),
    member procedure put_value( key_str in varchar2, val_str in date ),
    member procedure put_value( key_str in varchar2, val_hash in out nocopy Hash_t ),
    
    member function  get_string( key_str in varchar2 ) return varchar2,
    member function  get_boolean( key_str in varchar2 ) return boolean,
    member function  get_number( key_str in varchar2 ) return number,
    member function  get_date( key_str in varchar2 ) return date,
    member function  get_hash( key_str in varchar2 ) return Hash_t
);
/
