---
layout: post
title: Setting Up Hadoop 2.6.0
modified:
categories: [tutorial,installation,hadoop]
excerpt: How to set up Hadoop 2.6.0 as a Single node hadoop cluster
tags: [hadoop,hadoop 2.6.0, hadoop 2x, ubuntu,installation,setup,tutorial]
date: 2015-05-13T13:43:50+05:30
---


Steps for Setting up a Single node hadoop cluster.

### Creating User

Assuming that you have a seperate user for setting up hadoop or all your nodes have the same user configured already, if not create a user by.

{% highlight bash %}
$ su
password:
# useradd hadoop
# passwd hadoop
New passwd:
Retype new passwd
{% endhighlight %}

### Check Java Version

Please install Java(TM) SE Runtime Environment version 1.7. To check if your java version run java -version. If not please install the Java SE. Also Check if JAVA_HOME is set

{% highlight bash%}
$ java -version                                                        
java version "1.7.0_45"
Java(TM) SE Runtime Environment (build 1.7.0_45-b18)
Java HotSpot(TM) 64-Bit Server VM (build 24.45-b08, mixed mode)
{% endhighlight %}

## Installing Hadoop

### Setp 1: Download and Extract

I personally prefer all applications installed at /opt/ therefore have proceeded so.

Download the hadoop from [Hadoop 2.6.0](http://mirror.metrocast.net/apache/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz)

{% highlight bash%}
sudo chmod 777 /opt
mkdir /opt/hadoop
cd /opt/hadoop
wget http://apache.arvixe.com/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz
tar xzf hadoop-2.6.0.tar.gz
# Creating a symbolic link current for the folder hadoop-2.6.0
sudo ln -s hadoop-2.6.0 current
{% endhighlight %}

Add "export HADOOP_HOME=/usr/local/hadoop" to .bashrc
Assuming that the above is setup properly to verify the installation run hadoop version

{% highlight bash%}
$/opt/hadoop/current/bin/hadoop version
Hadoop 2.6.0
Subversion https://git-wip-us.apache.org/repos/asf/hadoop.git -r e3496499ecb8d220fba99dc5ed4c99c8f9e33bb1
Compiled by jenkins on 2014-11-13T21:10Z
Compiled with protoc 2.5.0
From source with checksum 18e43357c8f927c0695f1e9522859d6a
This command was run using /opt/hadoop/hadoop-2.6.0/share/hadoop/common/hadoop-common-2.6.0.jar
{% endhighlight %}


### Setp 2: Creating required Directories

Assuming that all the data is going to be set up in the same location on all instances

The Following directories are going to be created
{% highlight bash%}
mkdir /opt/hadoop/data
mkdir /opt/hadoop/data/tmpDir
mkdir /opt/hadoop/data/name
mkdir /opt/hadoop/data/data
{% endhighlight %}

### Setp 3.1: Hadoop Configuration - core-site.xml

The core-site.xml file contains information such as the port number used for Hadoop instance, memory allocated for file system, memory limit for storing data, and the size of Read/Write buffers.

All hadoop configuration files are located at HADOOP_HOME/etc/hadoop

{% highlight xml%}
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <!-- Here cyborg is my master node's host name-->
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://cyborg:9000</value>
    </property>
	<!-- Setting up the tmp.dir to /opt/hadoop/data/tmpDir which we have created earlier -->
    <property>
        <name>hadoop.tmp.dir</name> 
        <value>/opt/hadoop/data/tmpDir</value> 
    </property>
</configuration>
{% endhighlight %}

### Setp 3.2: Hadoop Configuration - hdfs-site.xml

The hdfs-site.xml file contains information such as the value of replication data, namenode path, and datanode path of your local file systems, where you want to store the Hadoop infrastructure.

Assuming the following details 
dfs.replication = 1
namenode path = /opt/hadoop/data/name
datanode path = /opt/hadoop/data/data

{% highlight xml%}
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
	<!-- DFS Replication Value-->
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <!-- DFS Permission-->
    <property> 
       <name>dfs.permissions</name> 
       <value>false</value> 
    </property> 
	<!-- DFS namenode path -->
    <property> 
        <name>dfs.name.dir</name> 
        <value>/opt/hadoop/data/dfs/name</value> 
    </property>
	<!-- DFS datanode path --> 
   	<property>
	    <name>dfs.data.dir</name>
	    <value>/opt/hadoop/data/dfs/data</value>
   	</property>
</configuration>
{% endhighlight %}


### Setp 3.3: Hadoop Configuration - yarn-site.xml

This file is used to configure yarn into Hadoop. 

{% highlight xml%}
<?xml version="1.0"?>
<configuration>
   <property>
      <name>yarn.nodemanager.aux-services</name>
      <value>mapreduce_shuffle</value>
   </property>
</configuration>
{% endhighlight %}

### Setp 3.4: Hadoop Configuration - mapred-site.xml

{% highlight xml%}
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
   <property>
      <name>mapreduce.framework.name</name>
      <value>yarn</value>
   </property>
</configuration>
{% endhighlight %}

### Setp 3.4: Hadoop Configuration - mapred-site.xml

This file is used to specify which MapReduce framework we are using. By default, Hadoop contains a template of yarn-site.xml. It is required to copy the file from mapred-site.xml.template to mapred-site.xml file or create it.

{% highlight xml%}
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
   <property>
      <name>mapreduce.framework.name</name>
      <value>yarn</value>
   </property>
</configuration>
{% endhighlight %}

### Step 4.1 Verifying Hadoop Installation - Name Node Setup

Set up the namenode using the command “hdfs namenode -format” as follows.

{% highlight bash%}
/opt/hadoop/current/bin/hdfs namenode -format
{% endhighlight %}

The expected result is as follows.

{% highlight bash%}
15/05/13 14:39:08 INFO namenode.NameNode: STARTUP_MSG: 
/************************************************************
STARTUP_MSG: Starting NameNode
STARTUP_MSG:   host = cyborg/10.18.26.116
STARTUP_MSG:   args = [-format]
STARTUP_MSG:   version = 2.6.0

...
...
...

15/05/13 14:39:14 INFO namenode.FSImage: Allocated new BlockPoolId: BP-1759072668-10.18.26.116-1431508154082
15/05/13 14:39:14 INFO common.Storage: Storage directory /opt/hadoop/data/dfs/name has been successfully formatted.
15/05/13 14:39:14 INFO namenode.NNStorageRetentionManager: Going to retain 1 images with txid >= 0
15/05/13 14:39:14 INFO util.ExitUtil: Exiting with status 0
15/05/13 14:39:14 INFO namenode.NameNode: SHUTDOWN_MSG: 
/************************************************************
SHUTDOWN_MSG: Shutting down NameNode at cyborg/10.18.26.116
************************************************************/
{% endhighlight %}

### Step 4.2 Verifying Hadoop Installation - Hadoop Dfs Setup

The start-dfs.sh command is used to start dfs. Executing this command will start your Hadoop file system.

{% highlight bash%}
/opt/hadoop/current/sbin/start-dfs.sh
{% endhighlight %}

The Followin output can be expected

{% highlight bash%}                            
Starting namenodes on [cyborg]
cyborg: starting namenode, logging to /opt/hadoop/hadoop-2.6.0/logs/hadoop-vishnu-namenode-cyborg.out
cyborg: starting datanode, logging to /opt/hadoop/hadoop-2.6.0/logs/hadoop-vishnu-datanode-cyborg.out
Starting secondary namenodes [0.0.0.0]
0.0.0.0: starting secondarynamenode, logging to /opt/hadoop/hadoop-2.6.0/logs/hadoop-vishnu-secondarynamenode-cyborg.out
{% endhighlight %}

### Step 4.3 Verifying Hadoop Installation - Yarn Script

The start-yarn.sh command is used to start the yarn script. Executing this command will start your yarn daemons.
{% highlight bash%}
/opt/hadoop/current/sbin/start-yarn.sh
{% endhighlight %}

The Followin output can be expected

{% highlight bash%}
starting yarn daemons
starting resourcemanager, logging to /opt/hadoop/current/logs/yarn-vishnu-resourcemanager-cyborg.out
cyborg: starting nodemanager, logging to /opt/hadoop/hadoop-2.6.0/logs/yarn-vishnu-nodemanager-cyborg.out
{% endhighlight %}

### Step 4.2 Verifying Hadoop Installation - Accessing Hadoop on Browser

The default port number to access Hadoop is 50070. Use the following url to get Hadoop services on your browser

{% highlight bash %}
http://localhost:50070
{% endhighlight %}

And for Yarn check the below link
{% highlight bash %}
http://localhost:8088
{% endhighlight %}