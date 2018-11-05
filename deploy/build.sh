#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 2018/03/12
# Description:   A framework for create a language development environment using parallels vm.
# prlctlc exec golang 'sudo -Hiu z set_up'
#
# Environment variables that control init:
# BI: the base parallels image which you're using to setup, I build one from a nake centos7
#     and also add the most common tools with my daily using.
# PR: your parallels root which set to store your paramllels vms(pvms).
# CAS: set if both clone and set up the pvm at one time, default is "yes" do both at once.
# USI: set if using static ip, or dhcp. default is "yes" to using static ip.
### END ###

set -e

BASE_DIR="$(readlink -f "$(dirname "$0")")"

PROJS=(
	lua
)

base='runx:'
for proj in "${PROJS[@]}"; do
	[ -f "${proj}/Dockerfile.builder" ] || continue
	(
		set -x
		docker build -t "${base}${proj}-builder" -f "${proj}/Dockerfile.builder" "${proj}"
		docker run --rm "${base}${proj}-builder" tar cC "/usr/local/lua-5.1.5" . | xz -z9 >"${proj}/lua.tar.xz"
	)
done
