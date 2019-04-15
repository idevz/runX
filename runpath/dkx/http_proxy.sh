#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 17:28:41 2019/04/15
# Description:       enable or disable http_proxy enviranment values
# http_proxy          ./http_proxy.sh on | off
#
# Environment variables that control this script:
#
### END ###

# set -ex
# BASE_DIR=${BASE_DIR:-"$(readlink -f "$(dirname "$0")")"}

http_proxy_on() {
    local proxy="http://10.211.55.3:8118"
    # proxy="http://127.0.0.1:8118"
    export ALL_PROXY=${proxy}
    export HTTP_PROXY=${proxy}
    export HTTPS_PROXY=${proxy}
    export all_proxy=${proxy}
    export http_proxy=${proxy}
    export https_proxy=${proxy}
    export NO_PROXY="localhost,127.0.0.1,::1,10.211.55.0/16,10.96.0.0/12,10.244.0.0/16"
}

http_proxy_off() {
    unset ALL_PROXY HTTP_PROXY HTTPS_PROXY all_proxy http_proxy https_proxy NO_PROXY
}

# curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/

case "${1}" in
on)
    http_proxy_on
    ;;
off) http_proxy_off ;;
esac
