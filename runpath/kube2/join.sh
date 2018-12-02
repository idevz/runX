#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 2018/03/12
# Description:       AUTO Generate by runX.
# ./join.sh          Make a node join to a K8S cluster.
### END ###
sudo   kubeadm join 10.211.55.150:6443 --token 0vbzvi.llipmkwbjqeqpxmh --discovery-token-ca-cert-hash sha256:510feefbacefa3fbe9e7ce471935eec8e4b1824e385893e30a3d754cfbd1007f
