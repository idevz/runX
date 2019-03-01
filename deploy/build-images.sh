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
BASE_DIR=${BASE_DIR:-"$(readlink -f "$(dirname "$0")")"}
RUNX_PATH="/runX/${PROJ}"
BUILD_ENV="${BUILD_ENV}"

set_up() {
	HOSTNAME="${1}"
	PRLCTL_HOME=${PRLCTL_HOME:-"/media/psf/runX"}
	BASE_DIR=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))

	xnotic() {
		STATUS=1
		[ ! -z "${2}" ] && STATUS="${2}"
		echo
		echo "${1}" && echo && exit "${STATUS}"
	}

	ynotic() {
		echo
		echo "${1}"
	}

	[ $(uname) = 'Linux' ] && x() {
		"$@"
	}

	# create a profile for each host such as envriment variable setting
	create_profile() {
		[ -z "${1}" ] && echo "empty profile content." && exit 1
		PROFILE_FILE="/etc/profile.d/idevz_prlctl_${HOSTNAME}.sh"
		[ ! -z "${2}" ] &&
			PROFILE_FILE="/etc/profile.d/idevz_prlctl_${2}.sh"
		[ -f "${PROFILE_FILE}" ] && rm "${PROFILE_FILE}"
		echo "${1}" | tee -a "${PROFILE_FILE}"
		#  sh -c "echo zzz >> /etc/profile"
		chmod +x "${PROFILE_FILE}"
	}

	install_yum_pkgs() {
		x yum install -y strace dtrace weighttp \
			nc tree git patch patchelf nmon perf ntpdate \
			tcpdump psmisc zsh gcc gcc-c++ vim rlwrap make \
			nmap-ncat.x86_64 net-tools telnet \
			man man-pages \
			bind-utils # for nslookup, host OR dig
	}
	install_yum_pkgs
}

set_up "${PROJ}"

BASE_DIR="${RUNX_PATH}" \
	BUILD_ENV="${BUILD_ENV}" \
	HOME="/home/z" && . "${RUNX_PATH}/init"

init
clean_srcs
