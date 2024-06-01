---
layout: post
title: Pandas Equivalent for Database Analytic Functions
---

I wrote a [post](https://wenleicao.github.io/Pandas_Cheat_Sheet_for_Database_Developer/) about using pandas to do some basic SQL operations a while back. Those are good if you just get started. When dealing with more involved logic, oftentimes than not, you will need to use analytics functions and think how to implement that in the pandas as well. This post will focus on this part.  

I will use the [SQL Server online compiler](https://onecompiler.com/sqlserver/) for this post to display SQL.  The address is as follows. You can paste the SQL code in the window and run it to see results.  

Let us first create a toy dataset. I use union to create a temp table, which will be used to demo what the results are supposed to be in SQL and compare with pandas results, which I will show in the Jupyter notebook. 

