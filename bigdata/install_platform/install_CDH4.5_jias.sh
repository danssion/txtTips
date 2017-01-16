#master 54 #slver 53 HA54-179
#路径定义
MODULES_PATH=/opt/modules
DATA_PATH=/opt/data
HADOOP_HOME=$MODULES_PATH/hadoop_cdh4.5.0

1.下载chd4.5
curl -O http://archive.cloudera.com/cdh5/cdh/4/hadoop-2.0.0-cdh4.5.0.tar.gz
2.下载java-sdk
由于java官方的下载验证，需要手动去指定sdk链接,java版本要求1.6+
3.准备工作
tar zxvf hadoop-2.0.0-cdh4.5.0.tar.gz -C $MODULES_PATH
tar zxvf jdk-7u15-linux-x64.tar.gz -C $MODULES_PATH  

cd $MODULES_PATH
mv hadoop-2.0.0-cdh4.5.0 hadoop_cdh4.5.0
useradd hadoop
mkdir -p $DATA_PATH/hadoop/temp
mkdir -p $DATA_PATH/hadoop/data
mkdir -p $DATA_PATH/hadoop/name
mkdir -p $DATA_PATH/hadoop/data/mapred/local
mkdir -p $DATA_PATH/hadoop/data/mapred/system 
chown -R hadoop:hadoop $DATA_PATH/hadoop 
chown -R hadoop:hadoop $HADOOP_HOME
chown -R root:root $MODULES_PATH/jdk1.7.0_15
find $HADOOP_HOME/ -name "*.sh" | xargs chmod u+x

#配置hadoop用户的无密码ssh连接slver-53 [略]

#添加环境变量
vim /etc/profile (加入以下内容)
	export PATH
	export JAVA_HOME=/opt/modules/jdk1.7.0_15
	export HADOOP_HOME=/opt/modules/hadoop_cdh4.5.0
	export PATH=$PATH:$HADOOP_HOME:$JAVA_HOME/bin:$HADOOP_HOME/bin
:wq
#更新source
source /etc/profile
#修改路径配置
#$HADOOP_HOME/etc/hadoop/hadoop-env.sh
#$HADOOP_HOME/etc/hadoop/yarn-env.sh 
JAVA_HOME=$JAVA_HOME => JAVA_HOME=/opt/modules/jdk1.7.0_15
4.修改配置文件 #$HADOOP_HOME/etc/hadoop/core-site.xml vim core-site.xml (加入以下内容)
	'<property> 
		<name>fs.default.name</name>    
		<value>hdfs://192.168.1.53:9000</value>    
		<final>true</final>  
	</property>  
	<property> 
		<name>hadoop.tmp.dir</name> 
		<value>/opt/data/hadoop/temp</value> 
	</property>'
:wq
#$HADOOP_HOME/etc/hadoop/hdfs-site.xml	
vim hdfs-site.xml (加入以下内容)
	'<property>
		<name>dfs.namenode.name.dir</name>
		<value>/opt/data/hadoop/name</value>
	</property>
	<property>
		<name>dfs.datanode.data.dir</name>
		<value>/opt/data/hadoop/data</value>
	</property>
	<property>
		<name>dfs.replication</name>
		<value>1</value><!--此处的值与data节点的数量相关--->
	</property>
	<property>
		<name>dfs.permissions</name>
		<value>false</value>
	</property>  
	<property>
		<name>dfs.namenode.http-address</name>
		<value>114.112.70.53:50070</value>
	</property>
	<property><!--没有此项会出现0.0.0.0的异常 Warning 或 Error-->
		<name>dfs.secondary.http.address</name>
		<value>192.168.1.53:50090</value>
	</property>'

:wq

