#!/bin/bash

ARGC=$#    # num args passed to script
MAX_ARGS=3 # <RF> <fileSize> <numFails>

HADOOP_BIN_PATH="$HOME/hadoop/hadoop-2.9.2.tar.gz"
DFSIO_PATH="$HOME/hadoop/hadoop-mapreduce-client-jobclient-2.9.2-tests.jar"

NR_FILES=10
FAIL_INITIAL_SLEEP=50
FAIL_SLEEP_STEP=46
READ_ITERATIONS=20
BAL_THRESHOLD=10

OUTPUT_DIR=""
EXTRACTOR_PATH="$HOME/extract.sh"

function doClusterSetup() {
	: '
		$1 = = Replication Factor and Min. Replication Factor
	'
	uniq $OAR_NODEFILE > $OUTPUT_DIR/node_file-$OAR_JOB_ID.txt # get node list of current job
	export PATH="$HOME/hadoop_g5k/scripts/:$PATH"

	echo "$(date) [IMPORTANT] Starting cluster setup (#A)"
	hg5k --create $OAR_FILE_NODES --version 2
	hg5k --bootstrap $HADOOP_BIN_PATH
	hg5k --initialize

	hg5k --changeconf hdfs-site.xml dfs.replication=$1
	hg5k --changeconf hdfs-site.xml dfs.namenode.replication.min=$1
	hg5k --changeconf hdfs-site.xml dfs.heartbeat.interval=1
	hg5k --changeconf hdfs-site.xml dfs.namenode.heartbeat.recheck-interval=10000
	hg5k --changeconf yarn-site.xml yarn.nodemanager.aux-services=mapreduce_shuffle
	hg5k --changeconf mapred-site.xml mapreduce.framework.name=yarn

	hg5k --start
	echo "$(date) [IMPORTANT] HDFS cluster is running (#A)"
}

function injectFails() {
	: '
		$1 = numFails to inject while writing files with TestDFSIO
	'
	for fail in $(seq 1 $1)
	do
		$HOME/kill_dn.sh $(( $FAIL_INITIAL_SLEEP + (($fail - 1) * $FAIL_SLEEP_STEP) )) $(tail -n $fail $OUTPUT_DIR/node_file-$OAR_JOB_ID.txt | head -n 1) & # <sleep_time> <host>
	done
}

function writeFiles() {
	: '
		$1 = fileSize
		$2 = numFails
		$3 = TestDFSIO (write) log filepath
		$4 = HDFS status (no balancer) log filepath
	'
	injectFails $2
	echo "$(date) [IMPORTANT] Starting TestDFSIO write operation (#B)"
	start_time=`date +%s`
	hg5k --jarjob $DFSIO_PATH TestDFSIO "-write -nrFiles $NR_FILES -fileSize $1 -resFile $3"
	end_time=`date +%s`

	echo "Write time: `expr $end_time - $start_time`" >> $4
	hg5k --state dfs >> $4
	echo "$(date) [IMPORTANT] TestDFSIO files were written (#B)"
}

function readFiles() {
	: '
		$1 = fileSize
		$2 = TestDFSIO (read) log filepath
		$3 = Exec. times (read) log filepath
	'
	echo "$(date) [IMPORTANT] Starting TestDFSIO read operation (#C)"
	for it in $(seq 1 $READ_ITERATIONS)
	do
		start_time=`date +%s`
		hg5k --jarjob $DFSIO_PATH TestDFSIO "-read -nrFiles $NR_FILES -fileSize $1 -resFile $2"
		end_time=`date +%s`
		echo "`expr $end_time - $start_time`" >> $3
		# /tmp/hadoop/bin/hadoop jar $DFSIO_PATH TestDFSIO -clean # if the files were cleaned up here, it will be necessary to call 'writeFiles' function before read them again
		sleep 15
	done
	echo "$(date) [IMPORTANT] TestDFSIO files were read (#C)"
}

function runBalancer() {
	: '
		$1 = HDFSBalancer log filepath
		$2 = HDFS status (with balancer) log filepath
	'
	echo "$(date) [IMPORTANT] Starting cluster balancing (#D)"
	start_time=`date +%s`
	/tmp/hadoop/bin/hdfs balancer -threshold $BAL_THRESHOLD > $1
	end_time=`date +%s`

	echo "Balancer time: `expr $end_time - $start_time`" >> $2
	hg5k --state dfs >> $2
	echo "$(date) [IMPORTANT] The cluster is balanced (#D)"
}

function RunTests() {
	doClusterSetup $1 # <RF>
	writeFiles $2 $3 "$OUTPUT_DIR/TestDFSIO_resultsWrite.log" "$OUTPUT_DIR/status-no-balancer.txt"      # <fileSize> <numFails> <logs_filepath>...
	readFiles $2 "$OUTPUT_DIR/TestDFSIO_resultsRead_noBal.log" "$OUTPUT_DIR/times-read-no-balancer.txt" # <fileSize> <logs_filepath>...
	runBalancer "$OUTPUT_DIR/HDFSBalancer.log" "$OUTPUT_DIR/status-balancer.txt"                        # <logs_filepath>...
	readFiles $2 "$OUTPUT_DIR/TestDFSIO_resultsRead_withBal.log" "$OUTPUT_DIR/times-read-balancer.txt"  # <fileSize> <numFails> <logs_filepath>...
	mv OAR.$OAR_JOB_ID.std* $OUTPUT_DIR/
	$EXTRACTOR_PATH $1 $2 $3 $OUTPUT_DIR # extract results <RF> <fileSize> <numFails> <outputDir>
}

if [ $ARGC -ne $MAX_ARGS ]; then 
	echo -e "Usage: $0 <RP> <fileSize> <numFails>\n">&2 # check parameters
else
	OUTPUT_DIR="$1-`echo $2 | grep -o -E '[0-9]+'`-$3" # (RF-fileSize-numFails)
	mkdir -p $OUTPUT_DIR  # create outputDir if not exists
	RunTests $1 $2 $3     # $1 = RF e MIN_RF, $2 = fileSize, $3 = numFails
fi
