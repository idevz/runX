# `luatz`

Requiring the base luatz module will give you a table of commonly used functions and submodules.

The table includes the following sub modules, which have their own documentation:

  - `parse`: Parses common date/time formats
  - `timetable`: Class for date/time objects supporting normalisation


### `time ( )`

Returns the current unix timestamp using the most precise source available.
See `gettime` for more information.

### `now ( )`

Returns the current time as a timetable object
See `timetable` for more information


### `get_tz ( [timezone_name] )`

Returns a timezone object (see `tzinfo` documentation) for the given `timezone_name`.
If `timezone_name` is `nil` then the local timezone is used.
If `timezone_name` is an absolute path, then that `tzinfo` file is used

This uses the local [zoneinfo database](https://www.iana.org/time-zones); 
names are usually of the form `Country/Largest_City` e.g. "America/New_York".
Check [wikipedia](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for an example list.


### `time_in ( timezone_name [, utc_ts] )`

Returns the current time in seconds since 1970-01-01 0:00:00 in the given timezone as a string,
(same semantics as `get_tz`) at the given UTC time (defaults to now).


## As in the C standard library

### `gmtime ( ts )`

### `localtime ( ts )`

### `ctime ( ts )`