#$HADOOP_HOME/etc/hadoop/yarn-site.xml
vim yarn-site.xml(加入以下内容)

	"<property>
		<name>yarn.resourcemanager.address</name>
		<value>192.168.1.53:8032</value>
	</property>
	<property>
		<name>yarn.resourcemanager.scheduler.address</name>
		<value>192.168.1.53:8030</value>
	</property>
	<property>
		<name>yarn.resourcemanager.resource-tracker.address</name>
		<value>192.168.1.53:8031</value>
	</property>
	<property>
		<name>yarn.resourcemanager.admin.address</name>
		<value>192.168.1.53:8033</value>
	</property>
	<property>
		<name>yarn.resourcemanager.webapp.address</name>
		<value>114.112.70.53:8088</value>
	</property>
	<property>
		<name>yarn.nodemanager.aux-services</name>
		<value>mapreduce.shuffle</value>
	</property>
	<property>
		<name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
		<value>org.apache.hadoop.mapred.ShuffleHandler</value>
	</property>"

:wq

#$HADOOP_HOME/etc/hadoop/mapred-site.xml
#若不存在 cp $HADOOP_HOME/etc/hadoop/mapred-site.xml.template $HADOOP_HOME/etc/hadoop/mapred-site.xml
vim mapred-site.xml

	"<property>
		<name>mapreduce.framework.name</name>
		<value>yarn</value>
	</property>
	<property>
		<name>mapred.system.dir</name>
		<value>file:/opt/data/hadoop/mapred/system</value>
		<final>true</final>
	</property>
	<property>
		<name>mapred.local.dir</name>
		<value>file:/opt/data/hadoop/mapred/local</value>
		<final>true</final>
	</property>"
:wq

#$HADOOP_HOME/etc/hadoop/slaves
vim slaves
	"192.168.1.54"
:wq
#/etc/hosts[master,slaver都要配，是各自的通讯ip以及hostname]
vim /etc/hosts
192.168.1.54    BFG-OSER-2376.localdomain BFG-OSER-2376
192.168.1.53    BFG-OSER-2376.localdomain BFG-OSER-2375
#ip与core-site.xml文件中的fs一致


