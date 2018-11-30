#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 2018/03/12
# Description:       AUTO Generate by runX.
# ./join.sh          Make a node join to a K8S cluster.
### END ###
kubeadm join 10.211.55.150:6443 --token 98nlk3.2ikmygy0159ug1wv --discovery-token-ca-cert-hash sha256:eadc100c16c48062c938b29c6744dad151c2b350b9278bce502c3d5c429ad11d
