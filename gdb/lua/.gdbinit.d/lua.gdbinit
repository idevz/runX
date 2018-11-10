# This file:
#   http://angg.twu.net/.lua51/PP.gdb.html
#   http://angg.twu.net/.lua51/PP.gdb
# Author:  Eduardo Ochs <eduardoochs@gmail.com>
# Version: 2008dec02
# Public domain.
#
# (find-angg ".emacs" "eepitch-gdb-lua")
# (find-angg "LUA/lua50init.lua" "PPeval")
# (find-es "lua5" "lua-api-from-gdb")
#   file:///home/edrx/TH/L/.lua51/PP.gdb.html
#
# (find-node "(gdb)Calling" "`print EXPR'")
# (find-node "(gdb)Calling" "`call EXPR'")
# (find-node "(gdb)Define" "`define COMMANDNAME'")
# (find-node "(gdb)Define" "`document COMMANDNAME'")
# (find-node "(gdb)Data" "`print'" "abbreviated `p'")
# (find-lua51file "src/lua.h" "#define LUA_GLOBALSINDEX" "(-10002)")
# (find-lua51file "src/lua.h" "#define lua_getglobal")
# (find-ecvsfile "src/.gdbinit")

# Quick index:
# «.depth»		(to "depth")
# «.PP»			(to "PP")
# «.PPeval»		(to "PPeval")
# «.lua_pusheval»	(to "lua_pusheval")
# «.quickstart»		(to "quickstart")
# «.lua_getglobal»	(to "lua_getglobal")



# «depth»  (to ".depth")
define depth
  p lua_gettop(L)
end
document depth
print the depth of the Lua stack.
If the depth is, say, 4, then the indices -4..-1 and 1..4 are valid
arguments for `PP', defined below.
end


# «PP»  (to ".PP")
define PP
  call lua_getfield  (L, -10002, "PP")
# call $arg0==0 ? lua_pushnil(L) : lua_pushvalue(L, $arg0)
# call $arg0==0 ? lua_pushnil(L) : lua_pushvalue(L, $arg0<0 ? $arg0-1 : $arg0)
  call lua_pushvalue(L, $arg0<=0 ? $arg0-1 : $arg0)
  call lua_call      (L, 1, 0)
end
document PP
print the contents of a position in the Lua stack.
Usage: "PP -1" prints the top of the stack,
       "PP -2" prints the element below the top of the stack,
       "PP  1" prints the first element of the stack,
       "PP  2" prints the second element of the stack, etc.
See: (find-luamanualw3m "#3.2" "0 is never an acceptable index.")
     (find-angg "LUA/lua50init.lua" "PP")
Note: the "?:" below is a cute hack. As we've pushed the function PP
on the stack, the adjustment makes "PP 0" print PP, "PP -1" print
what was the top of the stack before pushing PP on it, "PP -2" print
what was the element below the top of the stack, and so on. The
behavior on positive indices is unchanged. I used to push a nil when
$arg0==0 and to print PP when $arg0==-1 and the (old) top of the
stack when $arg0==-2, which forced the user (me) to make a mental
adjustment just to keep this function as low-level as possible...
Not good, this solution is much nicer.
end


# «PPeval»  (to ".PPeval")
define PPeval
  call lua_getfield  (L, -10002, "PPeval")
  call lua_pushstring(L, $arg0)
  call lua_call      (L, 1, 0)
end
document PPeval
evaluate $arg0 (a string), or print its results with "print" or "PP".
This command just calls "PPeval" (a Lua function) with $arg0 as its
sole argument.
See: (find-angg "LUA/lua50init.lua" "PPeval")
Examples:
  (gdb) PPeval "a = {11, 22}"
  (gdb) PPeval "=  a, 'foo'"
     table: 0x8077210    foo
  (gdb) PPeval "== a, 'foo'"
     {1=11, 2=22} "foo"
  (gdb) 
end


# «lua_pusheval»  (to ".lua_pusheval")
# Pushes back exactly 1 result
define lua_pusheval
  call lua_getfield  (L, -10002, "PPeval")
  call lua_pushstring(L, "return ")
  call lua_pushstring(L, $arg0)
  call lua_concat    (L, 2)
  call lua_call      (L, 1, 1)
end
document lua_pusheval
push the result of eval('return '..$arg0) onto the stack. 
end


# «quickstart»  (to ".quickstart")
define quickstart
  set args -e 'math.sin(0)'
  tbr math_sin
  run
end
document quickstart
set a breakpoint at math_sin and run "lua51 -e 'math.sin(0)'".
end


# «lua_getglobal»  (to ".lua_getglobal")
define lua_getglobal
  call lua_getfield  (L, -10002, $arg0)
end



# Local variables:
# coding: raw-text-unix
# mode:   gdb-script
# end:
