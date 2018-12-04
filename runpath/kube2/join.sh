#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 2018/03/12
# Description:       AUTO Generate by runX.
# ./join.sh          Make a node join to a K8S cluster.
### END ###
sudo   kubeadm join 10.211.55.150:6443 --token bomcjw.mckps5gxfzgzdd5r --discovery-token-ca-cert-hash sha256:2d51eae8361fd87081e7aeb0aab3ce4e934b971b47d80ebb192490d29a4c78ab
