#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 2018/03/12
# Description:       AUTO Generate by runX.
# ./join.sh          Make a node join to a K8S cluster.
### END ###
sudo   kubeadm join 10.211.55.150:6443 --token lf6gxb.1d47l1l2zb5ewjoa --discovery-token-ca-cert-hash sha256:da0e3781bf9d0b5842e9257974ff3740ab91dcd1123e8b067b02811b838189bf
