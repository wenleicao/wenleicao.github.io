---
layout: post
title: work around for There is already an object named xxxx error in T-SQL
---


I have been using temp table a lot while writing long SQL script and stored procedures. Compared with CTE or table variable, temp table saves data in tempdb. So, you can retrieve data as long as you do not close the session. 
That is very convinient if you want to track data change and do some trouble shooting.

I came across one issue the other day, requirements asked to pull different data depend on the parameter. I need to keep the table the same name so I can avoid changes for downstream code.

This typically require us to use branch logic (if else). after I wrote the script below, it pops up an error, indicating SQL Server think there are multiple objects using the same name. It seems to me that SQL Server think the talbe will be used more than once , although logically it is impossible.

 

 <http://stackoverflow.com/questions/4245444/there-is-already-an-object-named-columntable-in-the-database>

I tried to put 


