#!/bin/bash

HADOOP="$HOME/hadoop/hadoop"

ARGC=$# 
MAX_ARGS=1
BRANCH=$1

if [ $ARGC -ne $MAX_ARGS ]; then 
	echo -e "Usage: $0 <branch_name>\n">&2 
	exit 1
fi

# git fetch --all
git pull --all
git checkout $BRANCH