#!/usr/bin/env bash
[ $SHELL = "zsh" ] && plugins=(golang z)

export_go_path

alias dk_go_build='CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo'