5.复制配置文件到datanode节点
#$HADOOP_HOME/etc/hadoop下的所有文件
scp $HADOOP_HOME/etc/hadoop/* hadoop@192.168.1.53:$HADOOP_HOME/etc/hadoop/
6.初始化nameNode
hdfs namenode -fromat
#同步配置中的dfs.namenode.name.dir到slaver
7.启动集群
sbin/start-dfs.sh
sbin/start-yarn.sh
#sbin/start-all.sh
8.开启lzo压缩
#yum -y install gcc gcc-c++ autoconf automake(若没有,则安装之)
#安装ant
curl -O http://mirrors.cnnic.cn/apache/ant/binaries/apache-ant-1.9.3-bin.tar.gz
tar zxvf apache-ant-1.9.3-bin.tar.gz -C $MODULES_PATH
mv $MODULES_PATH/apache-ant-1.9.3 $MODULES_PATH/ant-1.9.3
vim /etc/profile
	export ANT_HOME=/opt/modules/ant-1.9.3
	export PATH=$PATH:$ANT_HOME:$ANT_HOME/bin
:wq
source /etc/profile
#安装lzo库(2.0以上版本)
curl -O http://www.oberhumer.com/opensource/lzo/download/lzo-2.06.tar.gz
tar zxvf lzo-2.06.tar.gz
cd lzo-2.06
./configure --enable-shared
make
make install
#64位
cp /usr/local/lib/liblzo2* /usr/lib64/
#32位
cp /usr/local/lib/liblzo2* /usr/lib/
#安装lzop
curl -O http://www.lzop.org/download/lzop-1.03.tar.gz
tar zxvf lzop-1.03.tar.gz
cd lzop-1.03
./configure
make && make install
#输入lzop -V验证
#安装编译器lzo
curl -O https://codeload.github.com/kevinweil/hadoop-lzo/zip/master
mv master master.zip
unzip master.zip
#安装依赖关系根据版本的系统不同下载http://packages.sw.be/lzo
#32位
wget http://packages.sw.be/lzo/lzo-devel-2.04-1.el5.rf.i386.rpm
wget http://packages.sw.be/lzo/lzo-2.04-1.el5.rf.i386.rpm
#64位
wget http://pkgs.repoforge.org/lzo/lzo-2.04-1.el5.rf.x86_64.rpm
wget http://pkgs.repoforge.org/lzo/lzo-devel-2.04-1.el5.rf.x86_64.rpm

rpm -ivh lzo-2.04-1.el5.rf.x86_64.rpm
rpm -ivh lzo-devel-2.04-1.el5.rf.x86_64.rpm


cd hadoop-lzo-master
ant compile-native tar

#编译成功后继续，若有错误 百度之
cd build
cp hadoop-lzo-0.4.15.jar $HADOOP_HOME/lib/
#若$HADOOP_HOME/lib/native/Linux-amd64-64不存在创建之
cp native/Linux-amd64-64/lib/* $HADOOP_HOME/lib/native/Linux-amd64-64/

#修改配置文件$HADOOP_HOME/etc/hadoop/core-site.xml
vim core-site.xml

	"<property>    
		<name>io.compression.codecs</name>    
		<value>org.apache.hadoop.io.compress.GzipCodec,org.apache.hadoop.io.compress.DefaultCodec,com.hadoop.compression.lzo.LzoCodec,com.hadoop.compression.lzo.LzopCodec,org.apache.hadoop.io.compress.BZip2Codec</value>
	</property>
	<property>    
	<name>io.compression.codec.lzo.class</name>    
	<value>com.hadoop.compression.lzo.LzoCodec</value>
	</property>"
:wq
#$HADOOP_HOME/etc/hadoop/mapred-site.xml
vim mapred-site.xml
	"<property>
		<name>mapred.compress.map.output</name>    
		<value>true</value>  
	</property>  
	<property>    
		<name>mapred.map.output.compression.codec</name>     
		<value>com.hadoop.compression.lzo.LzoCodec</value>  
	</property>"
:wq
#同步配置文件到各个节点[略]

9.安装zookeeper(节点都需要)
#下载安装包
curl -O http://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.4.5/zookeeper-3.4.5.tar.gz
tar zxvf zookeeper-3.4.5.tar.gz -C $MODULES_PATH
cd $MODULES_PATH/zookeeper-3.4.5/conf
cp zoo_sample.cfg zoo.cfg
#准备目录
mkdir -p $DATA_PATH/zookeeper/data
#加入机器id,按照配置中的写(每个节点都要有)
#按照配置的id写
echo '1' > $DATA_PATH/zookeeper/data/myid

#编辑配置文件
vim zoo.cfg
	修改dataDir的值为/opt/data/zookeeper/data
	在末尾加入
	server.1=192.168.1.53:2888:3888
	server.2=192.168.1.54:2888:3888
	server.3=192.168.2.179:2888:3888
:wq

#把zookeeper路径加入环境变量/etc/profile
vim /etc/profile
	export ZOOKEEPER_HOME=/opt/modules/zookeeper-3.4.5
	export PATH=$PATH:$ZOOKEEPER_HOME:$ZOOKEEPER_HOME/bin
:wq
sourece /etc/profile
#添加用户控制权限
useradd zookeeper
chown -R zookeeper:zookeeper $DATA_PATH/zookeeper
chmod -R 774 $DATA_PATH/zookeeper
chmod -R 775 $DATA_PATH/zookeeper/bin
chown -R zookeeper:hadoop $MODULES_PATH/zookeeper-3.4.5
cd $MODULES_PATH/zookeeper-3.4.5
find ./ -name "*.sh" | xargs chmod u+x,g+x
#启动zookeeper
cd $MODULES_PATH/zookeeper-3.4.5
./bin/zkServer.sh start
#./bin/zkServer.sh status 验证是否启用(注：必须所有节点的zkserver启动后才能看到结果)
#添加zookeeper用户到54 179的无密码登陆[略,暂时不用添加]

10.hadoop HA配置
#$HADOOP_HOME/etc/hadoop/core-site.xml
mkdir $DATA_PATH/ha_data
chown hadoop:hadoop $DATA_PATH/ha_data
sudo su hadoop
scp $HADOOP_HOME/etc/hadoop/* hadoop@192.168.1.54:$HADOOP_HOME/etc/hadoop/
scp $HADOOP_HOME/etc/hadoop/* hadoop@192.168.2.179:$HADOOP_HOME/etc/hadoop/
vim core-site.xml (加入以下内容,替换原有)
	'<property> 
		<name>fs.default.name</name>    
		<value>hdfs://192.168.1.53</value>    
		<final>true</final>  
	</property>  
	<property> 
		<name>hadoop.tmp.dir</name> 
		<value>/opt/data/hadoop/temp</value> 
	</property>
	<property>
		<name>io.compression.codecs</name>
		<value>org.apache.hadoop.io.compress.GzipCodec,org.apache.hadoop.io.compress.DefaultCodec,com.hadoop.compression.lzo.LzoCodec,com.hadoop.compression.lzo.LzopCodec,org.apache.hadoop.io.compress.BZip2Codec</value>
	</property>
	<property>
		<name>io.compression.codec.lzo.class</name>
		<value>com.hadoop.compression.lzo.LzoCodec</value>
	</property>
	<property>
		<name>ha.zookeeper.quorum</name>
		<value>192.168.1.53:2183,192.168.1.54:2183,192.168.2.179:2183</value>
	</property>'

:wq

#$HADOOP_HOME/etc/hadoop/core-site.xml
vim dfs-site.xml (加入以下内容,替换原有)
	'<property>
		<name>dfs.namenode.name.dir</name>
		<value>/opt/data/hadoop/name</value>
	</property>
	<property>
		<name>dfs.datanode.data.dir</name>
		<value>/opt/data/hadoop/data</value>
	</property>
	<property>
		<name>dfs.replication</name>
		<value>1</value>
	</property>
	<property>
		<name>dfs.permissions</name>
		<value>false</value>
	</property>  
	<property>
		<name>dfs.secondary.http.address</name>
		<value>192.168.1.53:50090</value>
	</property>
	<property>
		<name>dfs.datanode.address</name>
		<value>114.112.70.54:50010</value>
	</property>
	<property>
		<name>dfs.nameservices</name>
		<value>cluster</value>
	</property>
	<property>
		<name>dfs.ha.namenodes.cluster</name>
		<value>nn1,nn2</value>
	</property>
	<property>
		<name>dfs.namenode.http-address.cluster.nn1</name>
		<value>114.112.70.53:50070</value>
	</property>
	<property>
		<name>dfs.namenode.http-address.cluster.nn2</name>
		<value>114.112.82.179:50070</value>
	</property>
	<property>
		<name>dfs.namenode.rpc-address.cluster.nn1</name>
		<value>192.168.1.53:8020</value>
	</property>
	
	<property>
		<name>dfs.namenode.rpc-address.cluster.nn2</name>
		<value>192.168.2.179:8020</value>
	</property>
	
	<property>
		<name>dfs.namenode.shared.edites.dir</name>
		<value>qjournal://192.168.1.53:8485;192.168.1.54:8485,192.168.2.179:8485/cluster</value>
	</property>
	
	<property>
		<name>dfs.journalnode.edits.dir</name>
		<value>/opt/data/ha_data/</value>
	</property>
	
	<property>
		<name>dfs.client.failover.proxy.provider.cluster</name>
		<value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
	</property>
	
	<property>
		<name>dfs.ha.fencing.methods</name>
		<value>shell(/bin/true)</value>
	</property>
	<property>
		<name>dfs.ha.fencing.ssh.connect-timeout</name>
		<value>10000</value>
	</property>
	
	<property>
		<name>dfs.ha.automatic-failover.enabled</name>
		<value>true</value>
	</property>
	<property>
		<name>dfs.ha.fencing.ssh.connect-timeout</name>
		<value>10000</value>
	</property>

	<property>
		<name>dfs.ha.automatic-failover.enabled</name>
		<value>true</value>
	</property>
	<property>
		<name>ha.zookeeper.quorum</name>
		<value>192.168.1.53:2181,192.168.1.54:2181,192.168.2.179:2181</value>
	</property>
	<property>
		<name>dfs.ha.fencing.ssh.private-key-files</name>
		<value>/home/hadoop/.ssh/id_rsa</value>
	</property>'

:wq
#notice 注意dfs.ha.namenodes.* 与dfs.federation.nameservices的value值对应 并且有多少就得配置几个
#dfs.namenode.rpc-address.*.* dfs.namenode.http-address.*.*
#与dfs.ha.namenodes.*值对应


#把配置文件分发到所有节点[略]

#在179上执行 hdfs namenode -initializeSharedEdits

#复制53 namenode下的文件=>179 namenode下

#启动53 54 179上的 zookeeper

#启动53 179上的 journalnode   $HADOOP_HOME/sbin/hadoop-daemon.sh start journalnode

#启动hadoop $HADOOP_HOME/sbin/start-all.sh


11.安装hive
#下载
curl -O http://apache.fayea.com/apache-mirror/hive/hive-0.12.0/hive-0.12.0.tar.gz
#安装配置
tar zxvf hive-0.12.0.tar.gz -C $HADOOP_HOME
chown -R hadoop:hadoop $HADOOP_HOME/hive-0.12.0
#修改环境配置
vim /etc/profile(加入内容)
	' 
	export HIVE_HOME=/opt/modules/hadoop_cdh4.5.0/hive-0.12.0 
	export PATH=$PATH:$HIVE_HOME
	'
:wq
['notice'] 
#运行hive时 只能在active进行创建

source /etc/profile
12.配置hive图形化工具hwi
#/etc/profile
	'
	export ANT_LIB=/opt/modules/ant-1.9.3/lib
	'
:wq
#$HADOOP_HOME/hive-0.12.0/conf
cd $HADOOP_HOME/hive-0.12.0/conf
cp hive-default.xml.template hive-site.xml

#$HADOOP_HOME/hive-0.12.0/conf/hive-site.xml
#修改hive.metastore.schema.verification的VALUE值 =>false

cp $JAVA_HOME/lib/tools.jar $HADOOP_HOME/hive-0.12.0/lib/
chown hadoop:hadoop $HADOOP_HOME/hive-0.12.0/lib/tools.jar
#启动 hwi
nohup bin/hive --service hwi &
#启动时候可能有配置文件报错 是因为标签对不匹配，在line:2000 修改下value标签对就好





['待解决问题']
#hadoop本地库的引用
#hadoop在重启 down 以及多重问题下的应急措施和启动方案

['notice']
#此配置在hadoop的data数据只有一份，在多硬盘服务器中 需要在多个硬盘建立 data目录 并加入配置中

['环境变量']
#/etc/profile
" 	export PATH
	export JAVA_HOME=/opt/modules/jdk1.7.0_15
	export HADOOP_HOME=/opt/modules/hadoop_cdh4.5.0
	export ANT_HOME=/opt/modules/ant-1.9.3
	export ANT_LIB=/opt/modules/ant-1.9.3/lib
	export HIVE_HOME=/opt/modules/hadoop_cdh4.5.0/hive-0.12.0
	export JAVA_LIBRARY_PATH=/opt/modules/hadoop_cdh4.5.0/lib/native/Linux-amd64-64
	export ZOOKEEPER_HOME=/opt/modules/zookeeper-3.4.5
	export PATH=$PATH:$HADOOP_HOME:$JAVA_HOME/bin:$HADOOP_HOME/bin:$ANT_HOME:$ANT_HOME/bin:$ZOOKEEPER_HOME:$ZOOKEEPER_HOME/bin:$JAVA_LIBRARY_PATH:$HIVE_HOME
"
