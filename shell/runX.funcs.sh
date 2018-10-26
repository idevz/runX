#!/usr/bin/env bash

xnotic() {
	echo
	echo ${1}
	echo
}

# x pkill openresty
# a good way to "workaround" the `secure_path` setted in the `/etc/sudoers` file
[ $(uname) = 'Linux' ] && x() {
	sudo env "PATH=$PATH" "$@"
}

runXdebug() {
	set -x
	"$@"
	set +x
}

#@TODO add a clean history tool to clean the all the .zsh_history from all pvms
clean_history() {
	decleri -A parttens
}

#-----------------------------------------  Golang funcs  -----------------------------------------#
[ ! -z ${GOPATH} ] && g() {
	while getopts "o:t:l" OPTS; do
		case "${OPTS}" in
		o)
			code $(echo ${GOPATH} | cut -f ${OPTARG} -d ":")
			;;
		t)
			cd $(echo ${GOPATH} | cut -f ${OPTARG} -d ":")
			;;
		l)
			OLD_IFS=${IFS}
			IFS=':' read -rA GOPATHES <<<"${GOPATH}"
			for gopath in ${GOPATHES}; do
				echo ${gopath}
			done
			IFS=${OLD_IFS}
			;;
		\?)
			echo "
g is a tool for g programing.

Usage:

	g options [arguments]

The options are:

	-o       using code to open the gopath, eg. 'g -o 1' open the first gopath
	-t       cd to the gopath, eg. 'g -t 1' cd to the first gopath
	-l       show all the gopathes
		"
			;;
		esac
		return
	done
}

[ ! -z ${GOPATH} ] && export_go_path() {
	GOPATH_INDEX=1
	for gopath in $(echo ${GOPATH//:/ }); do
		export G${GOPATH_INDEX}=${gopath}
		GOPATH_INDEX=$((${GOPATH_INDEX} + 1))
	done
}
#---------------------------------------- Golang funcs End ----------------------------------------#

#-------------------------------------------  PHP funcs  ------------------------------------------#
has_php() {
	which php-fpm >/dev/null 2>&1
}

has_php && p() {
	while getopts "udt" OPTS; do
		case "${OPTS}" in
		u)
			x php-fpm -p "${RUN_PATH}/fpm.d" -c "${RUN_PATH}/fpm.d/etc"
			xnotic "php-fpm sucess start , cmd like:"
			xnotic "	php-fpm -p ${RUN_PATH}/fpm.d -c ${RUN_PATH}/fpm.d/etc"

			x openresty -p "${RUN_PATH}/ngx.d"
			xnotic "openresty sucess start, cmd like:"
			xnotic "	openresty -p ${RUN_PATH}/ngx.d"
			;;
		d)
			x pkill openresty
			xnotic "php-fpm sucess stoped."

			x pkill php-fpm
			xnotic "openresty sucess stoped."
			;;
		esac
	done
}
#------------------------------------------ PHP funcs End -----------------------------------------#
