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
WEBHDSV='hd-client hd-nn1 hd-nn2 hd-node1 hd-node2 hd-node3 ad-log1 ad-log2 ad-log3 log-gath log-kafka place-log1 place-log2 place-log3 place-gath'
RDSV='redis1 redis2 redis3 proxyA proxyB'
TESTSV='hd-client'
USER='duanxiang'


#是否有参数传入
arg="$*"
if [ "$arg" == "" ]
	then
	echo "need [-i : [volume | info | visit | checkLink | access ]]
             [-c : [ addMac | addhosts | upbash | runCMD | addAccount | addSSPManager |  mcmd | uphost ]]  param."
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
			if [ "$info" == "mcmd" ]; then
				echo '多服务器命令操作'
			fi
			if [ "$info" == "addhosts" ]; then
				echo '更新各个服务器hosts'
			fi
			if [ "$info" == "addMac" ]; then
				echo '添加一个本地Mac电脑无密码ssh登陆'
			fi
			if [ "$info" == "addSSPManager" ]; then
				echo '添加一个ssp manger duanxiang服务器无密码ssh登陆'
			fi
			if [ "$info" == "upbash" ]; then
				echo 'update .bashrc'
			fi
			if [ "$info" == "uphost" ]; then
				echo 'update hostname and hosts'
			fi
			if [ "$info" == "runCMD" ]; then
				echo 'run cmd in every server'
			fi
			if [ "$info" == "addAccount" ]; then
				echo '添加duanxiang登录账户,并填写初始密码'
			fi
			if [ "$info" == "addHDCli" ]; then
				echo '为Hadoop client 服务添加其他服务器登录ssh-key'
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
		GETSV=$WEBHDSV
	#	GETSV=$TESTSV
	#	GETSV=$HADOOPSERVICES
	#	GETSV=$KJSV
		for s in $GETSV
		do
			
			#ssh -t $USER@$s  "sudo sed -i '20,\$d' /etc/hosts "
			#ssh -t $USER@$s  "sudo ps aux | grep php | wc -l "
			#ssh -t $USER@$s  "cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c;cat /proc/meminfo | grep 'MemTotal';ps aux | grep nginx"
			#ssh -t $USER@$s  "df -h"
			#ssh -t $USER@$s  "cat /etc/redhat-release"
			#ssh -t duanxiang@$s  "grep 'CPU' /proc/cpuinfo; free -m"
			#ssh -t duanxiang@$s  "free -g"
			#ssh -t $USER@$s  "ls -alh /opt/modules/nginx/conf/vhost"
			ssh -t $USER@$s  "hostname"
			#ssh -t $USER@$s  "source /etc/profile;php --ri curl"
			#ssh -t $USER@$s  "source /etc/profile;php --ri curl;php --ri redis;php --ri apc;php --ri protobuf"
			#ssh -t $USER@$s  "ls -alh /opt/data/logs | grep '20150630'"
		done
		;;
	'access')
		GETSV="consu2 consu3 consu4 consu5 consu6 consu7 consu33 consu34 consu35 consu38 consu92 consu93 consu94 consu95 consu96"
		for s in $GETSV
		do
			ssh -t $USER@$s  "sudo head -n 2067500 /opt/data/logs/houyi_access_20150823.log | tail -n 780500 | grep 'Consultation/index.php' | grep -E 'extend\=[0-9]{7}[^1]' | grep -v 'adtype=2' |grep -v '&source\=[1-9]' | grep -v 'dvc=' | grep -v 'adtype=3' | wc -l"
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
	'addhosts')
		echo "input a string add in hosts:"
		read ip ipn
		if [ -z $ip ];then
			echo "need ip and host name"
			exit;
		elif [ "$ipn" = ' ' ];then
			echo "need ip and host name"
			exit;
		elif [ -z $ipn ];then
			echo "need ip and host name"
			exit;
		fi
		IPPTN="^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$"
		if [[ "$ip" =~ $IPPTN ]];then
			echo ""	
		else
			echo "ip format is invalid!"
        		exit;
		fi
		GETSV=$WEBHDSV
		for s in $GETSV
		do
			ssh -t duanxiang@$s  "sudo echo ${ip}' '${ipn} >> /etc/hosts"
		done
		;;
	'mcmd')
		GETSV=$RDSV
		for s in $GETSV
		do
      			#scp -r /opt/modules/redis3.0.7 $s:/opt/modules/
			#ssh -t duanxiang@$s  "cd /opt/modules/ && ln -s /opt/modules/redis3.0.7 redis && sudo echo 'export REDISHOME=/opt/modules/redis' >> /etc/profile && sudo echo 'export PATH=$GOPATH/bin:$PATH:${JAVA_HOME}/bin:${REDISHOME}/bin' >> /etc/profile"
			ssh -t duanxiang@$s  "sudo mkdir -p /data/codis-data && sudo chown duanxiang:dev /data/codis-data"
		done
		;;
	'addAccount')
		echo "input a server name [name or ip]?"
		read -t 10 str
		if [ $str == '' ];then
			echo "need hosts string"
			break;
		fi
    ssh -t root@$str "echo 'User_Alias DEV = duanxiang'  >> /etc/sudoers;
    echo 'DEV       ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers;
    groupadd dev;useradd -g dev duanxiang;passwd duanxiang"
		;;
	'addMac')
		read -p "input a server name [name or ip]?"
		if [ $REPLY == '' ];then
			break;
		fi
		ssh -t $USER@$REPLY "mkdir .ssh; touch .ssh/authorized_keys;echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDA96NQAyJxYmpSv/DsilXK9rZMnu7AxlCc+XozxWhZ9sX8yz9h/umlGpwjPYNKeUnPOvx8Ldz5FgE7l2foJFWMLdyk9+IsUzp3OlUF7uSmrdxyhoDY/APXECAriy/Dqw0qhXowHAitY7+N1Sra6qPk42qbQOFyhTKg6SDV2xx52FzgfDZ4ZcMSLqEVldjgCVpBBpTQ7yGjy4zWUeAFfXxmzZDiyZVnIm5xQ9U0uvZyC3h1oya5Axj93hUvoXgQkotaNuF5q49CeMQ5O7+n9PqI8CaPoLkMWM+unW3FbBn7sRh2tqgeGara+DjB1qEIeFsoydWEx99R0gnYv6EOPaBn danssion@danssionMacPro.lan' >> .ssh/authorized_keys ; chmod 700 -R .ssh/"
		;;
	'addHDCli!!')
		read -p "input a server name [name or ip]?"
		if [ $REPLY == '' ];then
			break;
		fi
		ssh -t $USER@$REPLY "sudo groupadd hadoop &&  sudo /sbin/useradd -g hadoop hadoop ;sudo usermod -G hadoop hadoop ;sudo usermod -G dev hadoop ; sudo sudo chmod 0777 /home/hadoop/ ;sudo mkdir /home/hadoop/.ssh ; sudo chown -R root:root /home/hadoop/.ssh/ ; sudo rm /home/hadoop/.ssh/authorized_keys ; sudo touch /home/hadoop/.ssh/authorized_keys  ; sudo chmod 777 -R /home/hadoop/.ssh ; sudo echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtPa8oN4lLw/Cyups+O/Jv+zVMCJTdDxHIHHVo1XGsFLbcZXrHxZdQAujzfplvpOtWuRKqBNCTvud4Bchf6kHtNbbTjOpkJqzgQh5uDS6ptdcvR1p7ir+HM9JGCuiAC65AsIA2Jq1PRzzfKMAp6wXfxmk4tu5Uf2mjdN5TY90fl0Ebculqu5vjoFk9HXIktU0wwLgCHNi9vF1f4MJ96i/7rIcqDf1BA4LPRNedaxSXf8/mV2dTkP95MrK4uY7cUoVrNALmUFkbl37r2W+IT+rVX/BhtTsUxrYy0cX3/qOF8+Da3CzAYH4L02dBsZzW5MPgaD8zzdg6SXkl8vBAzRkH hadoop@hd-client' >> /home/hadoop/.ssh/authorized_keys ; sudo chown -R hadoop:hadoop /home/hadoop/.ssh/ ;sudo chmod 700 -R /home/hadoop/.ssh/; sudo chmod 0700 /home/hadoop/"
		;;
	'addSSPManager')
		read -p "input a server name [name or ip]?"
		if [ $REPLY == '' ];then
			break;
		fi
		ssh -t $USER@$REPLY "mkdir .ssh; touch .ssh/authorized_keys;echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAvX4mvVK6bQsnWOgEZ7F9GnxkYzx3deNggOY9Dq4aVQw6zXC4pC+yLnTiCsVOdg2OVp/JMIiD6/DohklFwFB3vWumIPt/vatrMZm7Thg/s4ir+3O6BlmMtkmvTCGGrvWSZlPjj6mCFqrVB8Ai0gy78MgbFv88lowPFFYVJwLMze0fZJqrtXNU/wcWkWH8BNkRRXU3EKBrjdTGL/D5KfDTwbSxi5/Q/xN8AkAx8Git2dxL9B0BwaICIodPAdK37stdma/YhvNzmkjWL8M/JIOEx3I3Co/VZS3BOg7CEsjmwcyXTCoE5PHDk0rLzWCFxunyWCF74I5Vv/pIxP8Q5s9EZw== duanxiang@ssp1' >> .ssh/authorized_keys ; chmod 700 -R .ssh/"
		;;
	'uphost')
		read -p "input a server name [name or ip]?"
		if [ $REPLY == '' ];then
			break;
		fi
		SRNAME=$REPLY
		read -p "input a new hostname?"
		if [ $REPLY == '' ];then
			break;
		fi
		#echo 'hn=`hostname` && sudo sed -i "s/${hn}/'${REPLY}'/g" /etc/sysconfig/network'
		ssh -t $USER@$SRNAME 'sudo echo "HOSTNAME='${REPLY}'" > /etc/sysconfig/network'
		ssh -t $USER@$SRNAME 'hn=`hostname` && sudo sed -i "s/${hn}/'${REPLY}'/g" /etc/sysconfig/network'
		ssh -t $USER@$SRNAME 'hn=`hostname` && sudo sed -i "s/$hn/'${REPLY}'/g" /etc/hosts && sudo hostname '$REPLY
		;;
	'upCMD')
		for s in $OLDNODE
		do
			#ssh -t $USER@$s  "/opt/modules/hadoop/sbin/yarn-daemon.sh stop nodemanager"
			ssh -t $USER@$s  "/opt/modules/hadoop/sbin/yarn-daemon.sh start nodemanager"
		done
		;;
	'runCMD')
		GETSV=$WEBHDSV
		#GETSV=$TESTSV
		for s in $GETSV
		do
			#ssh -t $USER@$s  "cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c;cat /proc/meminfo | grep 'MemTotal';ps aux | grep nginx"
			ssh -t $USER@$s  "sudo mkdir /opt/modules/ && cd /opt/modules && sudo ln -s /opt/cloudera/parcels/CDH/ cloudera && sudo  ln -s /run/cloudera-scm-agent/process/ process"
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















