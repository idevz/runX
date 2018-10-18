## Pay tribute to GNU and all of the GNU projects and so are the Contributers.

### GDB error:No such file or directory

sometimes, you may delete your sources after the installation. then when you run gdb once again you may
get this error: 'No such file or directory ...'.

the Only way we can fix this error, is untars a new source code package,
and then using the `set substitute-path` to set the new source code path.

the `set substitute-path` directive need two arguments, the first is the 
old source path(which you can run `info source` command to check the old
source path which gdb checked and "not found"), the secend paramers is the
new source path which you puth the source code right now.

belowe is a simple truely demonstration.

```bash
(gdb) source ~/or.gdbps
Breakpoint 1 at 0x584df9: file ../ngx_lua-0.10.13/src/ngx_http_lua_module.c, line 642.
Breakpoint 2 at 0x59415b: file ../ngx_lua-0.10.13/src/ngx_http_lua_util.c, line 3745.
Breakpoint 3 at 0x58d1a5: file ../ngx_lua-0.10.13/src/ngx_http_lua_util.c, line 202.
Breakpoint 4 at 0x4207ed: file src/core/nginx.c, line 207.
(gdb) r -p /media/psf/code/z/git/weibo-or/v-demo-app/run_path/ -c v.conf
Starting program: /usr/local/openresty-debug/bin/openresty -p /media/psf/code/z/git/weibo-or/v-demo-app/run_path/ -c v.conf
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib64/libthread_db.so.1".

Breakpoint 4, main (argc=5, argv=0x7fffffffe388) at src/core/nginx.c:207
207	src/core/nginx.c: No such file or directory.
(gdb) shell ls ../nginx-1.13.6/src/core/nginx.c
../nginx-1.13.6/src/core/nginx.c
(gdb) info source
Current source file is src/core/nginx.c
Compilation directory is /tmp/openresty-1.13.6.2/build/nginx-1.13.6
Source language is c.
Compiled with DWARF 2 debugging format.
Does not include preprocessor macro info.
(gdb) set substitute-path /tmp/openresty-1.13.6.2/build/nginx-1.13.6../nginx-1.13.6
Incorrect usage, too few arguments in command
(gdb) set substitute-path /tmp/openresty-1.13.6.2/build/nginx-1.13.6 ../nginx-1.13.6
(gdb) r -p /media/psf/code/z/git/weibo-or/v-demo-app/run_path/ -c v.conf
```