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

######################################## Golang funcs ########################################

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
  Usage:
	-o 1
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

######################################## Golang funcs End ########################################
