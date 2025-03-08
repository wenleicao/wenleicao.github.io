---
layout: post
title: Schedule Job on Business Day?
---

Recently, we are operationalizing a ML project, which requires us to run model prediction on the first business day of each month. These requirements are from accounting because they want to make sure previous month data is complete and there will be someone to help on business day should something happen.
We used to utilize a batch file to run python with the task scheduler in Windows OS. Unfortunately, the task scheduler did not offer a business day option. This poses a challenge for us.  

As always, I did some research online. Nowadays, AI is such a buzz word, Google even offered AI summary above all search results, which I believe powered by Gemini.  Let us see if that helps.  

Here comes search results.  
<img src="/images/blog64/google_search1.png">  

Well, when I followed the AI solution, clearly you cannot find "new calendar" button anywhere in the task scheduler. 
<img src="/images/blog64/google_search2.png">  

When I trace the reference Gemini used, it actually got those from Microsoft project scheduler. Please check the following link. It talked about new calendar   

[Schedule Tasks to Occur on the First Working Day of Each Month](https://mpug.com/schedule-tasks-to-occur-on-the-first-working-day-of-each-month/#:~:text=following%20additional%20steps:-,1.,day%20of%20the%20next%20month)  

Obviously, AI made a mistake, which was mixing different task schedulers. So, be aware of those AI outputs and use them critically.
After some research, this is my action plan. 
1.	Using powershell to identify a given day if it is business day
2.	If business day, run job, else exit
3.	Schedule at least first 4 days  (in the worst scenario like Jan 1st falls on Friday, I have to run job next Monday)
4.	Need to have a mechanism to check if previous day already run, if so, skip for rest to save resource
5.	powershell needs to take param passed from task scheduler 

With this plan, this is my powershell code.
<img src="/images/blog64/powershell1.png">    

Define a param that will be passed from task scheduler to script. I will need to run in a dev or prod environment. Default value set as dev. This helps test the script easily.  

I have the 1st function to identify isHoliday which I copied from the following solution
[powershell - How can I check to see if today is a holiday](https://stackoverflow.com/questions/58051013/how-can-i-check-to-see-if-today-is-a-holiday)  

I also need to check if a given day is weekend, which was coded between row 23 and 28.  Initially, I used the string values "business day" and "not business day". But I found using 1 or 0, making comparison easier later. 

<img src="/images/blog64/powershell2.png">  

Next at row 34. I set the default file path as the current powershell script folder.  Please don’t use cmdlet  Get-Location, this will give you powershell application location.  
At row 35, I activate a conda environment for my project.  
Row 40, get current date  
Row 42 to Row 48, implement the logic that script only runs on business day.  At row 43, I run my python job with the passed-in env param.   

This is how I set up the job at task scheduler for running the powershell script.  
<img src="/images/blog64/trigger.PNG">  

Notice, I run monthly schedule. First 4 days were selected.  

<img src="/images/blog64/action.PNG">  

In the action tab, I use powershell as the program run the script.  In the argument, the following is full text.  
-ExecutionPolicy Bypass -file "C:\yourfilepath\run.ps1" -env "dev" 
I set ExecutinoPolicy as Bypass to avoid permission issues,   file param tells the location of your file.  env param value is  dev.  When you are ready, you can change it to prod.  

I hope this post will help you work with powershell script scheduling. it is a bit different from batch file. 

The powershell script can be found [here](/Files/blog64_run.ps1)

thanks, Happy International Women's Day.

Wenlei


