# `luatz.gettime`

A module to get the current time.

Uses the most precise method available (in order:)

  - Use [ljsyscall](http://www.myriabit.com/ljsyscall/) to access
  	  - `clock_gettime(2)` called with `CLOCK_REALTIME`
  	  - `gettimeofday(2)`
  - [luasocket](http://w3.impa.br/~diego/software/luasocket/)'s `socket.gettime`
  - [`os.time`](http://www.lua.org/manual/5.2/manual.html#pdf-os.time)

### `source`

The library/function currently in use.

### `resolution`

The smallest time resolution (in seconds) available from `gettime ( )` .

### `gettime ( )`

Returns the number of seconds since unix epoch (1970-01-01T00:00:00Z) as a lua number
