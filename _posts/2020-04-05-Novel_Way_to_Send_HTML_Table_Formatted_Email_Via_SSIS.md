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
*	Using SQL server For XML Path clause to create table html code in execute SQL task, then pass the value to SSIS variable as email body  
* Use script task to take the variable value and send the html email  
* Explore the possibility of conditional formatting in email  

As usual, we use a simple example to show concept .
I first created a fake table  and inserted some data for demo purpose. 

<img src="/images/blog35/table_prep.PNG">   
          
As you see,  we have some students with two courses and scores.   
Let us say, we want to send score for one course in table format.  If score is F, we shaded it in red; if score is C, we shaded it in yellow.  
Let us first see, how we can create html with help of For XML Path clause.  

<img src="/images/blog35/code_analysis_sc1.PNG">  
          
Row3 and row6, we initialized two variable,  one is course, the other is emailbody, which will be holding the html info.  We assign course value.  
Row8 and row13, we get all corresponding records which equal to the course variable.  
Row17 and row23,  we use XML Path to created a structure as follows .  Please note, you need ‘’ between each  td to make the query work. It will form the following structures for each row.  
<tr>
<td> column1</td>
<td> column2</td>
…
</tr>

It is still not completed for a html code, but we have done the most difficult part.  Now we need to add header and footer to make it complete.  

<img src="/images/blog35/code_analysis_sc2.PNG">    
          


