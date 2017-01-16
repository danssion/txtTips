#!/usr/bin/env bash
#获得集群服务器信息
#
#获得各个数据节点的磁盘信息
#getClusterInfo.sh -i volume
#
#

OPT=/opt/modules/
NODE='192.168.200.214 192.168.200.215 192.168.200.216 192.168.200.217 192.168.200.218'
ALLSERVICE='192.168.1.50 192.168.1.51 192.168.1.52 192.168.1.53 192.168.1.54 192.168.1.49 192.168.2.141 192.168.2.142 192.168.2.176 192.168.2.177 192.168.2.178 192.168.2.179'
USER='kafka'

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
	echo "need [-z : [zk]]  param."
fi

#获取参数
while getopts "i:c:other" arg #选项后面的冒号表示该选项需要参数
do
	case $arg in
		z)
			#echo "i's arg:$OPTARG" #参数存在$OPTARG中
			info=$OPTARG
			;;
		b)
			echo "b"
			;;
		c)
			info="bashbug"
			echo 'run env x="() { :;}; echo vulnerable"  bash -c "echo this is a test"'
			;;
		?) #当有不认识的选项的时候arg为?
			echo "unkonw argument"
			exit 1
			;;
	esac
done

timeStr=$(date +"%Y%m%d_%H" --date="now ")
case $info in
	'zk')
		#datanode server information
		for s in $NODE
		do
			ssh -t $USER@$s  "df -h > ~/${timeStr}_df"
			echo $s" : "
			scp $s:~/${timeStr}"_df" ./
			cat ./${timeStr}"_df"
			sleep 1
		done
		rm ./${timeStr}"_df"
		;;
	'b')
		echo 'b'
		;;
	'bashbug')
		for s in $ALLSERVICE
		do
			ssh -t $USER@$s  "env x='() { :;}; echo vulnerable'  bash -c 'echo this is a test'"
		done
		;;
	?)
		echo "unknow query info"
		;;
	
esac















