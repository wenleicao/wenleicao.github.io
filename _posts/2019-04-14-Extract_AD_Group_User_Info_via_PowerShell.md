---
layout: post
title: Extract Active Directory User info via PowerShell 
---

A few month ago, I was asked to get meta-data who is accessing our Power BI (PBI) dashboard.  Besides PBI audit log, we would like to understand more about user behavior so that we can improve power BI report. PBI service now can add Active Directory (AD) group to manage permission as opposed to office 365 group, so it is much more efficient now in my opinion. Much of the user info also can be extracted from AD group. The easiest way is using powershell.   

(**Please note:** This process is related with some user info, I shaded it with black to protect privacy, but code should run without issue )  

If you run into powershell error, please install the follow RSAT, before you run the cmdlet, detailed in this post  
<https://4sysops.com/wiki/how-to-install-the-powershell-active-directory-module/>

Use powershell to get an all user info from one  AD group  
<img src="/images/blog26/get-adgroup.png">   

if we know one user's id, we can get the detailed info like this. Use mine as example  
<img src="/images/blog26/get-aduser.png">  

We would like to extract manager info, so that we can do some parent child relationship analysis
<img src="/images/blog26/manager2.png">  

As you notice, manager property is a long string.  We need to convert it to surname, given name, which can be implement with nested get-aduser cmdlet like previous example.  But there are some exception due to inconsistency of old AD info vesus new AD info. I will detail that in the code review.  

I used Foreach loop in the code, so that it can run for different AD group.  The final result is output to csv. ETL process can follow or You can integrate the powershell in the excute process task in SSIS.  

Let me walk you through the PowerShell code. The code is in PowerShell ISE.  

<img src="/images/blog26/array_variable.PNG">  

Define two array variable, one hold AD group info, the other is for export   
I use two foreach loop here, the outer one loop through different ad group. The inner one is loop through each individual in a particular AD group.  
$manager_info use Expandproperty can convert the PS object to string to help downsteam string manipulation.

<img src="/images/blog26/try_catch.PNG">  

Notice: manager information is present as CN=xxxxx,OU=....,   $manager_info is string object, which has method indexof that can tell where ‘=’, ‘,’ is.  So we can use substring method to get xxxxx, which is the mangerid, this ID can be used as get-aduser param to get manager info. 

In case there is an error, for e.g., We can use .net function  [string]::IsNullOrEmpty  check if manager entry is null or empty; in some case, there is \ sign after the managerID, which need to trim to be able to continue.  

<img src="/images/blog26/export.PNG">  

Create an object, assign value to this object .  As you can see here, powershell is object oriented.  Then object is added to $outarray variable. In the end, this variable is to export to csv file.  

Now I can use the csv file to load to database and serer as user dimension in the star schema.  

Due to privacy, I will not include the export file. But the PS1 source code is available <a href="/Files/ad_group.ps1">here</a>.

Hope you feel this post is helpful.

Wenlei
