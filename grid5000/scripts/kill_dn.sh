#!/bin/bash

sleep $1
# oarsh $2 kill -9 "$(jps | grep DataNode | cut -f 1 -d ' ' | sort | head -n 1)" # the double quotes cause the shell to execute command substitution (locally) in-place
# alternative: single quotes or oarsh $2 "jps | grep DataNode | cut -f1 -d' ' | sort | head -n 1 | xargs kill -9"
oarsh $2 'kill -9 $(jps | grep DataNode | cut -f 1 -d " " | sort | head -n 1)'
echo "$(date) [IMPORTANT] DN in host $2 killed after waiting for $1 seconds"
