#!/usr/bin/env bash

# default set to using debug version openresty
dbg_or

luajit_prove() {
	if [ ! -z ${VALGRIND} ]; then
		export TEST_NGINX_USE_VALGRIND=1
	fi
	# export TEST_NGINX_BENCHMARK_WARMUP=500
	# export TEST_NGINX_BENCHMARK='2000000 20'
	prove "$@"
}
export PATH=/usr/local/openresty-1.15.6.1rc0-debug/nginx/sbin:$PATH
