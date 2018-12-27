#!/usr/bin/env bash

HOSTNAME=$(hostname)
PRLCTL_HOME=${PRLCTL_HOME:-"/media/psf/runX"}
[ ! -d ${PRLCTL_HOME} ] && PRLCTL_HOME="/tmp"
sudo swapoff -a
[ $(hostname) = "kube1" ] && export PATH="$PATH:$PRLCTL_HOME/code/istio-1.0.5/bin:$PRLCTL_HOME/code/helm-v2.12.1"

fetch_tar_pkg() {
	[ -z ${1} -o -z ${2} ] && echo "need a src url and local full file name" && exit 1
	local src_url=${1}
	local local_name=${2}

	local dir_name=$(dirname ${local_name})
	[ ! -d ${dir_name} ] && mkdir -p ${dir_name}
	[ ! -f ${local_name} ] &&
		curl -fSL ${src_url} -o ${local_name}

	if [ ! -z ${3} ]; then
		local res_dir_name=${3}
		cd ${dir_name}
		[ -d "${dir_name}/${res_dir_name}" ] && rm -rf "${dir_name}/${res_dir_name}"
		tar zxf $(basename ${local_name})
		cd -
	fi
}

# ----------- helm ---------- #
deploy_helm() {
	local helm_version="v2.12.1"
	local src_url="https://storage.googleapis.com/kubernetes-helm/helm-${helm_version}-linux-amd64.tar.gz"
	local local_name="${PRLCTL_HOME}/code/helm-${helm_version}-linux-amd64.tar.gz"
	local res_dir_name="helm-${helm_version}"
	fetch_tar_pkg ${src_url} ${local_name} ${res_dir_name}
	mv "${PRLCTL_HOME}/code/linux-amd64" "${PRLCTL_HOME}/code/${res_dir_name}"
	kubectl create -f $RUN_PATH/helm/rbac.yaml
	# @TODO try to init with --tiller-tls-verify option
	helm init --service-account tiller
}

# --------- kubeadm --------- #
deploy_istio() {
	local istio_version=${IV:-"1.0.5"}
	local src_url="https://github.com/istio/istio/releases/download/${istio_version}/istio-${istio_version}-linux.tar.gz"
	local local_name="${PRLCTL_HOME}/code/istio-${istio_version}-linux.tar.gz"
	local res_dir_name="istio-${istio_version}"
	fetch_tar_pkg ${src_url} ${local_name} ${res_dir_name}
	helm template $PRLCTL_HOME/code/istio-${istio_version}/install/kubernetes/helm/istio --name istio --namespace istio-system >$RUN_PATH/istio/helm-istio-${istio_version}.yaml
	kubectl create namespace istio-system
	kubectl create -f $RUN_PATH/istio/helm-istio-${istio_version}.yaml
}

clean_istio() {
	local istio_version=${IV:-"1.0.5"}
	kubectl delete namespace istio-system
	kubectl delete -f $RUN_PATH/istio/helm-istio-${istio_version}.yaml
}

# --------- kubeadm --------- #
k_init_kubeadm() {
	mkdir -p $HOME/.kube
	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	sudo chown $(id -u):$(id -g) $HOME/.kube/config
}

k_reset_x() {
	sudo kubeadm reset -f
	sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X
}

# --------- cilium --------- #
k_init_cilium() {
	local key_path="${PRLCTL_HOME}/runpath/kube1/cilium/etcd-secret/"
	local ca="${key_path}/ca.crt"
	local client_key="${key_path}/client.key"
	local client_crt="${key_path}/client.crt"

	[ -f "${ca}" ] && rm "${ca}"
	[ -f "${client_key}" ] && rm "${client_key}"
	[ -f "${client_crt}" ] && rm "${client_crt}"

	sudo cp "/etc/kubernetes/pki/etcd/ca.crt" "${ca}"
	sudo cp "/etc/kubernetes/pki/etcd/peer.key" "${client_key}"
	sudo cp "/etc/kubernetes/pki/etcd/peer.crt" "${client_crt}"
	kubectl create secret generic -n kube-system cilium-etcd-secrets \
		--from-file=etcd-ca="${ca}" \
		--from-file=etcd-client-key="${client_key}" \
		--from-file=etcd-client-crt="${client_crt}"
	kubectl create -f $RUN_PATH/cilium/cilium.yaml
}

clean_cilium() {
	kubectl delete secrets -n kube-system cilium-etcd-secrets
	kubectl delete -f $RUN_PATH/cilium/cilium.yaml
}

# --------- weave --------- #
# https://www.weave.works/docs/net/latest/tasks/ipam/configuring-weave/
# !!! the weave Network 10.32.0.0/12 overlaps with existing route 10.0.0.0/8 on host
# !!! setting the IPALLOC_RANGE in weave-net DaemonSet container weave
# !!! and make sure that your "serviceSubnet" in kubeadm config "networking" setting could be accecc througt your node-hosts
deploy_weave() {
	kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
}

clean_weave() {
	kubectl delete -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
}

# --------- ingress --------- #
# !!! the externalIPs in x-service.yaml
deploy_ingress() {
	kubectl create -f "$RUN_PATH/ingress/kub-ngx/mandatory.yaml"
	# x-service expose the service in k8s Cluster
	kubectl create -f "$RUN_PATH/ingress/kub-ngx/x-service.yaml"
}

clean_ingress() {
	kubectl delete -f "$RUN_PATH/ingress/kub-ngx/mandatory.yaml"
	kubectl delete -f "$RUN_PATH/ingress/kub-ngx/x-service.yaml"
}

# --------- dashboard --------- #
# !!! the "DNS." settings in runpath/kube1/ingress/secret/openssl.cnf
# !!! the ingress "host" in k-dashboard/ingress.yaml
deploy_kube_dashboard() {
	kubectl create -f "${RUN_PATH}/k-dashboard/kubernetes-dashboard.yaml"
	kubectl create -f "${RUN_PATH}/k-dashboard/admin.yaml"
	$RUN_PATH/ingress/secret/gen.sh "ingress-secret" "kube-system"
	kubectl create -f "${RUN_PATH}/k-dashboard/ingress.yaml"
}

clean_kube_dashboard() {
	kubectl delete -f "${RUN_PATH}/k-dashboard/kubernetes-dashboard.yaml"
	kubectl delete -f "${RUN_PATH}/k-dashboard/admin.yaml"
	kubectl delete secrets -n "kube-system" "ingress-secret"
	kubectl delete -f "${RUN_PATH}/k-dashboard/ingress.yaml"
}

get_dashboard_secrets() {
	kubectl describe secrets -n kube-system $(kubectl get secrets -n kube-system | grep admin | awk '{print $1}')
}

# --------- idevz-t --------- #
deploy_idevz_t() {
	kubectl create -f "${RUN_PATH}/t/"
}

clean_idevz_t() {
	kubectl delete -f "${RUN_PATH}/t/"
}

sk() {
	[ -x $(which kubectl) ] && source <(kubectl completion zsh)
}

k_docker_completion() {
	# https://gist.github.com/ro31337/b2c33ad0b90636e9e3bb76fb4fb76907
	mkdir -p ~/.oh-my-zsh/plugins/docker/
	curl -fLo ~/.oh-my-zsh/plugins/docker/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
	# Add docker to plugins section in ~/.zshrc
	exec zsh
}
