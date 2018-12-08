#!/usr/bin/env bash
# tools for pvms which deploy though runX.
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

hz_ns() {
	TIMES=${1}
	while [ "${TIMES}" -gt 0 ]; do
		# sudo netstat -natpl | grep '10.211.55.7:80.*TIME_WAIT' | wc -l
		# sudo netstat -natpl | grep -i TIME_WAIT | wc -l
		echo 'CLOSE_WAIT'
		sudo netstat -antp | grep 'CLOSE_WAIT' | wc -l
		echo 'TIME_WAIT'
		sudo netstat -antp | grep 'TIME_WAIT' | wc -l
		echo 'ESTABLISHED'
		sudo netstat -antp | grep 'ESTABLISHED' | wc -l
		echo '127.0.0.1:80-CLOSE_WAIT'
		sudo netstat -antp | grep -Ev 'LISTEN|sshd' | grep 'CLOSE_WAIT' | wc -l
		echo '127.0.0.1:80-TIME_WAIT'
		sudo netstat -antp | grep -Ev 'LISTEN|sshd' | grep 'TIME_WAIT' | wc -l
		echo '127.0.0.1:80-ESTABLISHED'
		sudo netstat -antp | grep -Ev 'LISTEN|sshd' | grep 'ESTABLISHED' | wc -l
		echo
		echo
		echo

		sleep .5
		TIMES=$((${TIMES} - 1))
	done
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
g is a tool for golang programing.

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
	[ ! -d "/var/run/php-fpm" ] && x mkdir -p /var/run/php-fpm
	while getopts "udrt" OPTS; do
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
		r)
			x pkill openresty
			xnotic "php-fpm sucess stoped."

			x pkill php-fpm
			xnotic "openresty sucess stoped."

			x php-fpm -p "${RUN_PATH}/fpm.d" -c "${RUN_PATH}/fpm.d/etc"
			xnotic "php-fpm sucess start , cmd like:"
			xnotic "	php-fpm -p ${RUN_PATH}/fpm.d -c ${RUN_PATH}/fpm.d/etc"

			x openresty -p "${RUN_PATH}/ngx.d"
			xnotic "openresty sucess start, cmd like:"
			xnotic "	openresty -p ${RUN_PATH}/ngx.d"
			;;

		\?)
			echo "
p is a tool for php programing.

Usage:

	p options [arguments]

The options are:

	-u       start the php-fpm and openresty service.
	         php-fpm run path is ${RUN_PATH}/fpm.d
			 php ini path is ${RUN_PATH}/fpm.d/etc
			 openresty run path is ${RUN_PATH}/ngx.d
	-d       down both openresty and php-fpm service.
		"
			;;
		esac
	done
}
#------------------------------------------ PHP funcs End -----------------------------------------#

#-------------------------------------------  K8S funcs  ------------------------------------------#
has_k8() {
	which kubeadm >/dev/null 2>&1
}

has_k8 && k_reset_x() {
	sudo kubeadm reset -f
	sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X
}

has_k8 && sysd_mount_bfpfs() {
	cat <<EOF | sudo tee /etc/systemd/system/sys-fs-bpf.mount
[Unit]
Description=Cilium BPF mounts
Documentation=http://docs.cilium.io/
DefaultDependencies=no
Before=local-fs.target umount.target
After=swap.target

[Mount]
What=bpffs
Where=/sys/fs/bpf
Type=bpf

[Install]
WantedBy=multi-user.target
EOF
}

has_k8 && k8() {
	while getopts "in" OPTS; do
		case "${OPTS}" in
		i)
			mkdir -p $HOME/.kube
			sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
			sudo chown $(id -u):$(id -g) $HOME/.kube/config
			;;
		n)
			echo "deploy network"
			;;
		\?)
			echo "
k8 is a tool for K8S.

Usage:

	k8 options [arguments]

The options are:

	-u       start the php-fpm and openresty service.
	         php-fpm run path is ${RUN_PATH}/fpm.d
			 php ini path is ${RUN_PATH}/fpm.d/etc
			 openresty run path is ${RUN_PATH}/ngx.d
	-d       down both openresty and php-fpm service.
		"
			;;
		esac
	done
}
#------------------------------------------ K8S funcs End -----------------------------------------#

#------------------------------------------  docker funcs  -----------------------------------------#
# docker fetch
dk_fc() {
	local OUT_GOING_ACCOUNT_FILE=${OGA:-"out-accounts-info.zj"}
	[ -f "$PRLCTL_HOME/deploy/k8s/${OUT_GOING_ACCOUNT_FILE}" ] &&
		source "$PRLCTL_HOME/deploy/k8s/${OUT_GOING_ACCOUNT_FILE}"
	local PRI_REGISTRY="${OUT_IP}:5000"
	local pub_image="${1}"
	# local pri_image="$(hostname -I | awk '{print $1}'):5000/${pub_image}"
	local pri_image="${PRI_REGISTRY}/${pub_image}"
	docker pull "${pub_image}" >/dev/null 2>&1
	docker tag "${pub_image}" "${pri_image}" >/dev/null 2>&1
	docker push "${pri_image}" >/dev/null 2>&1
}

dk() {
	while getopts "i" OPTS; do
		case "${OPTS}" in
		i)
			local k8s_images=(
				k8s.gcr.io/kube-apiserver:v1.12.2
				k8s.gcr.io/kube-controller-manager:v1.12.2
				k8s.gcr.io/kube-scheduler:v1.12.2
				k8s.gcr.io/kube-proxy:v1.12.2
				k8s.gcr.io/pause:3.1
				k8s.gcr.io/etcd:3.2.24
				k8s.gcr.io/coredns:1.2.2
			)
			for image in ${k8s_images[@]}; do
				echo "fetch ${image}"
				dk_fc "${image}"
			done
			;;
		esac
	done
}
#----------------------------------------- docker funcs End ----------------------------------------#
