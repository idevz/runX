#!/bin/sh

### BEGIN ###
# Author: idevz
# Since: 2018/03/12
# Description:       Setting enviroment variables for golang pvm.
### END ###

export GOROOT=${GOROOT_FINAL}
export GOPATH=${GO_WORK_SPACES}
export PATH=${GOROOT_FINAL}/bin:${GIT}/go/bin:${MCODE}/z/idevz-go/bin:$PATH

alias ggr="go run"
alias ggt="go test -covermode=count -coverprofile=covprofile && go tool cover -html=covprofile -o coverage.html"