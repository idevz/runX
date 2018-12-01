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
