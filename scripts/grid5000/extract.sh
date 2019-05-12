OUTPUT_FILE="$4/final_results.txt"

echo "* Configs: { R.F. and Min. R.F.=$1, fileSize=$2, numFails=$3, outputDir=$4 } *" >> $OUTPUT_FILE

echo '*** TestDFSIO write ***' >> $OUTPUT_FILE
cat $4/TestDFSIO_resultsWrite.log | grep -E -o 'Test exec time (sec): [0-9.]+' >> $OUTPUT_FILE
cat $4/TestDFSIO_resultsWrite.log | grep -E -o 'Throughput (mb/sec): [0-9.]+' >> $OUTPUT_FILE
cat $4/TestDFSIO_resultsWrite.log | grep -E -o 'Average IO rate (mb/sec): [0-9.]+' >> $OUTPUT_FILE
# cat $4/TestDFSIO_resultsWrite.log | grep -E -o 'IO rate std deviation: [0-9.]+' >> $OUTPUT_FILE
head $4/status-no-balancer.txt | grep 'Write time: ' >> $OUTPUT_FILE

echo '*** HDFS Balancer ***' >> $OUTPUT_FILE
cat $4/HDFSBalancer.log | grep -E -o "Balancing took .+" >> $OUTPUT_FILE
head $4/status-balancer.txt | grep 'Balancer time: ' >> $OUTPUT_FILE

echo '*** HDFS status ***' >> $OUTPUT_FILE

echo '-> [W/O BAL] HDFS status no balancer' >> $OUTPUT_FILE
echo '--> Bytes:' >> $OUTPUT_FILE
echo 'Total HDFS usage:' >> $OUTPUT_FILE
cat $4/status-no-balancer.txt  | grep -P -o '(?<=^DFS Used: )[0-9]+' | head -n 1 >> $OUTPUT_FILE
cat $4/status-no-balancer.txt | grep 'Live datanodes' >> $OUTPUT_FILE
cat $4/status-no-balancer.txt  | grep -P -o '(?<=^DFS Used: )[0-9]+' | head -n -$3 | tail -n +2 >> $OUTPUT_FILE
cat $4/status-no-balancer.txt | grep 'Dead datanodes' >> $OUTPUT_FILE
cat $4/status-no-balancer.txt  | grep -P -o '(?<=^DFS Used: )[0-9]+' | tail -n $3 >> $OUTPUT_FILE
echo '--> GB:' >> $OUTPUT_FILE
echo 'Total HDFS usage:' >> $OUTPUT_FILE
cat $4/status-no-balancer.txt  | grep -P -o '(?<=^DFS Used: ).+' | grep -P -o '(?<=\()[\d.]+' | head -n 1 >> $OUTPUT_FILE
cat $4/status-no-balancer.txt | grep 'Live datanodes' >> $OUTPUT_FILE
cat $4/status-no-balancer.txt  | grep -P -o '(?<=^DFS Used: ).+' | grep -P -o '(?<=\()[\d.]+' | head -n -$3 | tail -n +2 >> $OUTPUT_FILE
cat $4/status-no-balancer.txt | grep 'Dead datanodes' >> $OUTPUT_FILE
cat $4/status-no-balancer.txt  | grep -P -o '(?<=^DFS Used: ).+' | grep -P -o '(?<=\()[\d.]+' | tail -n $3 >> $OUTPUT_FILE

