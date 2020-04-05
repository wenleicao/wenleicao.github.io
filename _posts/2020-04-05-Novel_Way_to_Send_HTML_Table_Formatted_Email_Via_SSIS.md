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
However, Not all ETL developer has the permission. Alternative way is to use the script task, certain .NET library will be needed to accomplish the same . 
