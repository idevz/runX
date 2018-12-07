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
BASE_DIR=${BASE_DIR:-"$(readlink -f "$(dirname "$0")")"}

INGERSS_HOST=${IH:-"dashboard-ingress.idevz.com"}

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
DNS.1 = idevz.org
DNS.2 = dashboard-ingress.idevz.org
CNF
	)
	echo "${openssl_cnf}" | sudo tee "${ssl_dir}/openssl.cnf"
	sudo openssl genrsa -out ingress-key.pem 2048
	sudo openssl req -new -key ingress-key.pem -out ingress.csr -subj "/CN=${INGERSS_HOST}" -config openssl.cnf
	sudo openssl x509 -req -in ingress.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out ingress.pem -days 365 -extensions v3_req -extfile openssl.cnf
	# kubectl create secret tls ingress-secret --key ingress-key.pem --cert ingress.pem -n kube-system
	kubectl create secret tls idevz-org-secret --key ingress-key.pem --cert ingress.pem -n idevz-k8s-test
	cd -
}

clean_ca_keys() {
	rm ${BASE_DIR}/ca*
	rm ${BASE_DIR}/ing*
}

ingress_secret_x() {
	clean_ca_keys
	cd ${BASE_DIR}
	# create CA
	openssl genrsa -out ca.key 2048
	openssl req -x509 -new -nodes -key ca.key -days 3560 -out ca.crt -subj "/CN=ingress-ca"
	local openssl_conf_file="${BASE_DIR}/openssl.cnf"
	# genetater ingress ssl
	# ssl key
	openssl genrsa -out ingress.key 2048
	# ssl src
	openssl req -new -key ingress.key -out ingress.csr -subj "/CN=nginx-svc-tls" -config ${openssl_conf_file}
	# ssl CA
	openssl x509 -req -in ingress.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out ingress.crt -days 3650 -extensions v3_req -extfile ${openssl_conf_file}
	# kubectl create secret tls idevz-org-secret --key "${BASE_DIR}/ingress.key" --cert "${BASE_DIR}/ingress.crt" -n idevz-k8s-test
	kubectl create secret tls ingress-secret --key "${BASE_DIR}/ingress.key" --cert "${BASE_DIR}/ingress.crt" -n kube-system
	cd -
}
ingress_secret_x
# kubectl create -f ../dashboard-ingress-tls.yaml
