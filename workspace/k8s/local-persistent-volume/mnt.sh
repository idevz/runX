#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 18:38:13 2019/07/16
# Description:       mount disk for pv
# mnt          simple usage.
#
# Environment variables that control this script:
#
### END ###

set -e
BASE_DIR=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))

for vol in vol1 vol2 vol3; do
    sudo mkdir -p /mnt/idevz/disks/$vol
    sudo mount -t tmpfs $vol /mnt/idevz/disks/$vol
done
