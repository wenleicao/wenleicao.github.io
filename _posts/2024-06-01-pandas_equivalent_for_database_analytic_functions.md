---
layout: post
title: Pandas Equivalent for Database Analytic Functions
---

I wrote a [post](https://wenleicao.github.io/Pandas_Cheat_Sheet_for_Database_Developer/) about using pandas to do some basic SQL operations a while back. Those are good if you just get started. When dealing with more involved logic, oftentimes than not, you will need to use analytics functions and think how to implement that in the pandas as well. This post will focus on this part.  

I will use the [SQL Server online compiler](https://onecompiler.com/sqlserver/) for this post to display SQL.  The address is as follows. You can paste the SQL code in the window and run it to see results.  

Let us first create a toy dataset. I use union to create a temp table, which will be used to demo what the results are supposed to be in SQL and compare with pandas results, which I will show in the Jupyter notebook. 

<img src="/images/blog61/1sql_createtable.JPG">   
<img src="/images/blog61/1sql_createtable_result.JPG">

I deliberately include the null value here so that we can observe how SQL and pandas handle it. Pandas creates a dataframe which behaves like tables in a database.    

<img src="/images/blog61/1pandas_createtable.JPG">  

* The first challenge is using regular aggregation like sum/avg.  With over (partition by …) SQL syntax, this allows us to get aggregation at each original row without reducing the row number like group by. This will help when you need to calculate different metrics in situ but don’t want to reduce the record.  I have count(score) and count(*) here. The former will ignore null value in the score column, but count(*) will return all record counts. 



