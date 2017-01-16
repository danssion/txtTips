#!/usr/bin/env bash
#start hadoop
HADOOP_HOME=/opt/modules/hadoop
ZOOKEEPER_HOME=/opt/modules/zookeeper
ZKSERVICE='192.168.1.50 192.168.1.51 192.168.1.52'
JNODE='192.168.1.50 192.168.1.51 192.168.1.52'
DNODE='192.168.1.51 192.168.1.52 192.168.1.53 192.168.1.54 192.168.2.141 192.168.2.142 192.168.2.176 192.168.2.177 192.168.2.178 192.168.2.179'
JHSERVICE='192.168.1.50 192.168.1.51'
USER='hadoop'

#datanode server nodemanager stop
for i in $DNODE
do
        ssh -t $USER@$i  "$HADOOP_HOME/sbin/yarn-daemon.sh stop nodemanager"
done

sleep 5

#datanode server nodemanager start
for i in $DNODE
do
        ssh -t $USER@$i  "$HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager"
done
