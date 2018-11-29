#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 06:11:38 2018/11/30
# Description:       update kube images
# pri-registry.sh    ./pri-registry.sh
#
# Environment variables that control init:
#
### END ###

# docker fetch
dk_fc() {
	local pub_image="${1}"
	local pri_image="$(hostname -I | awk '{print $1}'):5000/${pub_image}"
	docker pull "${pub_image}" >/dev/null 2>&1
	docker tag "${pub_image}" "${pri_image}" >/dev/null 2>&1
	docker push "${pri_image}" >/dev/null 2>&1
}

dk() {
	while getopts "i" OPTS; do
		case "${OPTS}" in
		i)
			local k8s_images=(
				k8s.gcr.io/kube-apiserver:v1.12.3
				k8s.gcr.io/kube-controller-manager:v1.12.3
				k8s.gcr.io/kube-scheduler:v1.12.3
				k8s.gcr.io/kube-proxy:v1.12.3
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

dk -i
