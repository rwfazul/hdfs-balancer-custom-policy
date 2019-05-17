#!/bin/bash

HADOOP_FOLDER=$HOME/hadoop/

mkdir -p $HADOOP_FOLDER
wget http://ftp.unicamp.br/pub/apache/hadoop/common/hadoop-2.9.2/hadoop-2.9.2.tar.gz -P $HADOOP_FOLDER
(cd $HADOOP_FOLDER && tar -xvzf $HADOOP_FOLDER/hadoop-2.9.2.tar.gz)
mv $HADOOP_FOLDER/hadoop-2.9.2/ $HADOOP_FOLDER/hadoop-custom-2.9.2/
cp $HADOOP_FOLDER/hadoop-custom-2.9.2/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.9.2-tests.jar $HADOOP_FOLDER/
easy_install --user execo
cd ~
wget https://github.com/mliroz/hadoop_g5k/archive/master.zip
unzip master.zip
rm master.zip
mv hadoop_g5k-master/ hadoop_g5k/ 
cd hadoop_g5k
python setup.py install --user
