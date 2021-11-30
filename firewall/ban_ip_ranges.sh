#!/bin/bash

if [[ ! -f "$1" ]];
then
	echo "File not found"
	exit 1
fi

for ip_range in `cat $1`
do
	echo $ip_range
	iptables -A INPUT -s $ip_range -j DROP;
done
