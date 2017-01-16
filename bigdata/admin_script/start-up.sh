#!/usr/bin/env bash
#start hadoop
HADOOP_HOME=/opt/modules/hadoop
ZOOKEEPER_HOME=/opt/modules/zookeeper
ZKSERVICE='192.168.1.50 192.168.1.51 192.168.1.52'
JNODE='192.168.1.50 192.168.1.51 192.168.1.52'
DNODE='192.168.1.53 192.168.1.52 192.168.1.51 192.168.1.54 192.168.2.141 192.168.2.142 192.168.2.176 192.168.2.177 192.168.2.178 192.168.2.179 192.168.2.113 192.168.2.114 192.168.1.36 192.168.1.37'
JHSERVICE='192.168.1.50 192.168.1.51'
USER='hadoop'


#启动zkservice
for i in $ZKSERVICE
do
        ssh -t $USER@$i  "$ZOOKEEPER_HOME/bin/zkServer.sh start"
done
#status
for i in $ZKSERVICE
do
        ssh -t $USER@$i  "$ZOOKEEPER_HOME/bin/zkServer.sh status"
done

#启动journalnode
for i in $JNODE
do
        ssh -t $USER@$i  "$HADOOP_HOME/sbin/hadoop-daemon.sh start journalnode"
done

$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

#need stop a while wait resourcemanager start
sleep 15

#启动jobhistory server
for i in $JHSERVICE
do
        ssh -t $USER@$i  "$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver"
done


#datanode
for i in $DNODE
do
        ssh -t $USER@$i  "$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode"
        ssh -t $USER@$i  "$HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager"
done



#$HADOOP_HOME/sbin/start-all.sh
#$HADOOP_HOME/sbin/hadoop-daemon.sh start journalnode
