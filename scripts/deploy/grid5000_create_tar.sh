#!/bin/bash

HADOOP="$HOME/hadoop"

cd $HADOOP
rm -f hadoop-custom-2.9.2.tar.gz
tar -zcvf hadoop-custom-2.9.2.tar.gz hadoop-custom-2.9.2
