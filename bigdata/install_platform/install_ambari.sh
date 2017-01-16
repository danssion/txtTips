#环境支持
#1.SELinux，iptables都处于关闭状态
#2.集群同步时间
#3.集群中ambari-serveer（管理节点）到客户端配置无密码登陆 自动部署需要
#4.安装缺少的包yum install pdsh


#下载yum源
#http://ambari.apache.org/1.2.2/installing-hadoop-using-ambari/content/ambari-chap7.html
#选择对应系统的yum源[这里是Centos5.x]
wget http://public-repo-1.hortonworks.com/ambari/centos5/1.x/updates/1.2.4.9/ambari.repo
cp ambari.repo /etc/yum.repos.d
#下载epel仓库
#注意这里的升级可能会引起系统本身python的升级导致yum无法使用　安装python2.4 并修改/usr/bin/yum的python头来修正
yum install epel-release
#确认列表中有 HDP-UTILS ambari epel
yum repolist

#通过yum安装amabari bits  同时也会安装PostgreSQL agent不要执行
yum install ambari-server

#运行ambari-server并配置PostgreSQL
#选择生成配置时　输入n 默认的账号密码为ambari-server/bigdata
ambari-server setup

#增加用户ambari
useradd ambari
#权限更改
#查看包名rpm -qa | grep ambari
#查看安装位置rpm -ql xxx
#/var/lib/ambari-server
chown -R ambari:root /var/lib/ambari-server
#更改配置文件权限
chown -R ambari:root /etc/ambari-server

#启动ambari-server,通过ip:8080即可访问ambari
ambari-server start

#配置ambari
#打开ip:8080 账号密码admin/admin
#第二步　选择Perform manual registration on hosts and do not use SSH
#在所有节点上执行

#选择１自动注册　需要有各个服务器的root账号权限
#选择２手动注册agent 在各个节点执行 yum list| grep ambari-agent
yum install ambari-agent.x86_64 
#添加用户
useradd ambari
#配置agent到master的ambari用户无密码登陆[略]
#修正权限
chown -R ambari:root /var/lib/ambari-agent
chown -R ambari:root /etc/ambari-agent
chown -R ambari:root /var/log/ambari-agent
chown -R ambari:root /var/run/ambari-agent
#添加脚本
mkdir -p /opt/modules/ambari-agent
touch  /opt/modules/ambari-agent/hostname.sh
vim /opt/modules/ambari-agent/hostname.sh
#在hostname中加入以下内容, 其中echo的内容未当前机器的节点名称　与/etc/hosts文件对应
"
#!/bin/sh
echo  BFG-OSER-2372.localdomain
"
chown -R ambari:ambari /opt/modules/ambari-agent/
chmod -R 740 /opt/modules/ambari-agent/
vim /etc/ambari-agent/conf/ambari-agent.ini
#修在agent中加入
"
hostname_script=/opt/modules/ambari-agent/hostname.sh
server=BFG-OSER-2372.localdomain
"
#修改server
"
hostname=192.168.1.49
"


#若连通性失败ssh3错误尝试更新ssh证书
#备份ssh证书
mv /etc/pki/tls/certs/ca-bundle.crt /etc/pki/tls/certs/ca-bundle.crt.bak
#更新ssh证书
wget http://curl.haxx.se/ca/cacert.pem 
mv cacert.pem ca-bundle.crt  | mv ca-bundle.crt /etc/pki/tls/certs/ 
#启动节点
su ambari
ambari-agent start
