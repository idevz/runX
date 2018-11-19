#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 2018/03/12
# Description:       AUTO Generate by runX.
# ./join.sh          Make a node join to a K8S cluster.
### END ###
sudo   kubeadm join 10.211.55.150:6443 --token t9ntmn.jqijoskm0wkrkgd4 --discovery-token-ca-cert-hash sha256:b6f2dcda3576efe8f9c23ba9a95b295a724beb70f88b46a4bea6d94fb69ac714
