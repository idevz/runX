#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 2018/03/12
# Description:   git hook pre-commit for runX.
#
# Environment variables that control init:
### END ###

set -e

cd /Users/idevz/Documents/Parallels/runX
git add .
git commit -m "update runX"
git push >/Users/idevz/Documents/Parallels/runX/ffffff 2>&1
cd -
