#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 17:39:30 2018/12/06
# Description:       create a ca server key
# gen-key          ./gen-key.sh
#
# Environment variables that control this script:
#
### END ###

# https://github.com/denji/golang-tls

[ -z $(command -v openssl) ] && echo "Didn't find the 'openssl' command." && exit 1
# Key considerations for algorithm "RSA" ≥ 2048-bit
openssl genrsa -out server.key 2048

# Key considerations for algorithm "ECDSA" ≥ secp384r1
# List ECDSA the supported curves (openssl ecparam -list_curves)
openssl ecparam -genkey -name secp384r1 -out server.key
openssl req -new -x509 -sha256 -key server.key -out server.crt -days 3650
