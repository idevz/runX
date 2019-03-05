#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 17:06:39 2019/03/01
# Description:       building docker iamges from runX
# run          ./run.sh
#
# Environment variables that control this script:
#
### END ###

set -ex

BASE_DIR=${BASE_DIR:-"$(readlink -f "$(dirname "$0")")"}
DOCKER_ACCOUNT=${DK_ACT:-"zhoujing"}
BUILDING_RUN_PATH="${BASE_DIR}/docker-build-run-path"

PROJS=(
    "lua 5.1.5"
    "openresty 1.15.6.1rc0"
    "golang 1.12"
    "php 7.3.2"
)

[ $(uname) = 'Linux' ] && x() {
    sudo env "PATH=$PATH" "$@"
}

check_param() {
    [ -z "${1}" ] && echo "empty param." && exit 1
    echo "check_param pass."
}

prepare_deploy_scripts() {
    check_param ${1}
    local proj_name=${1}
    local des_path="${BUILDING_RUN_PATH}/${proj_name}"
    local src_path="${BASE_DIR}/${proj_name}"
    if [ -d "${des_path}" ]; then
        x rm -rf "${des_path}"
    fi
    [ ! -d "${des_path}" ] && x mkdir -p "${des_path}"
    x cp -rf "${src_path}/init" "${des_path}/init"
}

clean_deploy_scripts() {
    check_param ${1}
    local proj_name=${1}
    x rm -rf "${BUILDING_RUN_PATH}/${proj_name}"
}

build_and_push_docker_images() {
    check_param ${1}
    check_param ${2}
    local proj_name=${1}
    local version=${2}
    local docker_image_tag="${DOCKER_ACCOUNT}/idevz-runx-${proj_name}:${version}"
    x docker build --network=host \
        --build-arg BUILD_ENV="docker" \
        --build-arg RBV="${version}" \
        --build-arg PROJ="${proj_name}" -t "${docker_image_tag}" .
    x docker push "${docker_image_tag}"
}

init() {
    for proj_conf in "${PROJS[@]}"; do
        local proj=$(echo ${proj_conf} | awk '{print $1}')
        local version=$(echo ${proj_conf} | awk '{print $2}')
        [ -f "${proj}/init" ] || continue
        (
            prepare_deploy_scripts "${proj}"
            echo "start build and push ${proj} image."
            build_and_push_docker_images "${proj}" "${version}"
            echo "${proj} is done."
            clean_deploy_scripts "${proj}"
        )
    done
}
init
