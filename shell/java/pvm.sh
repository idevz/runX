#!/usr/bin/env bash

### BEGIN ###
# Author: idevz
# Since: 07:41:09 2019/01/12
# Description:       java pvm funcs
# pvm          source pvm.sh
#
# Environment variables that control this script:
#
### END ###

# when JVM occupy highly CPU what's doing on it.
check_pid_cpu_doing() {
	local pid=$1

	if test -z $pid; then
		echo "pid can not be null!"
		exit
	else
		echo "checking pid($pid)"
	fi

	if test -z "$(jps -l | cut -d '' -f 1 | grep $pid)"; then
		echo "process of $pid is not exists"
		exit
	fi

	local lineNum=$2
	if test -z $lineNum; then
		$lineNum=10
	fi

	jstack $pid >>"$pid".bak

	ps -mp $pid -o THREAD,tid,time | sort -k2r | awk '{if ($1 !="USER" && $2 != "0.0" && $8 !="-") print $8;}' | xargs printf "%x\n" >>"$pid".tmp

	tidArray="$(cat $pid.tmp)"

	for tid in $tidArray; do
		echo "******************************************************************* ThreadId=$tid **************************************************************************"
		cat "$pid".bak | grep $tid -A $lineNum
	done

	rm -rf $pid.bak
	rm -rf $pid.tmp
}
