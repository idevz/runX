#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 15:34:08 2018/12/05
# Description:       generater ingress-secret for kub-dashboard
# gen          ./gen.sh
#
# Environment variables that control this script:
# IH: ingress host
### END ###
set -e

INGERSS_HOST=${IH:-"dashboard-ingress.idevz"}
ingress_secret() {
	local ssl_dir="/etc/kubernetes/ssl"
	[ -d ${ssl_dir} ] && sudo rm -rf ${ssl_dir}
	sudo mkdir ${ssl_dir}
	cd ${ssl_dir}

	sudo openssl genrsa -out ca-key.pem 2048
	sudo openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=kube-ca"
	local openssl_cnf=$(
		cat <<CNF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS = ${INGERSS_HOST}
IP.1 = 10.254.0.1
IP.2 = 192.168.23.128
CNF
	)
	echo "${openssl_cnf}" | sudo tee "${ssl_dir}/openssl.cnf"
	sudo openssl genrsa -out ingress-key.pem 2048
	sudo openssl req -new -key ingress-key.pem -out ingress.csr -subj "/CN=${INGERSS_HOST}" -config openssl.cnf
	sudo openssl x509 -req -in ingress.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out ingress.pem -days 365 -extensions v3_req -extfile openssl.cnf
	# kubectl create secret tls ingress-secret --key ingress-key.pem --cert ingress.pem -n kube-system
	kubectl create secret tls default-server-secret --key ingress-key.pem --cert ingress.pem -n nginx-ingress
	cd -
}
ingress_secret
# kubectl create -f ../dashboard-ingress-tls.yaml
