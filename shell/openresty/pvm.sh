#!/usr/bin/env bash
# set -x
# default set to using debug version openresty
dbg_or
export PATH=/usr/local/openresty-1.13.6.2-debug/luajit/bin:$PATH

luajit_prove() {
	if [ ! -z ${VALGRIND} ]; then
		export TEST_NGINX_USE_VALGRIND=1
	fi
	# export TEST_NGINX_BENCHMARK_WARMUP=500
	# export TEST_NGINX_BENCHMARK='2000000 20'
	prove "$@"
}
export PATH=/usr/local/openresty-1.15.8.1rc2-debug/bin:/usr/local/openresty-1.15.8.1rc2-debug/nginx/sbin:$PATH

mst_debug() {
	local gdb_server_port=111
	x gdbserver :${gdb_server_port} $(which openresty) \
		-p ${RUN_PATH}/ngx.d \
		-c $RUN_PATH/ngx.d/conf/mst-debug.conf &
}

pid_debug() {
	local gdb_server_port=222
	x $(which openresty) \
		-p ${RUN_PATH}/ngx.d \
		-c $RUN_PATH/ngx.d/conf/pid-debug.conf
	sleep 1
	local or_pid=$(ps aux | grep 'nginx: worker process' | grep -v grep | awk '{print $2}')
	echo "get pid: ${or_pid}"
	x gdbserver --attach :${gdb_server_port} ${or_pid} &
}

stop_debug() {
	x pkill gdbserver
	x pkill openresty
}

start_debug_or() {
	sudo pkill openresty
	x openresty -p ${RUN_PATH}/ngx.d
}

stop_or() {
	sudo pkill openresty
}

fire_lua() {
	local pid="$1"
	local time="${2:-10}"
	x /usr/local/tools/openresty-systemtap-toolkit/ngx-sample-lua-bt --luajit20 -a '-DMAXACTION=100000' -p "$pid" -t "$time" >"$RUN_PATH/ss/lua.bt"
	x /usr/local/tools/openresty-systemtap-toolkit/fix-lua-bt "$RUN_PATH/ss/lua.bt" >"$RUN_PATH/ss/lua-fix.bt"
	x /usr/local/tools/FlameGraph/stackcollapse-stap.pl "$RUN_PATH/ss/lua-fix.bt" >"$RUN_PATH/ss/lua.cbt"
	x /usr/local/tools/FlameGraph/flamegraph.pl "$RUN_PATH/ss/lua.cbt" >"$RUN_PATH/ss/lua-fix.svg"
}

fire_c_oncpu() {
	local pid="$1"
	local time="${2:-10}"
	x /usr/local/tools/openresty-systemtap-toolkit/
	-bt -u -a '-DMAXACTION=100000' -p "$pid" -t "$time" >"$RUN_PATH/ss/ngx-oncpu.bt"
	x /usr/local/tools/FlameGraph/stackcollapse-stap.pl "$RUN_PATH/ss/ngx-oncpu.bt" >"$RUN_PATH/ss/ngx-oncpu.cbt"
	x /usr/local/tools/FlameGraph/flamegraph.pl "$RUN_PATH/ss/ngx-oncpu.cbt" >"$RUN_PATH/ss/ngx-oncpu.svg"
}

fire_c_offcpu() {
	local pid="$1"
	local time="${2:-10}"
	x /usr/local/tools/openresty-systemtap-toolkit/sample-bt-off-cpu -u -a '-DMAXACTION=100000' -p "$pid" -t "$time" >"$RUN_PATH/ss/ngx-offcpu.bt"
	x /usr/local/tools/FlameGraph/stackcollapse-stap.pl "$RUN_PATH/ss/ngx-offcpu.bt" >"$RUN_PATH/ss/ngx-offcpu.cbt"
	x /usr/local/tools/FlameGraph/flamegraph.pl "$RUN_PATH/ss/ngx-offcpu.cbt" >"$RUN_PATH/ss/ngx-offcpu.svg"
}

fire_memx() {
	local pid="$1"
	x /usr/local/tools/stapxx/samples/sample-bt-leaks.sxx -x "$pid" -v -D STP_NO_OVERLOAD -D MAXMAPENTRIES=100000 >"$RUN_PATH/ss/ngx-mem.bt"
	x /usr/local/tools/FlameGraph/stackcollapse-stap.pl "$RUN_PATH/ss/ngx-mem.bt" >"$RUN_PATH/ss/ngx-mem.cbt"
	x /usr/local/tools/FlameGraph/flamegraph.pl --encoding="ISO-8859-1" --title="Memery usage flamegraph" "$RUN_PATH/ss/ngx-mem.cbt" >"$RUN_PATH/ss/ngx-mem.svg"
}

fire_mem() {
	local pid="$1"
	x /usr/local/tools/openresty-systemtap-toolkit/ngx-leaked-pools -p "$pid"
}

motan_init() {
	local or_version="1.15.8.1rc2"
	sudo ln -sf $GIT/weibo-or/motan-openresty/lib/motan /usr/local/openresty-"$or_version"-debug/site/lualib/motan
	sudo ln -sf $GIT/weibo-or/motan-openresty/lib/motan/libs/cmotan.so /usr/local/openresty-"$or_version"-debug/site/lualib/cmotan.so
	sudo ln -sf $GIT/weibo-or/v/lib/v /usr/local/openresty-"$or_version"-debug/site/lualib/v
	sudo ln -sf $GIT/weibo-or/weibo-motan/lib/wmotan /usr/local/openresty-"$or_version"-debug/site/lualib/wmotan
	sudo ln -sf $GIT/weibo-or/weibo-motan/t/resty /usr/local/openresty-"$or_version"-debug/site/lualib/resty
	sudo ln -sf $GIT/weibo-or/motan-openresty/lib/motan/libs/libmotan_tools.so /lib64/libmotan_tools.so
}

motan_mac_init() {
	sudo ln -sf $GIT/weibo-or/motan-openresty/lib/motan /usr/local/Cellar/openresty/1.13.6.2/site/lualib/motan
	sudo ln -sf $GIT/weibo-or/v/lib/v /usr/local/Cellar/openresty/1.13.6.2/site/lualib/v
	sudo ln -sf $GIT/weibo-or/weibo-motan/lib/wmotan /usr/local/Cellar/openresty/1.13.6.2/site/lualib/wmotan
	sudo ln -sf $GIT/weibo-or/weibo-motan/t/resty /usr/local/Cellar/openresty/1.13.6.2/site/lualib/resty
	sudo ln -sf $GIT/weibo-or/motan-openresty/lib/motan/libs/libmotan.dylib /usr/local/Cellar/openresty/1.13.6.2/site/lualib/cmotan.so
}
