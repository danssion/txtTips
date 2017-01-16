#!/usr/bin/env bash
#获得集群服务器信息
#
#获得各个数据节点的磁盘信息
#getClusterInfo.sh -i volume
#
#

HADOOP_HOME=/opt/modules/hadoop
JNODE='192.168.1.50 192.168.1.51 192.168.1.52'
DNODE='192.168.1.51 192.168.1.52 192.168.1.53 192.168.1.54 192.168.2.141 192.168.2.142 192.168.2.176 192.168.2.177 192.168.2.178 192.168.2.179 192.168.2.113 192.168.2.114 192.168.1.36 192.168.1.37'
OLDNODE='192.168.1.51 192.168.1.52 192.168.1.53 192.168.1.54 192.168.2.176 192.168.2.177 192.168.2.178 192.168.2.179 192.168.2.113 192.168.2.114'
#DNODE='192.168.2.178 192.168.2.179'
ALLSERVICE='192.168.1.50 192.168.1.51 192.168.1.52 192.168.1.53 192.168.1.54 192.168.1.49 192.168.2.141 192.168.2.142 192.168.2.176 192.168.2.177 192.168.2.178 192.168.2.179 192.168.2.113 192.168.2.114 192.168.1.36 192.168.1.37'
USER='hadoop'

#datanode server information
#for i in $DNODE
#do
#        ssh -t $USER@$i  "$HADOOP_HOME/sbin/yarn-daemon.sh stop nodemanager"
#done

#for arg in "$@"
#	do
#		echo $arg
#	done

#是否有参数传入
arg="$*"
if [ "$arg" == "" ]
	then
	echo "need [-i : [volume | info]] [-c : [bashbug | up260 | back200 | backJnode | backDnode | upCMD | runCMD]]  param."
fi

#获取参数
while getopts "i:c:other" arg #选项后面的冒号表示该选项需要参数
do
	case $arg in
		i)
			#echo "i's arg:$OPTARG" #参数存在$OPTARG中
			info=$OPTARG
			if [ "$info" == "volume" ]; then
				echo '各个服务的磁盘信息'
			fi
			if [ "$info" == "info" ]; then
				echo '各个服务器的信息'
			fi
			;;
		b)
			echo "b"
			;;
		c)
			info="bashbug"
			info=$OPTARG
			if [ "$info" == "bashbug" ]; then
				echo 'run env x="() { :;}; echo vulnerable"  bash -c "echo this is a test"'
			fi
			if [ "$info" == "up260" ]; then
				echo 'update hadoop link to version 2.6.0'
			fi
			if [ "$info" == "back" ]; then
				echo 'set hadoop version CDH460-hadoop-2.0.0'
			fi
			if [ "$info" == "backJnode" ]; then
				echo 'journalNode roll back'
			fi
			if [ "$info" == "backDnode" ]; then
				echo 'DataNode roll back'
			fi
			if [ "$info" == "upCMD" ]; then
				echo 'shutdown nodemanger in some server'
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
	'volume')
		#datanode server information
		for s in $DNODE
		do
			ssh -t $USER@$s  "df -h"
			read -p "Next [y=yes/n=no]? "
			if [ $REPLY != 'y' ];then
				break;
			fi
		done
		;;
	'info')
		for s in $ALLSERVICE
		do
			#ssh -t $USER@$s  "ls -l /lib64/libc.so.6"
			ssh -t $USER@$s  "ls -al /opt/data/hadoop/"
		done
		;;
	'bashbug')
		for s in $ALLSERVICE
		do
			ssh -t $USER@$s  "env x='() { :;}; echo vulnerable'  bash -c 'echo this is a test'"
		done
		;;
	'up260')
		for s in $ALLSERVICE
		do
			ssh -t $USER@$s  "rm /opt/modules/hadoop"
			ssh -t $USER@$s  "ln -s /opt/modules/hadoop-2.6.0 /opt/modules/hadoop"
			ssh -t $USER@$s  "ln -s /opt/modules/hadoop-2.6.0/etc/hadoop-ordinary /opt/modules/hadoop/etc/hadoop"
		done
		#ssh -t $USER@192.168.2.141  "rm /opt/modules/hadoop-2.6.0/etc/hadoop; ln -s /opt/modules/hadoop-2.6.0/etc/hadoop-141-142 /opt/modules/hadoop/etc/hadoop"
		#ssh -t $USER@192.168.2.142  "rm /opt/modules/hadoop-2.6.0/etc/hadoop; ln -s /opt/modules/hadoop-2.6.0/etc/hadoop-141-142 /opt/modules/hadoop/etc/hadoop"
		;;
	'back200')
		for s in $ALLSERVICE
		do
			echo "back 200" $s
		#	ssh -t $USER@$s  "rm /opt/modules/hadoop"
		#	ssh -t $USER@$s  "ln -s /opt/modules/hadoop-2.0.0-cdh4.6.0 /opt/modules/hadoop"
		done
		;;
	'backJnode')
		for s in $JNODE
		do
			echo 'backJnode' $s
			#ssh -t $USER@$s  "rm -rf /opt/data/hadoop/jn/namenode/260"
			#ssh -t $USER@$s  "mv  /opt/data/hadoop/jn/namenode/current /opt/data/hadoop/jn/namenode/260"
			#ssh -t $USER@$s  "mv  /opt/data/hadoop/jn/namenode/previous /opt/data/hadoop/jn/namenode/current"
		done
		;;
	'backDnode')
		for s in $DNODE
		do
			echo 'backDnode' $s
			#ssh -t $USER@$s  "/opt/modules/hadoop-2.0.0-cdh4.6.0/sbin/hadoop-daemon.sh start datanode -rollback"
		done
		;;
	'upCMD')
		for s in $OLDNODE
		do
			#ssh -t $USER@$s  "/opt/modules/hadoop/sbin/yarn-daemon.sh stop nodemanager"
			ssh -t $USER@$s  "/opt/modules/hadoop/sbin/yarn-daemon.sh start nodemanager"
		done
		;;
	'runCMD')
		for s in $DNODE
		#for s in $ALLSERVICE
		do
			#ssh -t $USER@$s  "head -n 50 /etc/hosts"
			echo $s
			ssh -t $USER@$s  "du -sh /opt/data/hadoop/data/current/BP-1711299655-114.112.70.50-1394612870481/* /data1/data/hadoop/data/current/BP-1711299655-114.112.70.50-1394612870481/* /data2/data/hadoop/data/current/BP-1711299655-114.112.70.50-1394612870481/* /data3/data/hadoop/data/current/BP-1711299655-114.112.70.50-1394612870481/*"
		done
		;;
	?)
		echo "unknow query info"
		;;
	
esac















