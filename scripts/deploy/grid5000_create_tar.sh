#!/bin/bash

HADOOP="$HOME/hadoop"

cd $HADOOP
rm -f hadoop-2.9.2.tar.gz
# tar -zcvf hadoop-custom-2.9.2.tar.gz hadoop-custom-2.9.2
tar cf - hadoop-2.9.2 | gzip > hadoop-2.9.2.tar.gz