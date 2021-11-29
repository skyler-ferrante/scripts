#!/bin/bash
echo "This is not supposed to be run"
exit 1

# Get all ip:port combos, where port<49152 (not client port)
# Assumes tcpdump -n > log.pcap
cat log.pcap | awk '{print $3 "\n" $5}' | tr -d ':' | awk -F\. '$NF<49152' | sort | uniq -c | sort -n

# Netstat cuts off the PID/Program name column
# This gets pids from netstat, then runs ps -f pids
# In this case we grep for http, to get the full process information of all processes communicating over http/https 
netstat -tap | grep "ESTABLISHED" | grep "http" | awk -F/ '{print $(NF-1)}' | awk '{print $NF}' | xargs ps -f