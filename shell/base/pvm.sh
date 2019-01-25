#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 15:46:55 2019/01/25
# Description:       Need more really true
# pvm          source ./pvm && funcs...
#
# Environment variables that control this script:
#
### END ###

set -e
BASE_DIR=${BASE_DIR:-"$(readlink -f "$(dirname "$0")")"}

ini_redis_src() {
	git clone https://github.com/antirez/redis.git
	cd redis && git checkout -b redis-${version}
	touch CMakeLists.txt
	cp ./CMakeLists.txt ./deps/linenoise
	cp ./CMakeLists.txt ./deps/lua
	cp ./CMakeLists.txt ./deps/
	cp ./CMakeLists.txt ./src/modules
}
