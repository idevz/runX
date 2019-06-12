local site_config = {}
site_config.LUAROCKS_PREFIX=[[/usr/local]]
site_config.LUA_INCDIR=[[/usr/local/openresty/luajit/include/luajit-2.1]]
site_config.LUA_LIBDIR=[[/usr/local/openresty/luajit/lib]]
site_config.LUA_BINDIR=[[/usr/local/openresty/luajit/bin]]
site_config.LUA_INTERPRETER=[[luajit]]
site_config.LUAROCKS_SYSCONFDIR=[[/usr/local/etc/luarocks]]
site_config.LUAROCKS_ROCKS_TREE=[[/usr/local]]
site_config.LUAROCKS_ROCKS_SUBDIR=[[/lib/luarocks/rocks]]
site_config.LUA_DIR_SET=true
site_config.LUAROCKS_UNAME_S=[[Linux]]
site_config.LUAROCKS_UNAME_M=[[x86_64]]
site_config.LUAROCKS_DOWNLOADER=[[curl]]
site_config.LUAROCKS_MD5CHECKER=[[md5sum]]
site_config.LUAROCKS_EXTERNAL_DEPS_SUBDIRS={ bin="bin", lib={ "lib", [[lib64]] }, include="include" }
site_config.LUAROCKS_RUNTIME_EXTERNAL_DEPS_SUBDIRS={ bin="bin", lib={ "lib", [[lib64]] }, include="include" }
return site_config
