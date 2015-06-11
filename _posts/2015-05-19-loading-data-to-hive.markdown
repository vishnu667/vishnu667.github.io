---
layout: post
title: Loading Data to Hive
modified:
categories: 
excerpt:
tags: []
image:
  feature:
date: 2015-05-19T12:14:45+05:30
---


Create external table pokes (
  rowid int,
  features ARRAY<STRING>
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' COLLECTION ITEMS TERMINATED BY "," STORED AS TEXTFILE LOCATION '/dataset/news20-multiclass/train';

Create external table p_train (
  rowid int,
  features ARRAY<STRING>
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' COLLECTION ITEMS TERMINATED BY "," STORED AS TEXTFILE LOCATION '/dataset/news20-multiclass/train';

Create external table p_test (
  rowid int,
  features ARRAY<STRING>
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' COLLECTION ITEMS TERMINATED BY "," STORED AS TEXTFILE LOCATION '/dataset/news20-multiclass/test';






create or replace view p_train_x3
as
select 
  * 
from (
select
   amplify(3, *) as (rowid, features)
from  
   p_train 
) t
CLUSTER BY rand(${seed});


create table p_test_exploded as
select 
  rowid,
  cast(split(feature,":")[0] as DOUBLE) as valuex,
  cast(split(feature,":")[1] as DOUBLE) as valuey
from 
  p_test LATERAL VIEW explode(addBias(features)) t AS feature;



  CREATE KEYSPACE happy
WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };



CREATE TABLE users (
rowid bigint,
x double,
y double
PRIMARY KEY (rowid));