#!/usr/bin/env bash
#
#
#
#assistantShell.sh -i volume
#
#

HADOOP_HOME=/opt/modules/hadoop
DNODE='114.112.70.51 114.112.70.52 114.112.70.53 114.112.70.54 114.112.82.141 114.112.82.142 114.112.82.176 114.112.82.177 114.112.82.178 114.112.82.179 114.112.82.113 114.112.82.114 114.112.70.36 114.112.70.37'
#DNODE='192.168.2.178 192.168.2.179'
HADOOPSERVICES='114.112.70.50 114.112.70.51 114.112.70.52 114.112.70.53 114.112.70.54 114.112.70.49 114.112.82.141 114.112.82.142 114.112.82.176 114.112.82.177 114.112.82.178 114.112.82.179 114.112.82.113 114.112.82.114 114.112.70.36 114.112.70.37'
KJSV='kejie_ngx118 kejie_ngx119 kejie_ngx120 kejie_ngx121 kejie_ngx122 kejie203 kejie215 kejie216 kejie220 kejie224 kejie231'
WEBHYSV='webhy99 webhy100 webhy101 webhy102 webhy103 webhy104 webhy105 webhy106 webhy219 webhy6 webhy7'
HYSV='consu2 consu3 consu4 consu5 consu6 consu7 consu33 consu34 consu35 consu38 consu92 consu93 consu94 consu95 consu96 consu116 consu56 consu57 consu58 consu126 consu97 consu98 consu99'
HYIP='192.168.1.2 192.168.1.3 192.168.1.4 192.168.1.5 192.168.1.6 192.168.1.7 192.168.1.33 192.168.1.34 192.168.1.35 192.168.1.38 192.168.1.92 192.168.1.93 192.168.1.94 192.168.1.95 192.168.1.96 192.168.1.116 192.168.1.56 192.168.1.57 192.168.1.58 192.168.1.126 192.168.1.97 192.168.1.98 192.168.1.99'
TESTSV='webhy219 webhy104 webhy105'
USER='duanxiang'


