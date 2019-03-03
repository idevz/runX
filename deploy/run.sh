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
IMAGE_VERSION=${IMV:-"1.0.0"}
DOCKER_ACCOUNT=${DK_ACT:-"zhoujing"}
BUILDING_RUN_PATH="${BASE_DIR}/docker-build-run-path"

PROJS=(
    lua
    openresty
    golang
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
    local proj_name=${1}
    local docker_image_tag="${DOCKER_ACCOUNT}/idevz-runx-${proj_name}:${IMAGE_VERSION}"
    x docker build --network=host \
        --build-arg BUILD_ENV="docker" \
        --build-arg PROJ="${proj_name}" -t "${docker_image_tag}" .
    x docker push "${docker_image_tag}"
}

for proj in "${PROJS[@]}"; do
    [ -f "${proj}/init" ] || continue
    (
        prepare_deploy_scripts "${proj}"
        echo "start build and push ${proj} image."
        build_and_push_docker_images "${proj}"
        echo "${proj} is done."
        clean_deploy_scripts "${proj}"
    )
done
