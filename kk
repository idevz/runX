#!/bin/sh

while true; do
	echo .
	sleep .1
done &
sleep 10 # or do something else here
kill $!
trap 'kill $!' SIGTERM
echo done
