#!/usr/bin/env bash

HOSTNAME=$(hostname)
PRLCTL_HOME=${PRLCTL_HOME:-"/media/psf/runX"}
sudo swapoff -a

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
deploy_weave() {
	kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
}

clean_weave() {
	kubectl delete -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
}

# --------- ingress --------- #
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

k_docker_completion() {
	# https://gist.github.com/ro31337/b2c33ad0b90636e9e3bb76fb4fb76907
	mkdir -p ~/.oh-my-zsh/plugins/docker/
	curl -fLo ~/.oh-my-zsh/plugins/docker/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
	# Add docker to plugins section in ~/.zshrc
	exec zsh
}
