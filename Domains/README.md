# 23c Domains

These are a collection of Domains for everyday data validation.

# List of Domains

## Available Conversion Domains

These take in a `varchar2` as a value and insure that the string can be converted using the expected format.  All of them can be called by a single Domain or by a Flexible Domain that embeds the `case` statement.

Domain Name | Purpose
------------|---------
`date_<>` | validate dates by expected format
`number_<>` | validate numbers by expexted format
`dsinterval_<>` | validate Day-Second Intervals by expected format
`myInterval_<>` | validate Year-Month Interval by expected format
`str_<>` |  Ensures string is of apropriate type

## Available Value Domains

These take in a specific data type and validate that the value has the desired properties.

Domain Name | Data Type | Purpose
------------|-----------|--------
`is_integer`  | Number | Ensures the Number is an Integer
`is_positive` | Number | Ensures the Number is an Integer whose value is `> 0`
`is_0_ix` | Number | Ensures the Numbe is an Integer whose value is `>= 0`
`is_day` | Date | Ensure the Sate is a truncated day
`is_month` | Date | Ensures the Date is a truncated month
`is_year` | Date | Ensures the Date is a truncated year
`xand_null` | Varchar2 | Ensure both strings are `null` or both are `not null`
`xand_not_null` | Varchar2 | Ensure both dimension id and dimension value exist
`xor_null` | Varchar2 | Ensure one and only one string exists

## Individual `date_<>`

`date_validate ( p_date, p_type )` is a Flexible Domain

Domain Name | p_type | Expected Format
------------|--------|--------------
`date_oracle` | `'oracle'` | DD-MON-YYYY
`date_us` | `'us'` | MM/DD/YYYY
`date_eu` | `'eu'` | DD/MM/YYYY
`date_iso` | `'iso'` | YYYY-MM-DD
`date_my` | `'my'` | MM/YYYY or MM-YYYY
`date_year` | `'year'` | YYYY
`date_oracle_r` | `'oracle_r'` | DD-MON-RRRR
`date_us_r` | `'us_r'` | MM/DD/RRRR
`date_eu_r` | `'eu_r'` | DD/MM/RRRR
`date_my_r` | `'my_r'` | MM/RRRR
`date_year_r` | `'year_r'` | YYYY

*note* `*_r` do not exist because RRRR is not deterministic

## Individual `number_<>`

`number_validate ( value, p_type)`

Domain Name | p_type | Expected Format
------------|--------|--------------
`number_us` | `us` | 999999990.99999999
`number_eu` | `eu` | 999999990,99999999
`number_us_k` | `'us_k'` | 999,999,990.999999
`number_eu_k` | `'eu_k'`  | 999.999.990,999999

**TODO** Indian format, versions using spaces, various scientific notations

## Individual `dsinterval_<>`

Domain Name | p_type | Expected Format
------------|--------|--------------
`dsinterval_colon` | `'ds_colon'` | DDDD HH:MM:SS.SSSSSS
`dsinterval_units` | `'ds_unit'` | DDDD day HH hour MM min SS.SSSSS seconds

- Spaces are optional
- Singular and Plural versions of the unit's name are acceptable
- not all units need to exist but they do need to be in the correct order
- `d`, `dy`, or `day` can be used for signifing the Day units. 
- `h`, `hr`, or `hour` can be used for signifing the Hour units. 
- `m`, `min`, or `minute` can be used for signifing the Minute units. 
- `s`, `sec`, or `second` can be used for signifing the Second units. 

## Individual `yminterval_<>`

`yminterval_validate ( value, p_type)` is the Flexible Domain

Domain Name | p_type | Expected Format
------------|--------|--------------
`yminterval_colon` | `'ym_colon'` | YYYY-MM ( `-` or ` ` can be used )
`yminterval_units` | `'ym_units'` | YYYY year MM months

- Spaces are optional
- Singular and Plural versions of the unit's name are acceptable
- not all units need to exist but they do need to be in the correct order
- `y`, `yr`, or `year` can be used for signifing the Day units. 
- `m`, `mo`, or `month` can be used for signifing the Day units. 


## Individual `str_<>`

`string_validate ( value, is_Nullable, is_trimmed, upper_lower)` is a Flexible Domain


Domain Name | Not Null | Trimmed | Upper | Lower
------------|----------|---------|-------|------
`string_n` | Yes | 
`string_t` |  | Yes 
`string_u` |  |  | Yes
`string_l` |  |  |  | Yes
`string_ntu` | Yes | Yes | Yes
`string_ntl` | Yes | Yes |   | Yes
`string_nt` | Yes | Yes
`string_nu` | Yes |   | Yes
`string_nl` | Yes |   |   | Yes
`string_tu` |   | Yes | Yes
`string_tl` |   | Yes |   | Yes

# List of Code

**TODO** SQL Macro `run_validations( table_name, list_of_ColumnDomains )`