#是否有参数传入
arg="$*"
if [ "$arg" == "" ]
	then
	echo "need [-i : [volume | info | visit | error | lastvisit | lasterror | checkLink | access ]] [-c : [ addMine | upbash | runCMD | nginxZC | nginxGF ]]  param."
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
			if [ "$info" == "visit" ]; then
				echo '各个服务器的访问总数信息'
			fi
			if [ "$info" == "lastvisit" ]; then
				echo '各个服务器的昨天的访问总数信息'
			fi
			if [ "$info" == "error" ]; then
				echo '各个服务器的错误记录数'
			fi
			if [ "$info" == "lasterror" ]; then
				echo '各个服务器的昨天的错误记录数'
			fi
			if [ "$info" == "checkLink" ]; then
				echo '服务线上代码link信息'
			fi
			if [ "$info" == "access" ]; then
				echo '服务线特定时间段的访问统计'
			fi
			;;
		b)
			echo "b"
			;;
		c)
			info=$OPTARG
			if [ "$info" == "addmine" ]; then
				echo '添加一个无密码ssh登陆'
			fi
			if [ "$info" == "upbash" ]; then
				echo 'update .bashrc'
			fi
			if [ "$info" == "runCMD" ]; then
				echo 'run cmd in every server'
			fi
			if [ "$info" == "nginxZC" ]; then
				echo '切换70网段nginx为正常配置'
			fi
			if [ "$info" == "nginxGF" ]; then
				echo '切换70网段nginx为高峰配置,屏蔽角标，中播'
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
		GETSV=$WEBHYSV
		for s in $GETSV
		do
			ssh -t $USER@$s  "df -h"
			read -p "Next [y=yes/n=no]? "
			if [ $REPLY != 'y' ];then
				break;
			fi
		done
		;;
	'info')
		GETSV=$HYSV
	#	GETSV=$HYIP
	#	GETSV=$WEBHYSV
	#	GETSV=$HADOOPSERVICES
	#	GETSV=$KJSV
		for s in $GETSV
		do
			ssh -t $USER@$s  "sudo ps aux | grep php | wc -l "
			#ssh -t $USER@$s  "ls -alh /opt/modules/php/var/log"
			#ssh -t $USER@$s  "cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c;cat /proc/meminfo | grep 'MemTotal';ps aux | grep nginx"
			#ssh -t $USER@$s  "df -h"
			#ssh -t $USER@$s  "cat /etc/redhat-release"
			#ssh -t duanxiang@$s  "grep 'CPU' /proc/cpuinfo; free -m"
			#ssh -t duanxiang@$s  "free -g"
			#ssh -t $USER@$s  "ls -alh /opt/modules/nginx/conf/vhost"
			#ssh -t $USER@$s  "ls -alh /opt/data/logs/houyi_error.log"
			#ssh -t $USER@$s  "source /etc/profile;php --ri curl"
			#ssh -t $USER@$s  "source /etc/profile;php --ri curl;php --ri redis;php --ri apc;php --ri protobuf"
			#ssh -t $USER@$s  "ls -alh /opt/data/logs | grep '20150630'"
		done
		;;
	'access')
		GETSV="consu56 consu57 consu58 consu126"
		for s in $GETSV
		do
			#ssh -t $USER@$s  "sudo head -n 1655000 /opt/data/logs/houyi_access_20150823.log | grep 'Consultation/index.php' | grep -E 'extend\=[0-9]{7}[^1]' | grep 'adtype=1' |grep -v '&source\=[1-9]' | grep -v 'dvc=' | wc -l"
			#ssh -t $USER@$s  "sudo head -n 1655000 /opt/data/logs/houyi_access_20150823.log | grep 'Consultation/index.php' | grep -E 'extend\=[0-9]{7}[^1]' | grep -v 'adtype=2' |grep -v '&source\=[1-9]' | grep -v 'dvc=' | grep -v 'adtype=3' | wc -l"
			ssh -t $USER@$s  "sudo head -n 2657000 /opt/data/logs/houyi_access_20150823.log | tail -n 1005000 | grep 'Consultation/index.php' | grep -E 'extend\=[0-9]{7}[^1]' | grep -v 'adtype=2' |grep -v '&source\=[1-9]' | grep -v 'dvc=' | grep -v 'adtype=3' | wc -l"
			#ssh -t $USER@$s  "sudo tail -n 2155000 /opt/data/logs/houyi_access_20150822.log | grep 'Consultation/index.php' | grep -E 'extend\=[0-9]{7}[^1]' | grep -v 'adtype=2' |grep -v '&source\=[1-9]' | grep -v 'dvc=' | grep -v 'adtype=3' | wc -l"
		done
		GETSV="consu2 consu3 consu4 consu5 consu6 consu7 consu33 consu34 consu35 consu38 consu92 consu93 consu94 consu95 consu96"
		for s in $GETSV
		do
			#ssh -t $USER@$s  "sudo head -n 1525000 /opt/data/logs/houyi_access_20150823.log | grep 'Consultation/index.php' | grep -E 'extend\=[0-9]{7}[^1]' | grep 'adtype=1' |grep -v '&source\=[1-9]' | grep -v 'dvc=' | wc -l"
			#ssh -t $USER@$s  "sudo head -n 1525000 /opt/data/logs/houyi_access_20150823.log | grep 'Consultation/index.php' | grep -E 'extend\=[0-9]{7}[^1]' | grep -v 'adtype=2' |grep -v '&source\=[1-9]' | grep -v 'dvc=' | grep -v 'adtype=3' | wc -l"
			ssh -t $USER@$s  "sudo head -n 2067500 /opt/data/logs/houyi_access_20150823.log | tail -n 780500 | grep 'Consultation/index.php' | grep -E 'extend\=[0-9]{7}[^1]' | grep -v 'adtype=2' |grep -v '&source\=[1-9]' | grep -v 'dvc=' | grep -v 'adtype=3' | wc -l"
			#ssh -t $USER@$s  "sudo tail -n 1680000 /opt/data/logs/houyi_access_20150822.log | grep 'Consultation/index.php' | grep -E 'extend\=[0-9]{7}[^1]' | grep -v 'adtype=2' |grep -v '&source\=[1-9]' | grep -v 'dvc=' | grep -v 'adtype=3' | wc -l"
		done
		;;
	'visit')
		GETSV=$HYSV
		GETSV=$WEBHYSV
		for s in $GETSV
		do
			#ssh -t duanxiang@$s  "cd /opt/data/logs && ls | grep 'error' | grep '20150713' | xargs wc -l"
			ssh -t duanxiang@$s  "cd /opt/data/logs && ls | grep 'access' | grep '201507' | xargs wc -l"
		done
		;;
	'lastvisit')
		yesterday=$(date +"%Y%m%d" --date='now -13 day')
		GETSV=$HYSV
		for s in $GETSV
		do
			ssh -t duanxiang@$s  "cd /opt/data/logs && ls | grep 'access' | grep $yesterday | xargs wc -l"
		done
		GETSV=$WEBHYSV
		for s in $GETSV
		do
			ssh -t duanxiang@$s  "cd /opt/data/logs && ls | grep 'access' | grep $yesterday | xargs wc -l"
		done
		;;
	'error')
		GETSV=$HYSV
		#GETSV=$WEBHYSV
		#GETSV=$TESTSV
		for s in $GETSV
		do
			ssh -t duanxiang@$s  "cd /opt/data/logs && ls | grep 'houyi_error' | grep '20150726' | xargs wc -l"
		done
		;;
	'lasterror')
		yesterday=$(date +"%Y%m%d" --date='now -13 day')
		GETSV=$WEBHYSV
		for s in $GETSV
		do
			ssh -t duanxiang@$s  "cd /opt/data/logs && ls | grep 'houyi_error' | grep $yesterday | xargs wc -l"
		done
		GETSV=$HYSV
		for s in $GETSV
		do
			ssh -t duanxiang@$s  "cd /opt/data/logs && ls | grep 'houyi_error' | grep $yesterday | xargs wc -l"
		done
		;;
	'checkLink')
		GETSV=$HYSV
		GETSV=$WEBHYSV
		#GETSV=$TESTSV
		for s in $GETSV
		do
			ssh -t duanxiang@$s  "ls -alh /opt/baofeng-data/houyi_xieshang;ls  /opt/baofeng-data/houyi_xieshang/cur/"
			#ssh -t duanxiang@$s  "sudo mkdir /opt/baofeng-data/houyi_xieshang/old ;sudo mv /opt/baofeng-data/houyi_xieshang/xieshang1* /opt/baofeng-data/houyi_xieshang/old/"
		done
		GETSV=$WEBHYSV
		GETSV=''
		for s in $GETSV
		do
			ssh -t duanxiang@$s  "ls  /opt/baofeng-data/houyi_xieshang/cur/;ls -alh /opt/baofeng-data/houyi_xieshang"
			break;
		done
		;;
	'addMine')
		read -p "input a server name [name or ip]?"
		if [ $REPLY == '' ];then
			break;
		fi
		ssh -t $USER@$REPLY "mkdir .ssh; touch .ssh/authorized_keys;echo ssh-rsa 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCyAc8CFf8zkvibEhPnkynci5PXphy1NpSC79e212nqHU1o+svcZV4wSQrhW1pp5AiQ7jWKeQ/oHyJcGHAsSiyFPoOKWVikVJH1odXOAi1CzacSXdqkzgshvEKkU8TP7Io2L6m7n2qW/umNjEo3gr+3/PBFb2cRgqFYigTTawLZnY1i8FDhOK9i9Xrq9LyxFiNfKHYyIuKqfhTS8YCczxIWuiYIQAptvWWzdkSxhDcnrOm8wuW293OsGR3JnH1r22yvlivCtw6RlHw4uql3oFCu3VMXXhSZo+Uosu7PmDasLqjDFcrz3h2B1MZiGtERuiVzIAm1J++aAtmUsTUV8pj/ danssion@dx-BaoFeng' >> .ssh/authorized_keys ; chmod 700 -R .ssh/"
		;;
	'upCMD')
		for s in $OLDNODE
		do
			#ssh -t $USER@$s  "/opt/modules/hadoop/sbin/yarn-daemon.sh stop nodemanager"
			ssh -t $USER@$s  "/opt/modules/hadoop/sbin/yarn-daemon.sh start nodemanager"
		done
		;;
	'runCMD')
		GETSV=$HYSV
	#	GETSV=$WEBHYSV
	#	GETSV=$HADOOPSERVICES
	#	GETSV=$KJSV
		for s in $GETSV
		do
			#ssh -t $USER@$s  "cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c;cat /proc/meminfo | grep 'MemTotal';ps aux | grep nginx"
			ssh -t $USER@$s  "sudo ls /opt/baofeng-data/houyi_xieshang/revs/rev_152/"
		done
		;;
	'nginxZC')
		#HYIP='192.168.1.2'
		GETSV=$HYIP
		for s in $GETSV
		do
			ssh -t $USER@$s  "sudo cp /opt/modules/nginx/conf/vhost/xieshang.conf.zc /opt/modules/nginx/conf/vhost/xieshang.conf; sudo /opt/modules/nginx/sbin/nginx -s reload"
		done
		;;
	'nginxGF')
		GETSV=$HYIP
		for s in $GETSV
		do
			ssh -t $USER@$s  "sudo cp /opt/modules/nginx/conf/vhost/xieshang.conf.gaofeng /opt/modules/nginx/conf/vhost/xieshang.conf; sudo /opt/modules/nginx/sbin/nginx -s reload"
		done
		;;
	'upbash')
		read -p "input a server name [name or ip]?"
		if [ $REPLY == '' ];then
			break;
		fi
		ssh -t $USER@$REPLY "echo 'export TERM=xterm-256color' >> .bashrc; echo export 'PATH=$PATH:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/sbin:/usr/local/bin:/usr/local/sbin' >> .bashrc;"
		;;
	?)
		echo "unknow query info"
		;;
	
esac















