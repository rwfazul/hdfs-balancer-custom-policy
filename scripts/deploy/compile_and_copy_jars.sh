#!/bin/bash
	 
HDFS_PATH=~/Desktop/hadoop-rel-release-2.9.2/hadoop-hdfs-project/hadoop-hdfs
JAR_DEST_PATH=../../target

(cd $HDFS_PATH && mvn install -DskipTests && mvn package -Pdist -DskipTests -Dtar -Dmaven.javadoc.skip=true)
cp $HDFS_PATH/target/*.jar $JAR_DEST_PATH