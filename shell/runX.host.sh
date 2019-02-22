#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 2018/03/12
# Description:   runX funcs for host.
#
# Environment variables that control init:
### END ###

# tools for host where prlctl is.
[ -f ${PRLCTL_HOME}/shell/runX.funcs.sh ] && source ${PRLCTL_HOME}/shell/runX.funcs.sh
_prlctl_get_ip_by_host() {
	local HOST_NAME=${1}
	[ -z "${HOST_NAME}" ] && xnotic "empty host name." && return
	IP=$(prlctl exec ${HOST_NAME} ip addr show 2>/dev/null | grep -Eo 'inet (10.*)\/24' | cut -d ' ' -f 2 | cut -d '/' -f1)
	if [ -z "${IP}" ]; then
		[ ! -z "${PRLCTL_HOME}" ] && IP=$(cat "${PRLCTL_HOME}/deploy/hosts" | grep "${HOST_NAME}" | cut -d ' ' -f1)
	fi
	echo ${IP}
}

_check_pvm_is_exist() {
	local HOST_NAME=${1}
	[ -z "${HOST_NAME}" ] && xnotic "empty host name." && return 1
	$(prlctl list "${HOST_NAME}" >/dev/null 2>&1) && return 0
	return 1
}

_check_pvm_is_alive() {
	local HOST_NAME=${1}
	[ -z "${HOST_NAME}" ] && xnotic "empty host name." && return 1

	_check_pvm_is_exist "${HOST_NAME}" || return 1
	local PVM_RUN_INFO="$(prlctl list ${HOST_NAME})"
	# declare -A MAP
	if [ $(echo ${PVM_RUN_INFO} | grep "running" | grep -Eo "${HOST_NAME}$") ]; then
		return 0
	elif [ $(echo ${PVM_RUN_INFO} | grep "stopped" | grep -Eo "${HOST_NAME}$") ]; then
		return 1
	fi
}

_waiting_til_done() {
	until "$@" >/dev/null 2>&1; do
		sleep 1
		echo -n "."
	done
}

multi_for_i() {
	DO=${1}
	OPTARG=${2}

	OLD_IFS=${IFS}
	IFS=',| |;' read -rA HOST_NAMES <<<"${OPTARG}"
	for HOST_NAME in ${HOST_NAMES}; do
		prlctl ${DO} "${HOST_NAME}" &
	done
	IFS=${OLD_IFS}
}

i() {
	while getopts "t:d:s:c:i:rlw:p:" OPTS; do
		case "${OPTS}" in
		t)
			multi_for_i "stop" "${OPTARG}"
			;;
		d)
			OLD_IFS=${IFS}
			IFS=',| |;' read -rA HOST_NAMES <<<"${OPTARG}"
			for HOST_NAME in ${HOST_NAMES}; do
				if _check_pvm_is_alive "${HOST_NAME}"; then
					prlctl stop "${HOST_NAME}" &
					xnotic "waiting for ${HOST_NAME} stopping."
					xnotic "deleting ..."
					_waiting_til_done prlctl delete "${HOST_NAME}"
				else
					if ! _check_pvm_is_exist "${HOST_NAME}"; then
						xnotic "there is no pvm named ${HOST_NAME}"
					else
						prlctl delete "${HOST_NAME}" &
					fi
				fi
			done
			IFS=${OLD_IFS}
			;;
		s)
			multi_for_i "start" "${OPTARG}"
			;;
		c)
			echo "${OPTS}"
			echo "${OPTIND}"
			echo "${OPTARG}"
			;;
		i)
			for HOST_NAME in $(echo ${OPTARG//,/ }); do
				IP_TMP=$(_prlctl_get_ip_by_host ${HOST_NAME})
				# http://wiki.bash-hackers.org/commands/builtin/printf
				printf '%-15s%-15s\n' ${HOST_NAME} ${IP_TMP}
			done | column -t
			;;
		r)
			cd ${PRLCTL_HOME}
			./runX nx >/dev/null 2>./runnig.err &
			cd -
			;;
		l)
			prlctl list ${2}
			;;
		w)
			multi_for_i "resume" "${OPTARG}"
			;;
		p)
			multi_for_i "suspend" "${OPTARG}"
			;;
		\?)
			echo "
i is a tool for manage the pvms such as login, stop, start and so on.

Usage:

	i options pvm1[,pvm2]

The options are:

	-t       stop the pvms		 
	-d       delete the pvms
	-s       start the pvms
	-i       list the ip of the pvms
	-r       exec the $(runX nx) command to deploy a pvm
	-l       list the pvms
	-w       weakup the suspended pvm
	-p       suspend the pvm
			"
			;;
		esac
		return
	done

	local TO_HOST=${1}
	local PVM_RUN_INFO="$(prlctl list ${TO_HOST})"

	if [ $(echo ${PVM_RUN_INFO} | grep "running" | grep -Eo "${TO_HOST}$") ]; then
		ssh z@$(_prlctl_get_ip_by_host ${TO_HOST})
	elif [ $(echo ${PVM_RUN_INFO} | grep "stopped" | grep -Eo "${TO_HOST}$") ]; then
		prlctl start "${TO_HOST}"

		xnotic "start check if the vms ${TO_HOST} is already started."
		_waiting_til_done prlctl exec "${TO_HOST}" ip addr show

		xnotic "waite for the ssh port open."

		local CHECK_HOST=$(_prlctl_get_ip_by_host ${TO_HOST})
		local CHECK_PORT=22
		_waiting_til_done nc -z ${CHECK_HOST} ${CHECK_PORT}
		ssh z@${CHECK_HOST}
	else
		xnotic "nothing to do with: ${TO_HOST}"
	fi
}

rx() {

	case "${1}" in
	o)
		shift
		local HOST_NAME="openresty"
		local IP=$(_prlctl_get_ip_by_host ${TO_HOST})
		ssh z@${IP} "$@"
		# restydoc ngx_lua

		# restydoc -s content_by_lua

		# restydoc -s proxy_pass
		;;
	esac
}

reset_sed_baks() {
	for f in $(find ./ -name '*.sed.bak'); do
		rf_name=$(echo $f | sed -e 's/\.sed\.bak//')
		mv "${f}" "${rf_name}"
	done
}

clean_sed_baks() {
	for f in $(find ./ -name '*.sed.bak'); do
		rm "${f}"
	done
}

[ ! -z ${GOPATH} ] && export_go_path
