---
layout: post
title: How to let SSIS wait to certain time point 
---

We had a SSIS ETL package which populates the report and dashboard for daily EDI status monitoring. This ETL process runs daily.  Since it loads thousands and millions record, the final load to fact table need truncate and load about 30 min to 1 hour. This could take report offline for this amount of time and therefore could interfere report user experience. The request is to delay loading till night. 
If you have used BO Data service, there is a built-in function, called sleep function.  But in SSIS, there are no such tasks. I did a little research online.  You can do it through either execute sql task, or script task using VB.net or C#, or using for loop. 

Sherry Li has a good blog on this topic   
<https://bisherryli.com/2012/03/10/ssis-109-wait-for-data-with-for-loop-container/>

Most SSIS developer has T-SQL background.  Therefore, it is familiar for them to use execute sql task to handle this scenario.  Sherry also had a T SQL script to let task wait for certain time point to process. 

In my case, however, things are slightly different.  I need to delay to night load, it is likely, if something happen in the day, and the real loading time could be likely happening past midnight.  Since Sherry only compare the time portion not day portion, I will need to take care of what if package run through midnight, therefore I have to modify it. 

Let us say, we want the loading happens at 10PM  
The goal is even if it pass the midnight, it can still handle it correctly. The following is the logic.  
If current time is already pass "package start day": 10PM, we don’t wait and go ahead to load it.  
Else we wait certain amount time until 10PM to load  

We first write this logic in SQL Server Management Studio (SSMS). 



As you can see, I have created some variables. We need a variable to set the certain time point that you would like loading happens. Because the waitfor delay statement need time format as "hour:min:sec", we need to use another variable and convert function to convert time difference to this format. The last four line, implement the delay loading logic. I ran part of script, so that you can see the variable value. 

I tested the script in SSMS. it worked. Now, let us move it into SSIS Package.  

A string SSIS variable is created to hold the T SQL script.  Please note, I replaced the first getdate() with system variable [system::start time]. That way, even if we ran package through the midnight, it always gives you correct time calculation. Keep the second getdate(), it will give you current time. Please also double check by clicking the evaluate expression. You need to add additional single quotation mark to date, since in SSIS it pass date variable without single quotation mark. You can see I highlighted in the SSIS expression the single quotation mark I added. Also, system thought what I passed in is string, so I need to cast it to datetime explicitly.

<img src="/images/blog12/edit_ssis_expression.PNG" >

Next step, you can drag in an execute SQL task and in SQL source type, choose variable type and in source variable, choose variable we just created in the last step. 

<img src="/images/blog12/delay_loading_setting.PNG" >

Now you can do a test.  Let us say you are at 2:08PM now (14:08), you can change variable part
set @delaydatetime = convert(datetime, @date + ' 22:00:00', 101)  
to   
set @delaydatetime = convert(datetime, @date + ' 14:00:00', 101)  
run it, it should have no wait  

then change it to   
set @delaydatetime = convert(datetime, @date + ' 14:10:00', 101)  
it should wait until 14:10

<img src="/images/blog12/waiting.PNG" >  

<img src="/images/blog12/process_result.PNG" >  

Once everything is tested,  
you can change it to the time point you desired, then add it to the place in your package. 

<img src="/images/blog12/ssis component.PNG" >  

Attached is the T-SQL code for delay loading

<a href="/Files/delay_loading_script.sql">download code here</a>

As always, happy coding!












