#!/usr/bin/env bash
#start hadoop
HADOOP_HOME=/opt/modules/hadoop
TARGET_DIR=/opt/modules/hadoop/etc
LSERVICES='114.112.82.141'
SERVICES='192.168.2.141'
LUSER='duanxiang'
USER='hadoop'

#是否有参数传入
arg="$*"
if [ "$arg" == "" ]
	then
	echo "need [-l : [upcode | info]] [-c : [hadoopDir | runCMD]]  param."
fi

#获取参数
while getopts "l:c:other" arg #选项后面的冒号表示该选项需要参数
do
	case $arg in
		l)
			#echo "l's arg:$OPTARG" #参数存在$OPTARG中
			info=$OPTARG
			if [ "$info" == "upcode" ]; then
				echo '本地svn代码发送到线上'
			fi
			if [ "$info" == "info" ]; then
				echo '各个服务器的信息'
			fi
			;;
		c)
			info=$OPTARG
			if [ "$info" == "hadoopDir" ]; then
				echo '运行clientMapReduce需要的目录'
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

case $info in
	'upcode')
		for s in $LSERVICES
		do
			ssh -t $LUSER@$s  "sudo mkdir -p /opt/baofeng-data/windforce-shell/mapreduce/jar/ /opt/baofeng-data/windforce-shell/mapreduce/everyhour-mr-result/"
			ssh -t $LUSER@$s  "sudo mkdir -p /data1/data/logdata /opt/baofeng-data/windforce-shell/log/timelog"
			ssh -t $LUSER@$s  "sudo chown duanxiang:hadoop -R /opt/baofeng-data/windforce-shell /opt/baofeng-data/"
			ssh -t $LUSER@$s  "sudo chown hadoop:hadoop -R /data1/data/logdata /opt/baofeng-data/windforce-shell/mapreduce/everyhour-mr-result/ /opt/baofeng-data/windforce-shell/log"
			scp /home/danssion/web/windforce/svn/windforce/branches/fetchLog/* $LUSER@$s:/opt/baofeng-data/windforce-shell/
			scp /home/danssion/web/windforce/svn/windforce/branches/hadoop/python/* $LUSER@$s:/opt/baofeng-data/windforce-shell/mapreduce/
			scp /home/danssion/web/hadoop-2.0.0-cdh4.6.0/share/hadoop/mine/mapper.jar $LUSER@$s:/opt/baofeng-data/windforce-shell/mapreduce/jar/mapper.jar
			echo $s" : "
		done
		;;
	'info')
		for s in $SERVICES
		do
			ssh -t $USER@$s  "ls -l /lib64/libc.so.6"
		done
		;;
	'hadoopDir')
		for s in $SERVICES
		do
			ssh -t $USER@$s  "mkdir -p /data1/data/logdata/all/hy_click_info /data1/data/logdata/all/hy_count_info /data1/data/logdata/all/hy_consu_info /data1/data/logdata/hy_click_info /data1/data/logdata/hy_count_info /data1/data/logdata/hy_consu_info"
			ssh -t $USER@$s  "chmod -R 777 /data1/data/logdata/all /data1/data/logdata/hy_click_info /data1/data/logdata/hy_count_info /data1/data/logdata/hy_consu_info /opt/baofeng-data/windforce-shell/log"
			ssh -t $USER@$s  "mkdir -p /home/hadoop/log /opt/baofeng-data/windforce-shell/mapreduce/everyhour-mr-result/click /opt/baofeng-data/windforce-shell/mapreduce/everyhour-mr-result/count /opt/baofeng-data/windforce-shell/mapreduce/everyhour-mr-result/consu" 
			scp -r /opt/modules/apache-hive-0.13.1-bin $USER@$s:/opt/modules/
			scp -r /opt/modules/mysql-5.6 $USER@$s:/opt/modules/
			scp -r /opt/modules/hadoop/share/hadoop/common/lib/JSAP-2.1.jar $USER@$s:/opt/modules/hadoop/share/hadoop/common/lib
			ssh -t $USER@$s  "cd /opt/modules;ln -s apache-hive-0.13.1-bin hive;ln -s mysql-5.6 mysql"
		done
		;;
	'runCMD')
		for s in $DNODE
		do
		#	ssh -t $USER@$s  "ls -al /data1/data/hadoop/temp/nm-local-dir/usercache/hadoop"
			scp /opt/modules/hadoop-20150309-2.6.0.tar.gz $s:~/
			ssh -t $USER@$s  "cd ~ ; tar zxvf hadoop-20150309-2.6.0.tar.gz -C /opt/modules/" 
		done
		;;
	?)
		echo "unknow query info"
		;;
	
esac













