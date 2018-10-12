#!/bin/bash
# progress bar function
prog() {
	local w=80 p=$1
	shift
	# create a string of spaces, then change them to dots
	printf -v dots "%*s" "$(($p * $w / 100))" ""
	dots=${dots// /.}
	# print those dots on a fixed-width space plus the percentage etc.
	printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*"
}
# test loop
for x in {1..100}; do
	prog "$x" still working...
	sleep 3 # do some work here
done
echo
