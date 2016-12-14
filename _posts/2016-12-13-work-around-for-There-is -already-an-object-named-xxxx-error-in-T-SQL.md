
---
layout: post
title: work around for There is already an object named xxxx error in T-SQL
---


I have been using temp table a lot while writing long SQL script and stored procedures. Compared with CTE or table variable, temp table saves data in tempdb. So, you can retrieve data as long as you do not close the session. 
That is very convinient if you want to track data change and do some trouble shooting.



