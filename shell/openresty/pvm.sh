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
export PATH=/usr/local/openresty-1.15.6.1rc0-debug/nginx/sbin:$PATH

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
