#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 2018/03/12
# Description:       Set up Golang development environment.
# ./init.sh          Set up using $(pwd) as BASE_DIR, down which has go source and binaries.
#
# using `echo $HMSG to testing the setup.`
### END ###

set -e

# Installing the required packages for the kernel compilation process
# yum install wget gcc make ncurses-devel openssl-devel elfutils-libelf-devel bc perl -y

# Kernel download
mkdir -p /usr/src/kernels/
cd /usr/src/kernels/
# wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.19.4.tar.gz
# tar xvf linux-4.19.4.tar.gz
# rm -f linux-4.19.4.tar.gz
cd linux-4.19.4

# Config file creation based on last one
cp $(ls -1t /boot/config-* | head -1) .config

# Start menu selection for options. For now, just choose Save
make menuconfig

# Launching the kernel upgrade process (it may take several hours)
make -j $(nproc) && make modules_install && make install

# After installation, restart the server to see if there is a new kernel
reboot
