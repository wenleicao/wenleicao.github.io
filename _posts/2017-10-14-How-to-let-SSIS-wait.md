---
layout: post
title: How to let SSIS wait to certain time point 
---

We had a SSIS ETL package which populates the report and dashboard for daily EDI status monitoring. This ETL process runs daily.  Since it loads thousands and millions record, the final load to fact table need truncate a fact table and load about 30 min to 1 hour. This could take report offline for this amount of time and therefore interfere report user experience. The request is to delay loading till night. 
If you have used BO Data service, there is a built-in function, called sleep function.  But in SSIS, there are no such tasks. I did a little research online.  You can do it through execute sql task, script task using VB.net or C#, or using for loop. 

Sherry Li has a good blog on this topic   
<https://bisherryli.com/2012/03/10/ssis-109-wait-for-data-with-for-loop-container/>

Most SSIS developer has T-SQL background.  Therefore, it is familiar for them to use execute sql task to handle this scenario.  Sherry also had a T SQL script to let task wait for certain time point to process. 
In my case, things are slightly different.  I need to delay to night load, it is likely, if something happen in the day, and the real loading time could be likely happening past midnight.  Since Sherry only compare the time portion, I will have to modify it. 

Let us say, we want the loading happens at 10PM
The goal is  even if it is pass the midnight, it can still handle it correctly. The following is the logic.
If current time is already pass "package start day": 10PM, we don’t wait and go ahead to load it.
Else  we wait certain amount time until 10PM to load


