#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 09:41:45 2019/08/08
# Description:       gen kubectl keys
# run          ./run.sh
#
# Environment variables that control this script:
#
### END ###

set -e
# 最短平快的远程操作 kubetcl 的方法还是直接 scp，直接把秘钥拿过来。
# 更安全的做法是 kubetcl 启动 proxy 吗？
prepare_key_jsons() {
  cat >ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "87600h"
    },
    "profiles": {
      "kubernetes": {
         "expiry": "87600h",
         "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ]
      }
    }
  }
}
EOF

  cat >ca-csr.json <<EOF
{
    "CN": "kubernetes",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "Beijing",
            "ST": "Beijing",
              "O": "k8s",
            "OU": "System"
        }
    ]
}
EOF

  cat >admin-csr.json <<EOF
{
  "CN": "admin",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "BeiJing",
      "ST": "BeiJing",
      "O": "system:masters",
      "OU": "System"
    }
  ]
}
EOF
}

gen_ca() {
  cfssl gencert -initca ca-csr.json | cfssljson -bare ca -
}
gen_admin_ca() {
  cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes admin-csr.json | cfssljson -bare admin
}

gen_kubeconf() {
  #进入证书目录
  # cd /opt/kubernetes/kubectl/ssl

  #生成kubectl配置文件
  kubectl config set-cluster ww-k8s --server=https://10.77.9.40:6443 --certificate-authority=ca.pem
  # --insecure-skip-tls-verify=true

  #设置用户项中ww-k8s用户证书认证字段
  kubectl config set-credentials ww-k8s --certificate-authority=ca.pem --client-key=admin-key.pem --client-certificate=admin.pem

  #设置默认上下文
  kubectl config set-context ww-k8s --cluster=ww-k8s --user=ww-k8s

  #设置当前环境的ww-k8s
  kubectl config use-context ww-k8s
}

opt=${1}
shift

case $opt in
kjson)
  prepare_key_jsons
  ;;
ca)
  gen_ca
  ;;
adminca)
  gen_admin_ca
  ;;
kubec)
  gen_kubeconf
  ;;
clean)
  rm -f ./ca*
  rm -f ./admin*
  ;;
all)
  prepare_key_jsons
  gen_ca
  gen_admin_ca
  gen_kubeconf
  ;;
*)
  echo "ok"
  ;;
esac
