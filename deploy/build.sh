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

cd "$(readlink -f "$(dirname "$BASH_SOURCE")")"
echo $BASH_SOURCE
echo "$(readlink -f "$(dirname "$BASH_SOURCE")")"

if [ ${#versions[@]} -eq 0 ]; then
	versions=(*/)
fi
versions=("${versions[@]%/}")

echo "${#versions[@]}"
echo "${versions[@]}"
exit
base='busybox:'
for version in "${versions[@]}"; do
	[ -f "$version/Dockerfile.builder" ] || continue
	(
		set -x
		docker build -t "$base$version-builder" -f "$version/Dockerfile.builder" "$version"
		docker run --rm "$base$version-builder" tar cC rootfs . | xz -z9 >"$version/busybox.tar.xz"
		docker build -t "$base$version-test" "$version"
		docker run --rm "$base$version-test" sh -xec 'true'

		# detect whether the current host _can_ ping
		# (QEMU user-mode networking does not route ping traffic)
		shouldPing=
		if docker run --rm "$base$version-builder" ping -c 1 google.com &>/dev/null; then
			shouldPing=1
		fi

		if [ -n "$shouldPing" ]; then
			if ! docker run --rm "$base$version-test" ping -c 1 google.com; then
				sleep 1
				docker run --rm "$base$version-test" ping -c 1 google.com
			fi
		else
			docker run --rm "$base$version-test" nslookup google.com
		fi

		docker images "$base$version-test"
	)
done
