directory /media/psf/code/z/to-or/tools/openresty-gdb-utils

py import sys
py sys.path.append("/media/psf/code/z/to-or/tools/openresty-gdb-utils")

source luajit20.gdb
source ngx-lua.gdb
source luajit21.py
source ngx-raw-req.py
set python print-stack full
