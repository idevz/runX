#!/usr/bin/env bash

HOSTNAME=$(hostname)
PRLCTL_HOME=${PRLCTL_HOME:-"/media/psf/runX"}
sudo swapoff -a

k_init_kubeadm() {
	mkdir -p $HOME/.kube
	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	sudo chown $(id -u):$(id -g) $HOME/.kube/config
}

k_init_cilium() {
	# ca-file: '/etc/kubernetes/pki/etcd/ca.crt'
	# key-file: '/etc/kubernetes/pki/etcd/peer.key'
	# cert-file: '/etc/kubernetes/pki/etcd/peer.crt'
	kubectl create secret generic -n kube-system cilium-etcd-secrets \
		--from-file=etcd-ca=ca.crt \
		--from-file=etcd-client-key=client.key \
		--from-file=etcd-client-crt=client.crt
}

k_init_cgroup() {
	cat >/etc/sysconfig/kubelet <<EO
	KUBELET_EXTRA_ARGS=--runtime-cgroups=/systemd/system.slice --kubelet-cgroups=/systemd/system.slice
EO
}

k_init_c_memery() {
	cat >/etc/systemd/system/kubelet.service.d/11-cgroups.conf <<cgroup
	[Service]
	CPUAccounting=true
	MemoryAccounting=true
cgroup
}

k_docker_completion() {
	# https://gist.github.com/ro31337/b2c33ad0b90636e9e3bb76fb4fb76907
	mkdir -p ~/.oh-my-zsh/plugins/docker/
	curl -fLo ~/.oh-my-zsh/plugins/docker/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
	# Add docker to plugins section in ~/.zshrc
	exec zsh
}
