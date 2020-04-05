---
layout: post
title: Novel Way to Send HTML Table Formatted Email Via SSIS
---

The send mail task in SSIS can handle regular email just fine.  But when requirements ask you to send an html email, it won’t work. 
There are two ways that you can html.  
1.	Use sp_send_dbmail.   
It is not working by default, You will need the certain permission to work on the Database mail configuration wizard  in SQL server.  Once you are able to send email via SQL server, the next step,  use execute SQL task to send email. You can find the configuration in the following link. This is by far the simpliest solution.  

<https://blog.sqlauthority.com/2008/08/23/sql-server-2008-configure-database-mail-send-email-from-sql-database/>

2.	Use script task  
However, Not all ETL developer has the permission. Alternative way is to use the script task, certain .NET library will be needed to accomplish the same.

We will discuss the second scenario.  

In our day to day BI practice,  you are often asked to send out data in table format via your email.  These data are from your database. The number of records varies depending on when you run the query. 

There are quite a few articles online about sending html table email via SSIS.  But majority of them handle the table html code in the script task, which make the code very lengthy if there are multiple columns [link](https://social.msdn.microsoft.com/Forums/sqlserver/en-US/effa3050-6b40-4157-b299-ea6fdb39d9b7/html-table-formatted-email-using-ssis-script-task?forum=sqlintegrationservices).  

Therefore, I am wondering if we can modularize the process. 
*	Using SQL server XQuery to create table html code in execute SQL task, then pass the value to SSIS variable as email body  
* Use script task to take the variable value and send the html email  
* Explore the possibility of conditional formatting in email  

As usual, we use a simple example to show concept .
I first created a fake table  and inserted some data for demo purpose. 

