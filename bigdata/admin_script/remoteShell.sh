#!/usr/bin/env bash
#
#
#
#assistantShell.sh -i volume
#
#
SOFTWARE_PATH=/usr/local/soft
HADOOP_HOME=$SOFTWARE_PATH/hadoop
#DNODE='192.168.2.178 192.168.2.179'
SERVER='namenode datanode1 datanode2'
USER='root'


#是否有参数传入
arg="$*"
if [ "$arg" == "" ]
	then
	echo "need [-i : [ visit | zk | process ]] [-c/s : [ hadoop | zk | spark | kafka | initkafka ]]  param."
fi

#获取参数
while getopts "i:c:s:other" arg #选项后面的冒号表示该选项需要参数
do
	case $arg in
		i)
			#echo "i's arg:$OPTARG" #参数存在$OPTARG中
			info=$OPTARG
			if [ "$info" == "visit" ]; then
				echo '各个服务器的访问总数信息'
			fi
			info=$OPTARG
			if [ "$info" == "process" ]; then
				echo 'get processlist '
			fi
			info=$OPTARG
			if [ "$info" == "zk" ]; then
			info='infoZK'
				echo 'get zookeeper info'
			fi
			;;
		c)
			info=$OPTARG
			if [ "$info" == "hadoop" ]; then
        info="startHDP"
				echo 'start hadoop,journalnode and yarn'
			fi
			if [ "$info" == "zk" ]; then
        info="startZK"
				echo 'start zookeeper'
			fi
			if [ "$info" == "kafka" ]; then
        info="startKFK"
				echo 'start kafka'
			fi
			if [ "$info" == "initkafka" ]; then
        info="initKFK"
				echo 'init kafka conf'
			fi
			if [ "$info" == "spark" ]; then
        info="startSP"
				echo 'start spark'
			fi
			if [ "$info" == "runCMD" ]; then
				echo 'run cmd in every server'
			fi
			;;
    s)
			info=$OPTARG
			if [ "$info" == "hadoop" ]; then
        info="stopHDP"
				echo 'stop hadoop and yarn'
			fi
			if [ "$info" == "journalnode" ]; then
        info="stopJN"
				echo 'stop journalnode'
			fi
			if [ "$info" == "zk" ]; then
        info="stopZK"
				echo 'stop zookeeper'
			fi
			if [ "$info" == "kafka" ]; then
        info="stopKFK"
				echo 'stop kafka'
			fi
			if [ "$info" == "spark" ]; then
        info="stopSP"
				echo 'stop spark'
			fi
			if [ "$info" == "runCMD" ]; then
				echo 'run cmd in every server'
			fi
			;;
		?) #当有不认识的选项的时候arg为?
			echo "unkonw argument"
			exit 1
			;;
	esac
done

timeStr=$(date +"%Y%m%d_%H" --date="now ")
case $info in
	'startHDP')
    /usr/local/soft/hadoop/sbin/start-dfs.sh
    /usr/local/soft/hadoop/sbin/start-yarn.sh
    ssh -t $USER@datanode2 $HADOOP_HOME"/sbin/mr-jobhistory-daemon.sh start historyserver"
		for s in $SERVER
    do
       ssh -t $USER@$s  $HADOOP_HOME"/sbin/hadoop-daemon.sh start journalnode"
    done

		;;
	'stopHDP')
    /usr/local/soft/hadoop/sbin/stop-dfs.sh
    /usr/local/soft/hadoop/sbin/stop-yarn.sh
    ssh -t $USER@datanode2 $HADOOP_HOME"/sbin/mr-jobhistory-daemon.sh stop historyserver"
		for s in $SERVER
		do
			ssh -t $USER@$s  $HADOOP_HOME"/sbin/hadoop-daemon.sh stop journalnode"
		done
		;;
	'process')
		for s in $SERVER
		do
			ssh -t $USER@$s  "jps"
		done
		;;
	'startZK')
		for s in $SERVER
		do
			ssh -t $USER@$s  "/usr/local/soft/zookeeper/bin/zkServer.sh start"
		done
		;;
 'stopZK')
    for s in $SERVER
    do
            ssh -t $USER@$s  "/usr/local/soft/zookeeper/bin/zkServer.sh stop"
    done
    ;;
 'infoZK')
    for s in $SERVER
    do
            ssh -t $USER@$s  "/usr/local/soft/zookeeper/bin/zkServer.sh status"
    done
    ;;
 'initKFK')
    for s in $SERVER
    do
       ssh -t $USER@$s  "rm ${SOFTWARE_PATH}/kafka/config/server.properties && cp ${SOFTWARE_PATH}/kafka/config/${s}.properties ${SOFTWARE_PATH}/kafka/config/server.properties "
    done
    ;;
 'startKFK')
    for s in $SERVER
    do
       ssh  $USER@$s  "${SOFTWARE_PATH}/kafka/bin/kafka-server-start.sh -daemon ${SOFTWARE_PATH}/kafka/config/server.properties "
    done
    ;;
 'stopKFK')
    for s in $SERVER
    do
       ssh $USER@$s  "${SOFTWARE_PATH}/kafka/bin/kafka-server-stop.sh -daemon ${SOFTWARE_PATH}/kafka/config/server.properties "
    done
    ;;
	'startSP')
     $SOFTWARE_PATH"/spark/sbin/start-all.sh"
		;;
	'stopSP')
     $SOFTWARE_PATH"/spark/sbin/stop-all.sh"
		;;
	'runCMD')
		GETSV=$HYSV
	#	GETSV=$KJSV
		for s in $GETSV
		do
			#ssh -t $USER@$s  "cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c;cat /proc/meminfo | grep 'MemTotal';ps aux | grep nginx"
			ssh -t $USER@$s  "sudo ls /opt/baofeng-data/houyi_xieshang/revs/rev_152/"
		done
		;;
	?)
		echo "unknow query info"
		;;
	
esac















