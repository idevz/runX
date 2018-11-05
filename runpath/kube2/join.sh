#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 2018/03/12
# Description:       AUTO Generate by runX.
# ./join.sh          Make a node join to a K8S cluster.
### END ###
sudo   kubeadm join 10.211.55.150:6443 --token dnjvuv.2q19dzhqxh4n68dk --discovery-token-ca-cert-hash sha256:eb77a3d9ad5c627e6d3e00bc73290abe8c857355929b4568b61b3d3ab3c54adc
