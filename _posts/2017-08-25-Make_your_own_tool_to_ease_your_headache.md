---
layout: post
title: String builder for BI developer
---

People create tool to make their job easier. Carpenters make wood jig.  Farmers are using spinning wheel for making cloth. 
As a BI developer, I came across many scenario that the job is tedious, but you have to be careful or the code won't work.

I give two examples in SSIS.  The following code are all T SQL code.  

1. I have been using the method describing in the following blog to compared two big tables and do insert and update.  This method works great.  
<http://sqlblog.net/2014/05/01/insert-and-update-records-with-a-ssis-etl-package/>  

The update step is completed by OLE DB command task. This requires you pass in each column value of your incoming record as variables to update your existing record via a stored procedure.  

<img src="/images/blog10/example1.PNG" >

In this case, it only has 5 variables,  what if this is a big fact table that you have 100 columns there. Are you going to manually create 100 variables? 

2. The other example, calling stored procedure in OLE DB source can often confuse SSIS. One way to solve it is to use with result sets clause. There you have to provide the column name and data type.  In my case, query is from a variable. Therefore, it also has SSIS expression, such as double quotation and "\n" for line change.

<img src="/images/blog10/exampl2.PNG" >  