echo '-> [W/ BAL] HDFS status with balancer' >> $OUTPUT_FILE
echo '--> Bytes:' >> $OUTPUT_FILE
echo 'Total HDFS usage:' >> $OUTPUT_FILE
cat $4/status-balancer.txt  | grep -P -o '(?<=^DFS Used: )[0-9]+' | head -n 1 >> $OUTPUT_FILE
cat $4/status-balancer.txt | grep 'Live datanodes' >> $OUTPUT_FILE
cat $4/status-balancer.txt  | grep -P -o '(?<=^DFS Used: )[0-9]+' | head -n -$3 | tail -n +2 >> $OUTPUT_FILE
cat $4/status-balancer.txt | grep 'Dead datanodes' >> $OUTPUT_FILE
cat $4/status-balancer.txt  | grep -P -o '(?<=^DFS Used: )[0-9]+' | tail -n $3 >> $OUTPUT_FILE
echo '--> GB:' >> $OUTPUT_FILE
echo 'Total HDFS usage:' >> $OUTPUT_FILE
cat $4/status-balancer.txt  | grep -P -o '(?<=^DFS Used: ).+' | grep -P -o '(?<=\()[\d.]+' | head -n 1 >> $OUTPUT_FILE
cat $4/status-balancer.txt | grep 'Live datanodes' >> $OUTPUT_FILE
cat $4/status-balancer.txt  | grep -P -o '(?<=^DFS Used: ).+' | grep -P -o '(?<=\()[\d.]+' | head -n -$3 | tail -n +2 >> $OUTPUT_FILE
cat $4/status-balancer.txt | grep 'Dead datanodes' >> $OUTPUT_FILE
cat $4/status-balancer.txt  | grep -P -o '(?<=^DFS Used: ).+' | grep -P -o '(?<=\()[\d.]+' | tail -n $3 >> $OUTPUT_FILE

echo '*** TestDFSIO read ***' >> $OUTPUT_FILE

echo '-> [W/O BAL] Test exec time (sec) no balancer:' >> $OUTPUT_FILE
cat $4/TestDFSIO_resultsRead_noBal.log | grep -E -o 'Test exec time sec: [0-9.]+' | grep -E -o '[0-9.]+' >> $OUTPUT_FILE
echo '-> [W/ BAL] Test exec time (sec) with balancer:' >> $OUTPUT_FILE
cat $4/TestDFSIO_resultsRead_withBal.log | grep -E -o 'Test exec time sec: [0-9.]+' | grep -E -o '[0-9.]+' >> $OUTPUT_FILE

echo '-> [W/O BAL] Throughput (mb/sec) no balancer:' >> $OUTPUT_FILE
cat $4/TestDFSIO_resultsRead_noBal.log | grep -E -o 'Throughput mb/sec: [0-9.]+' | grep -E -o '[0-9.]+' >> $OUTPUT_FILE
echo '-> [W/ BAL] Throughput (mb/sec) with balancer:' >> $OUTPUT_FILE
cat $4/TestDFSIO_resultsRead_withBal.log | grep -E -o 'Throughput mb/sec: [0-9.]+' | grep -E -o '[0-9.]+' >> $OUTPUT_FILE

echo '-> [W/O BAL] Average IO rate (mb/sec) no balancer:' >> $OUTPUT_FILE
cat $4/TestDFSIO_resultsRead_noBal.log | grep -E -o 'Average IO rate mb/sec: [0-9.]+' | grep -E -o '[0-9.]+' >> $OUTPUT_FILE
echo '-> [W/ BAL] Average IO rate (mb/sec) with balancer:' >> $OUTPUT_FILE
cat $4/TestDFSIO_resultsRead_withBal.log | grep -E -o 'Average IO rate mb/sec: [0-9.]+' | grep -E -o '[0-9.]+' >> $OUTPUT_FILE

# echo '-> [W/O BAL] Read times (sec) no balancer:' >> $OUTPUT_FILE
# cat $4/times-read-no-balancer.txt >> $OUTPUT_FILE
# echo '-> [W/ BAL] Read times (sec) with balancer:' >> $OUTPUT_FILE
# cat $4/times-read-balancer.txt >> $OUTPUT_FILE

# echo '-> [W/O BAL] IO rate std deviation no balancer:' >> $OUTPUT_FILE
# cat $4/TestDFSIO_resultsRead_noBal.log | grep -E -o 'IO rate std deviation: [0-9.]+' | grep -E -o '[0-9.]+' >> $OUTPUT_FILE
# echo '-> [W/ BAL] IO rate std deviation with balancer:' >> $OUTPUT_FILE
# cat $4/TestDFSIO_resultsRead_withBal.log | grep -E -o 'IO rate std deviation: [0-9.]+' | grep -E -o '[0-9.]+' >> $OUTPUT_FILE
