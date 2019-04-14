---
layout: post
title: Extract Active Directory User info via PowerShell 
---

A few month ago, I was asked to get meta-data who is accessing our Power BI (PBI) dashboard.  Besides PBI audit log, we would like to understand more about user behavior so that we can improve power BI report. PBI service now can add AD group to manage permission as opposed to office 365 group, so it is much more efficient now in my opinion. Much of the user info also can extract from AD group. The easiest way is using powershell.   

(**Please note:** This process is related with some user info, I shaded it with black to protect privacy, but code should run without issue )  

Use powershell to get an all user info from one  AD group  

