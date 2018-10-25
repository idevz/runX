#!/usr/bin/env bash

HOSTNAME=$(hostname)
PRLCTL_HOME=${PRLCTL_HOME:-"/media/psf/runX"}

# default set to using debug version openresty
dbg_or
