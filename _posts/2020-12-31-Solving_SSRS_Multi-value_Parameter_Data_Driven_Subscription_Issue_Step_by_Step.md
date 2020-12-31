---
layout: post
title: Solving SSRS Multi-value Parameter Data Driven Subscription Issue Step by Step
---

Subscription is very important for report automation. When you a handful subscription, you might get by setting regular subscription for each one. When there are many subscriptions like over 10, it will be painful to set up and manage. Luckily, we have data driven subscription (DDS) to help, but DDS has an limitation for multi-value parameter. 
In regular subscription, system will provide parameter value and you can choose it.  DDS will get parameter value from a query. 

<img src="/images/blog40/multi_value.PNG">     

I have tried to use comma separated strings like courseA,courseB in data driven subscription setting.  It will simply run into error when subscription runs even if I use string split function at report level.   
 
 <img src="/images/blog40/comma_separate_string.PNG">     
 
This has been an issue for a long time since multiple parameter options are available, but Microsoft still did not fix it since the report expects multiple columns when there is multiple value for a given param based on this discussion.  
<https://social.msdn.microsoft.com/Forums/windows/en-US/b2c50aea-2032-4025-a155-306c00fcb856/how-to-pass-multivalue-parameters-to-dds-data-driven-subscription?forum=sqlreportingservices>   

There has been some work around for this issue.  Noticeably, someone has altered the report parameter to let them have default value. Therefore, when you choose a source of value from the above data driven subscription setting, you can use the option using default value.   Unfortunately, I cannot find a simple working example online to follow.   

I decide to design a simple experiment (or you can call POC in the business world) to prove it is working.   

### Let us first make some dummy data for this testing purpose.  Create a view to hold the data.  

<img src="/images/blog40/create_data_set.PNG">  

<img src="/images/blog40/dataset.PNG">  

We have teachers, students and score.  Let us assume the report is using course as only param to show one or more courses and other info (you can use teacher course cascading param, but in this case, I intentionally use only course param as first param, forcing us to use multiple values for this param). Notice that prof. alpha teaches two courses, course1 and course2.  We would like to send him email with both courses in one email instead of two emails. This will need to provide >1 parameter value to report when scheduling the DDS.

### Let us first make ssrs report work 
Create course dataset like so


 

