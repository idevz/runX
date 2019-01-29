#!/usr/bin/env bash
[ $SHELL = "zsh" ] && plugins=(golang z)

export_go_path

alias dk_go_build='CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo'

get_assembly() {
	# https://colobu.com/2018/12/29/get-assembly-output-for-go-programs/
	go tool compile -N -l -S once.go
}
