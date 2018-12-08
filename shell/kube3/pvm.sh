#!/usr/bin/env bash

HOSTNAME=$(hostname)
PRLCTL_HOME=${PRLCTL_HOME:-"/media/psf/runX"}
sudo swapoff -a

k_reset_x() {
	sudo kubeadm reset -f
	sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X
}
