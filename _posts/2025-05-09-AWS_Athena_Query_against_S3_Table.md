---
layout: post
title: AWS Athena Query against S3 Table with Python
---

Athena query plays a pivotal role within the AWS ecosystem. Most data in AWS (excluding RDS) is stored in S3 buckets. Users can easily create tables from files in S3 using Athena DDL, supporting various formats such as CSV, JSON, and Parquet. This enables the use of SQL to analyze the data in these files. Additionally, Athena offers superior query performance compared to regular RDS queries by automatically executing queries in parallel for large datasets. However, a drawback of this approach is that S3 files cannot be modified like traditional database tables, prompting AWS to introduce S3 table bucket to address this limitation since Nov 2024.  

To make it simple, we call Athena tables sourced from S3 files as regular Athena tables. We will simply call S3 tables for S3 table bucket type.  

There is little difference in the AWS console between these two types of tables; the main distinction is the need to select the catalog when querying an S3 table.  

For a data scientist, I am interested in how to get data from S3 table programmatically.  

However, querying S3 tables using the Python Boto3 API differs significantly from querying regular Athena tables. Unfortunately, online materials on this topic are scarce, and it took me quite some time and assistance from an IT colleague to figure it out.  

Firstly, let's review the Python code for querying regular Athena tables. For detailed explanations, please refer to this [link](https://www.ilkkapeltola.fi/2018/04/simple-way-to-query-amazon-athena-in.html).  

The steps involved are:

* Pass the query to client start_query_execution and obtain the execution ID
* Use the execution ID with client get_query_execution to retrieve the S3 file
* Read the S3 file into a Pandas DataFrame (refer to [this](https://stackoverflow.com/questions/37703634/how-to-import-a-text-file-on-aws-s3-into-pandas-without-writing-to-disk) for guidance)



