#!/bin/bash

HADOOP="$HOME/hadoop/hadoop"
JAR_DEST_PATH=../../target

cp $JAR_DEST_PATH/hadoop-hdfs-2.9.2-sources.jar $HADOOP/share/hadoop/hdfs/sources/hadoop-hdfs-2.9.2-sources.jar
cp $JAR_DEST_PATH/hadoop-hdfs-2.9.2-test-sources.jar $HADOOP/share/hadoop/hdfs/sources/hadoop-hdfs-2.9.2-test-sources.jar
cp $JAR_DEST_PATH/hadoop-hdfs-2.9.2-tests.jar $HADOOP/share/hadoop/hdfs/hadoop-hdfs-2.9.2-tests.jar
cp $JAR_DEST_PATH/hadoop-hdfs-2.9.2.jar $HADOOP/share/hadoop/hdfs/hadoop-hdfs-2.9.2.jar
cp $JAR_DEST_PATH/hadoop-hdfs-2.9.2.jar $HADOOP/share/hadoop/httpfs/tomcat/webapps/webhdfs/WEB-INF/lib/hadoop-hdfs-2.9.2.jar
