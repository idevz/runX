#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 2018/03/12
# Description:       AUTO Generate by runX.
# ./join.sh          Make a node join to a K8S cluster.
### END ###
sudo   kubeadm join 10.211.55.150:6443 --token gkp02r.2wwytrherkgyjy8a --discovery-token-ca-cert-hash sha256:6c2288df32f6b908fb80d5acff73f8739b769a261dd54b612f047285aaf9a523
