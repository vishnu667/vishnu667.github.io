---
layout: post
title: Setting Up Hive and Hbase
modified:
categories: 
excerpt:
tags: []
image:
  feature:
date: 2015-05-13T16:21:42+05:30
---

Assuming you have already Setup Hadoop and Hbase if not please follow the link and do so. 
* [Setting Up Hadoop 2.6.0](/tutorial/installation/hadoop/setting-up-hadoop-2-6-0)
* [Setting Up Hbase 1.0.1](/tutorial/installation/hbase/hadoop/setting-up-hbase-1-0-1)

### Step 1.1 : Download and Extract Hive Files

{% highlight bash %} 
mkdir /opt/hive
cd /opt/hive
wget http://mirror.reverse.net/pub/apache/hive/stable/apache-hive-1.1.0-bin.tar.gz
tar -xzvf apache-hive-1.1.0-bin.tar.gz
sudo ln -s apache-hive-1.1.0-bin current
{% endhighlight %}

Set the enviroment variable for HIVE_HOME in your path 
{% highlight bash %}
export HIVE_HOME=/opt/hive/current
{% endhighlight %}

### Step 1.2 : Setting up the Right Permissions

{% highlight bash %}
$HADOOP_HOME/bin/hadoop fs -mkdir       /tmp
$HADOOP_HOME/bin/hadoop fs -mkdir       /user
$HADOOP_HOME/bin/hadoop fs -mkdir       /user/hive
$HADOOP_HOME/bin/hadoop fs -mkdir       /user/hive/warehouse
$HADOOP_HOME/bin/hadoop fs -chmod g+w   /tmp
$HADOOP_HOME/bin/hadoop fs -chmod g+w   /user/hive/warehouse
{% endhighlight %}

Step 1.3 : To check hive is setup properly via hive cli

{% highlight bash %}
$ /opt/hive/current/bin/hive

Logging initialized using configuration in jar:file:/opt/hive/apache-hive-1.1.0-bin/lib/hive-common-1.1.0.jar!/hive-log4j.properties
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/opt/hive/apache-hive-1.1.0-bin/lib/hive-jdbc-1.1.0-standalone.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/opt/hadoop/hadoop-2.6.0/share/hadoop/common/lib/slf4j-log4j12-1.7.5.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.slf4j.impl.Log4jLoggerFactory]
hive>
{% endhighlight %}

If the above throws the following exception then set the following Enviroment variable this should fix the problem. [Reason for doing so.](http://stackoverflow.com/a/29040037/2104970)
{% highlight bash %}
" export HADOOP_USER_CLASSPATH_FIRST=true "
{% endhighlight %}

{% highlight bash %}
[ERROR] Terminal initialization failed; falling back to unsupported
java.lang.IncompatibleClassChangeError: Found class jline.Terminal, but interface was expected
	at jline.TerminalFactory.create(TerminalFactory.java:101)
	at jline.TerminalFactory.get(TerminalFactory.java:158)
	at jline.console.ConsoleReader.<init>(ConsoleReader.java:229)
	at jline.console.ConsoleReader.<init>(ConsoleReader.java:221)
	at jline.console.ConsoleReader.<init>(ConsoleReader.java:209)
	at org.apache.hadoop.hive.cli.CliDriver.getConsoleReader(CliDriver.java:773)
	at org.apache.hadoop.hive.cli.CliDriver.executeDriver(CliDriver.java:715)
	at org.apache.hadoop.hive.cli.CliDriver.run(CliDriver.java:675)
	at org.apache.hadoop.hive.cli.CliDriver.main(CliDriver.java:615)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:606)
	at org.apache.hadoop.util.RunJar.run(RunJar.java:221)
	at org.apache.hadoop.util.RunJar.main(RunJar.java:136)
{% endhighlight %}


Step 1.4 : Running HiveServer2 and Beeline

HiveServer2 (introduced in Hive 0.11) has its own CLI called Beeline.  HiveCLI is now deprecated in favor of Beeline, as it lacks the multi-user, security, and other capabilities of HiveServer2.  To run HiveServer2 and Beeline from shell

{% highlight bash %}
# To start the hiveserver2
/opt/hive/current/bin/hiveserver2

# To Start beeline Cli where cyborg is the hostname and 10000 is the default hiveserver2 port
$ /opt/hive/current/bin/beeline -u jdbc:hive2://cyborg:10000

scan complete in 3ms
Connecting to jdbc:hive2://cyborg:10000
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/opt/hive/apache-hive-1.1.0-bin/lib/hive-jdbc-1.1.0-standalone.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/opt/hadoop/hadoop-2.6.0/share/hadoop/common/lib/slf4j-log4j12-1.7.5.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.slf4j.impl.Log4jLoggerFactory]
Connected to: Apache Hive (version 1.1.0)
Driver: Hive JDBC (version 1.1.0)
Transaction isolation: TRANSACTION_REPEATABLE_READ
Beeline version 1.1.0 by Apache Hive
0: jdbc:hive2://cyborg:10000> 
{% endhighlight %}