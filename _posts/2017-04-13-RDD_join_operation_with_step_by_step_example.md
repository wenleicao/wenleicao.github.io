---
layout: post
title: Spark RDD join operation with step by step example
---

Compared with Hadoop, Spark is a newer generation infrastructure for big data. It stores data in Resilient Distributed Datasets (RDD) format in memory, processing data in parallel.  RDD can be used to process structural data directly as well. It is hard to find a practical tutorial online to show how join and aggregation works in spark. I did some research.  For presentation purpose, I just use a small dataset, but you can use much larger one. 

Here is a common many to many relation issue in RDBMS world. 
<img src="/images/blog6/table_relation.PNG" alt="relation">

