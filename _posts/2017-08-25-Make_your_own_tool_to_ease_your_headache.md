---
layout: post
title: String builder for BI developer
---

People create tool to make their job easier. Carpenters make wood jig.  Farmers are using spinning wheel for making cloth. 
As a BI developer, I came across many scenario that the job is tedious, but you have to be careful or the code won't work.

I give two examples in SSIS.  The following code are all T SQL code.
I have been using the method describing in the following blog to compared two big tables and do insert and update.  This method works great.
<http://sqlblog.net/2014/05/01/insert-and-update-records-with-a-ssis-etl-package/>
The update step is completed by OLE DB command task. This requires you pass in each column value of your incoming record as variables to update your existing record via a stored procedure.





