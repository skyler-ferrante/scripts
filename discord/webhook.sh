#!/bin/bash

# Simple script that could be useful for finding and analyzing discord/webhook C2's
#     Requires gdb (gcore) and net-tools (netstat)

# If no arguments given,
#     Find all processes with HTTPS traffic (might be webhooks)

# If PID given as argument,
#     Dump memory of PID using gcore
#     Try to find Discord API token
#
#     https://discord.com/developers/docs/reference#authentication-example-bot-token-authorization-header
#     Example Bot Token Authorization Header:
#         Authorization: Bot MTk4NjIyNDgzNDcxOTI1MjQ4.Cl2FMQ.ZnCjm1XVW7vRze4b7Cq4se7kKWs

if [[ ! -z $1 ]];
then
        # Dump memory of process with PID given
        gcore $1
        
        # Could be replaced to find a different token type
        # This will only work if the token is stored continuously in memory
        strings core.$1 | grep '[-a-zA-Z0-9]\{11,30\}\.[-a-zA-Z0-9]\{3,12\}\.[-a-zA-Z0-9]\{11,30\}\|Authorization'
else
        # Get all TCP traffic, search for HTTPS, get PID, get information on PID
        netstat -tap \
                | grep https \
                | grep ESTABLISHED \
                | awk '{print $NF}' \
                | awk -F/ '{print $1}' \
                | xargs ps -f
fi