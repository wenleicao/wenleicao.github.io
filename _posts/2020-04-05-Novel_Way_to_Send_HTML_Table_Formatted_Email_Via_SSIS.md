---
layout: post
title: Novel Way to Send HTML Table Formatted Email Via SSIS
---

The send mail task in SSIS can handle regular email just fine.  But when requirements ask you to send an html email, it won’t work. 
There are two ways that you can html.  
1. Use sp_send_dbmail.   
It is not working by default, You will need certain permissions to work on the Database mail configuration wizard  in SQL server.  Once you are able to send email via SQL server, the next step,  use execute SQL task to send email. You can find the configuration in the following link. This is by far the simpliest solution.  

<https://blog.sqlauthority.com/2008/08/23/sql-server-2008-configure-database-mail-send-email-from-sql-database/>

2. Use script task  
However, Not all ETL developer has the permission. An alternative way is to use the script task, certain .NET library will be needed to accomplish the task.

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
Row17 and row23,  we use XML Path to created a structure as follows .  Please note, you need '' between each  td to make the query work. It will form the following structures for each row.    

<img src="/images/blog35/html_structure.PNG">

It is still not completed for a html code, but we have done the most difficult part.  Now we need to add header and footer to make it complete.  

<img src="/images/blog35/code_analysis_sc2.PNG">    

Row26 and row31 add header and footer and assign to emailbody. This html code is completed.  

Now if we run this SQL script and copy the result to notepad, you can save it as html file. And then you can open it with Chrome. You will see this.  

<img src="/images/blog35/open_by_chrome.PNG">   

We can preview email this way, this indicated the html should work fine.  Now can we conditionally format it?  I did some experiments on the html.  

<img src="/images/blog35/conditional_formatting_red1.PNG">   

If I add additional attribute to F element.  Save and reopen it. I will see the follows  

<img src="/images/blog35/conditional_formatting_red2.PNG"> 

This indicates that if we can implement the same thing  in our SQL query, we should be able to do conditional formatting. 

I did some research and it works. The syntax is a bit counterintuitive, but you will have to add a statement before the score element. As you see between row 23 and 24, I use case statement to assigned red and yellow  background attribute value.  Notice, td/@style  means add this under td, and style is attribute name.  

<img src="/images/blog35/conditional_formatting.PNG">  

Once I run the script and copy paste to a online html formatter.  I can see the followings.  

<img src="/images/blog35/check_html.PNG">  

You can see that the style attribute has been added based on the score value. If I use chrome to take a look, it is as follows.  This is expected.  

<img src="/images/blog35/conditional_formatting_red3.PNG">  

Now that we have the code correct.  We need to able to pass it SSIS.  
I decide to pass the html code as string. Therefore, I first change the script to stored procedure. Notice the @emailbody is output param.  At the last step of sp, I assign the html code to @emailbody  

<img src="/images/blog35/create_sp.PNG">  

Let us switch to SSIS and we create a new package. 

1. Add one execute SQL task and one script task. Connect these two tasks 

<img src="/images/blog35/SSIS_setup.PNG">  

2. Create two connections,  one is OLE DB connection where you stored procedure resides. The other is SMTP Connection Manager, which you will use to send email.  

3. Create a couple of variables as the follows.  Course value will be passed in stored procedure, emailbody will hold the return html code.  Others will be used in send email in script task  

<img src="/images/blog35/SSIS_variable.PNG">   

4. Configure the execute SQL task

<img src="/images/blog35/execute_sql_setting1.PNG">  

Choose the OLE DB connection, exec the stored procedure.  Please note the quirky format. You need to add output since 2nd parameter is return by stored procedure.  

In parameter mapping,  you need to add variable based on param sequence in stored procedure. Also notice, the direction is output for @emailbody.  

<img src="/images/blog35/execute_sql_setting2.PNG">  

5. configure the connection between execute SQL task and script task, you can add the following condition so that if the query result is empty, it will not shoot the empty email. 

<img src="/images/blog35/prevent_empty_email.PNG">  

6. configure the script task, add emailbody and all email related variable as follows. Click edit script

<img src="/images/blog35/script_setting1.PNG">  

In the script window,  we need to import a  library .  This is C# code.

<img src="/images/blog35/add_library.PNG">  

In the script body,   
Between row 96 to row 99: get the value from SSIS.  
Row 103: get smtp server property  
Row 106 to 107  pass all email variable to create a new mailmeassage object. Active email html property.  
Row 110 to Row 112, create smtpclient object and send email out.

<img src="/images/blog35/script_setting2.PNG">  

Once done. Let us run package and see.  
When variable course is Data Science Intro.  I receive this.  

<img src="/images/blog35/email.PNG">  

When it is algorithm   

<img src="/images/blog35/email2.PNG">  

When you change it to English. It will not send email because there is no query record. The len(emailbody) =0  

<img src="/images/blog35/email3.PNG">  

This method has following advantages.   
This method modularized the html creation and email send step. Which is clear to follow and troubleshooting. 
Use For XML Path to generate html code, which avoid lengthy C#  code.  Let SQL server to do heavy lifting.   
Able to conditional formatting the table.   

I hope you feel this post is helpful
All script include SQL and C# can be downloaded <a href="/Files/blog35_code.zip">here</a>.  
Keep safe

Wenlei
