---
layout: post
title: Setting Up Hbase 1.0.1
modified:
categories: [tutorial,installation,hbase,hadoop]
excerpt: How to set up hbase 1.0.1 on top of hadoop 2X
tags: [hbase, hbase 1.0.1, hbase hadoop2X]
date: 2015-05-13T14:55:38+05:30
---

Assuming that you have setup hadoop 2X as described in [Setting Up Hadoop 2.6.0](/tutorial/installation/hadoop/setting-up-hadoop-2-6-0) If not please Do that first

### Step 1.1 : Hbase Installation - Download and Extract hbase


I've downloaded hbase from the [Hbase-1.0.1 Download](http://mirrors.koehn.com/apache/hbase/hbase-1.0.1/hbase-1.0.1-bin.tar.gz)

{% highlight bash %}
mkdir /opt/hbase
cd /opt/hbase
wget http://mirrors.koehn.com/apache/hbase/hbase-1.0.1/hbase-1.0.1-bin.tar.gz
tar xzf hbase-1.0.1-bin.tar.gz
sudo ln -s hbase-1.0.1 current
{% endhighlight %}

### Step 1.2 : Hbase Installation - Configuring hbase-env.sh

Set the java Home for HBase and open hbase-env.sh file from the conf folder. Edit JAVA_HOME environment variable and change the existing path to your current JAVA_HOME variable as shown below.
I have my Java installed at /opt/java/current. Setup yours accordingly

Configuration files can be found at /opt/hbase/current/conf

{% highlight bash %}
export JAVA_HOME=/opt/java/current
{% endhighlight %}

### Step 1.3 : Hbase Installation - Configuring hbase-site.xml


{% highlight xml %}
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
	<property>
	   <name>hbase.cluster.distributed</name>
	   <value>true</value>
	</property>
	<property>
      <name>hbase.rootdir</name>
      <value>hdfs://cyborg:9000/hbase</value>
   </property>
	<property>
      <name>hbase.zookeeper.property.dataDir</name>
      <value>/opt/hadoop/data/zookeeper</value>
   </property>
</configuration>
{% endhighlight %}

### Step 2.1 : Starting Hbase
Start hbase by executing the following command 
{% highlight bash %}
/opt/hbase/current/bin/start-hbase.sh
{% endhighlight %}

Should give you the following output
{% highlight bash %}
localhost: starting zookeeper, logging to /opt/hbase/current/bin/../logs/hbase-vishnu-zookeeper-cyborg.out
starting master, logging to /opt/hbase/current/bin/../logs/hbase-vishnu-master-cyborg.out
starting regionserver, logging to /opt/hbase/current/bin/../logs/hbase-vishnu-1-regionserver-cyborg.out
{% endhighlight %}

### Step 2.2 : Verifying if Hbase is storing files on hdfs

Run the following command to verify if hbase files are on hdfs

{% highlight bash %}
$ /opt/hadoop/current/bin/hadoop fs -ls /hbase

Found 6 items
drwxr-xr-x   - vishnu supergroup          0 2015-05-13 15:30 /hbase/.tmp
drwxr-xr-x   - vishnu supergroup          0 2015-05-13 15:30 /hbase/WALs
drwxr-xr-x   - vishnu supergroup          0 2015-05-13 15:30 /hbase/data
-rw-r--r--   1 vishnu supergroup         42 2015-05-13 15:30 /hbase/hbase.id
-rw-r--r--   1 vishnu supergroup          7 2015-05-13 15:30 /hbase/hbase.version
drwxr-xr-x   - vishnu supergroup          0 2015-05-13 15:30 /hbase/oldWALs
{% endhighlight %}

### Hbase Shell

After Installing HBase successfully, you can start HBase Shell. below is a list of commands executed on hbase shell.

{% highlight bash %}
$ /opt/hbase/current/bin/hbase shell

SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/opt/hbase/hbase-1.0.1/lib/slf4j-log4j12-1.7.7.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/opt/hadoop/hadoop-2.6.0/share/hadoop/common/lib/slf4j-log4j12-1.7.5.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.slf4j.impl.Log4jLoggerFactory]
HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 1.0.1, r66a93c09df3b12ff7b86c39bc8475c60e15af82d, Fri Apr 17 22:14:06 PDT 2015

hbase(main):001:0> create 'test', 'cf'
0 row(s) in 0.7980 seconds

=> Hbase::Table - test
hbase(main):002:0> list 'test'
TABLE                                                                                                                                                                   
test                                                                                                                                                                    
1 row(s) in 0.0800 seconds

=> ["test"]
hbase(main):003:0> put 'test', 'row1', 'cf:a', 'value1'
0 row(s) in 0.1050 seconds

hbase(main):004:0> put 'test', 'row1', 'cf:a', 'value1'
0 row(s) in 0.0100 seconds

hbase(main):005:0> put 'test', 'row2', 'cf:b', 'value2'
0 row(s) in 0.0130 seconds

hbase(main):006:0> put 'test', 'row3', 'cf:c', 'value3'
0 row(s) in 0.0100 seconds

hbase(main):007:0> scan 'test'
ROW                                         COLUMN+CELL                                                                                                                 
 row1                                       column=cf:a, timestamp=1431511388527, value=value1                                                                          
 row2                                       column=cf:b, timestamp=1431511396170, value=value2                                                                          
 row3                                       column=cf:c, timestamp=1431511403914, value=value3                                                                          
3 row(s) in 0.0430 seconds

hbase(main):008:0> 

{% endhighlight %}

## IGNORE NOTE TO SELF

#### Start Hadoop and Hbase

{% highlight bash %}

# Starting Hadoop
$ /opt/hadoop/current/sbin/start-dfs.sh
Starting namenodes on [cyborg]
cyborg: starting namenode, logging to /opt/hadoop/hadoop-2.6.0/logs/hadoop-vishnu-namenode-cyborg.out
cyborg: starting datanode, logging to /opt/hadoop/hadoop-2.6.0/logs/hadoop-vishnu-datanode-cyborg.out
Starting secondary namenodes [0.0.0.0]
0.0.0.0: starting secondarynamenode, logging to /opt/hadoop/hadoop-2.6.0/logs/hadoop-vishnu-secondarynamenode-cyborg.out

# list of processes after starting hadoop
$ jps
21241 Jps
20821 NameNode
21165 SecondaryNameNode
20975 DataNode

# Starting Hbase

$ /opt/hbase/current/bin/start-hbase.sh

localhost: starting zookeeper, logging to /opt/hbase/current/bin/../logs/hbase-vishnu-zookeeper-cyborg.out
starting master, logging to /opt/hbase/current/bin/../logs/hbase-vishnu-master-cyborg.out
starting regionserver, logging to /opt/hbase/current/bin/../logs/hbase-vishnu-1-regionserver-cyborg.out

# list of processes after starting hbase
$ jps

22139 HRegionServer
22007 HMaster
21938 HQuorumPeer
20821 NameNode
21165 SecondaryNameNode
20975 DataNode
22557 Jps

{% endhighlight %}


#### Stop Hbase and Hadoop

{% highlight bash %}
#Running Process before stopping
$ jps
15742 HQuorumPeer
15815 HMaster
18585 Jps
15948 HRegionServer
31714 SecondaryNameNode
31518 DataNode
31355 NameNode

#Stopping Hbase 
$ /opt/hbase/current/bin/stop-hbase.sh

#Running Process after stopping hbase
$ jps
19080 Jps
31714 SecondaryNameNode
31518 DataNode
31355 NameNode

# Stopping dfs
$ /opt/hadoop/current/sbin/stop-dfs.sh

#Running Process after stopping dfs
$ jps
19682 Jps
{% endhighlight %}