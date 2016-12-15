---
layout: post
title: Workaround for "There is already an object named xxxx error" in T-SQL
---


I have been using temp table a lot while writing long SQL script and stored procedures. Compared with CTE or table variable, temp table saves data in tempdb. So, you can retrieve data as long as you do not close the session. 
That is very convenient if you want to track data change and do some trouble shooting.

I came across one issue the other day. Requirements asked to pull different data depend on the parameter. I need to keep the table the same name so I can avoid changes for downstream code.

This typically require us to use branch logic (if else). After I wrote the script below, it pops up an error, indicating SQL Server think there are multiple objects using the same name. It seems to me that SQL Server think the table will be used more than once, although logically it is impossible.

Here I use adventureworks database to replicate the error.

<img src="/images/already_an_object_error.JPG" alt="error info">

I googled this error online. There are some discussion on stack overflow as follows. Some indicated this is a SQL Server parser error.  

 <http://stackoverflow.com/questions/4245444/there-is-already-an-object-named-columntable-in-the-database>

Here is a work around, which I use it to resolve the issue

<img src="/images/already_an_object_fix.JPG" alt="error fix">

I later found this solution is similar to what SharpC offered.  But the first step which we copy the table shell is different. 

Next time, when you came across this, you might try it out. 

Happy coding.


<a href="Files/blog1.zip">download code here</a>

