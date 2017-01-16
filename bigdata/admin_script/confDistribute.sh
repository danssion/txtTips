#!/usr/bin/env bash
#start hadoop
HADOOP_HOME=/opt/modules/hadoop
TARGET_DIR=/opt/modules/hadoop/etc/hadoop-ordinary
TARGET_141_DIR=/opt/modules/hadoop/etc/hadoop-141-142/
TARGET_113_DIR=/opt/modules/hadoop/etc/hadoop-113-114/
SERVICES='192.168.1.51 192.168.1.52 192.168.1.53 192.168.1.54 192.168.1.49 192.168.2.141 192.168.2.142 192.168.2.176 192.168.2.177 192.168.2.178 192.168.2.179 192.168.2.113 192.168.2.114 192.168.1.36 192.168.1.37'
#SERVICES='192.168.1.51'
USER='hadoop'

#发送到服务器
for i in $SERVICES
do
	echo $TARGET_DIR,$i
	`scp -r $HADOOP_HOME/etc/hadoop-ordinary/* $USER@$i:$TARGET_DIR`
	`scp -r $HADOOP_HOME/etc/hadoop-141-142/* $USER@$i:$TARGET_141_DIR`
	`scp -r $HADOOP_HOME/etc/hadoop-113-114/* $USER@$i:$TARGET_113_DIR`
done




