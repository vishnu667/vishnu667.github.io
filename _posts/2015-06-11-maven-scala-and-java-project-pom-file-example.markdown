---
layout: post
title: Maven Scala and Java Mixin Project
modified:
categories: 
excerpt: A simple way to mixin and write, Java and Scala Together in the same project using Maven
tags: [tutorial,maven,pom,java,scala,scala and java]
image:
  feature:
date: 2015-06-11T22:21:54+05:30
---

A sample Maven Pom file Example for a java and scala project using maven. This allows you to code in both languages in the same project. 

#### Project Directory Structure

{% highlight bash %} 
|-- pom.xml
|-- src
|   |-- main
|   |   |-- java
|   |   |-- resources
|   |   `-- scala
|   `-- test
|       |-- java
|       `-- scala
`-- target
    |-- blog-examples-1.0.jar
    |-- classes
    |-- maven-archiver
    |   `-- pom.properties
    `-- test-classes
{% endhighlight %}

Place all the Java Classes in the src/main/java folder and scala files in src/main/scala.
and the test classes respoetively in src/main/scala and src/main/java.

#### Project Pom.xml File 

{% highlight xml %} 
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>in.cybergen</groupId>
    <artifactId>blog-examples</artifactId>
    <version>1.0</version>
    <!-- Dependencies for the project -->
    <dependencies>
        <!--Language Dependencies-->
        <dependency>
            <groupId>org.scala-lang</groupId>
            <artifactId>scala-library</artifactId>
            <version>2.10.5</version>
        </dependency>
    </dependencies>
    <!-- End of Dependencies for the project -->
    <repositories>
        <repository>
            <id>scala-tools.org</id>
            <name>Scala-tools Maven2 Repository</name>
            <url>http://scala-tools.org/repo-releases</url>
        </repository>
    </repositories>
    <pluginRepositories>
        <pluginRepository>
            <id>scala-tools.org</id>
            <name>Scala-tools Maven2 Repository</name>
            <url>http://scala-tools.org/repo-releases</url>
        </pluginRepository>
    </pluginRepositories>
    <build>
        <pluginManagement>
            <plugins>
                <plugin>
                    <groupId>org.scala-tools</groupId>
                    <artifactId>maven-scala-plugin</artifactId>
                    <version>2.9.1</version>
                </plugin>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-compiler-plugin</artifactId>
                    <version>2.0.2</version>
                </plugin>
            </plugins>
        </pluginManagement>
        <plugins>
            <plugin>
                <groupId>org.scala-tools</groupId>
                <artifactId>maven-scala-plugin</artifactId>
                <executions>
                    <execution>
                        <id>scala-compile-first</id>
                        <phase>process-resources</phase>
                        <goals>
                            <goal>add-source</goal>
                            <goal>compile</goal>
                        </goals>
                    </execution>
                    <execution>
                        <id>scala-test-compile</id>
                        <phase>process-test-resources</phase>
                        <goals>
                            <goal>testCompile</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <executions>
                    <execution>
                        <phase>compile</phase>
                        <goals>
                            <goal>compile</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
{% endhighlight %}


To complie and generate the target sources run 

{% highlight bash %} 
mvn install  #This shoud generate the required target directories
{% endhighlight %}