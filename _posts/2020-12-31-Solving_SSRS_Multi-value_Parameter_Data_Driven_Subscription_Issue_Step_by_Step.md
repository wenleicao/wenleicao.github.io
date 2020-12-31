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

### Let us first make some dummy data for this testing purpose.  

Create a view to hold the data.  

<img src="/images/blog40/create_data_set.PNG">  

<img src="/images/blog40/dataset.PNG">  

We have teachers, students and score.  Let us assume the report is using course as only param to show one or more courses and other info (you can use teacher course cascading param, but in this case, I intentionally use only course param as first param, forcing us to use multiple values for this param). Notice that prof. alpha teaches two courses, course1 and course2.  We would like to send him email with both courses in one email instead of two emails. This will need to provide >1 parameter value to report when scheduling the DDS.

### Let us first make ssrs report work   

Create course dataset like so  

<img src="/images/blog40/course_dataset.PNG">   

Then create a parameter, configure like this, notice allow multi value is checked   

<img src="/images/blog40/course_param.PNG">   

Available values  

<img src="/images/blog40/course_available_value.PNG">  

For main report dataset  

<img src="/images/blog40/studentscore_main_dataset.PNG">  

You can see the specific syntax when using multiple value params.

Let us run the report. It allows you to select param values.  

<img src="/images/blog40/select_multple_value.PNG">  

If we choose 3 courses  

<img src="/images/blog40/select_three_course.PNG"> 

It does what it is supposed to do.  Let us see whether it works on the data driven subscription.  

Create dataset for DDS  

<img src="/images/blog40/first_dds.PNG"> 

Use course column for course param.  Notice I use testemail to send it to myself.

<img src="/images/blog40/notworking_setting.PNG">  

Run result, one process has error, which is a comma-separated string. Passing combined strings won’t work.  

<img src="/images/blog40/not_workign.PNG">  

### Let us see if we can fix it.  

We add a hidden param, which is TeacherSwitch, works as a switch. If teacher = all, we select all teachers,   if teacher = prof. alpha, we only select prof. alpha course  

<img src="/images/blog40/add_hidden_param.PNG">   

<img src="/images/blog40/hidden_available.PNG">  

In this case, I default it as all value to include all courses.  

<img src="/images/blog40/hidden_default.PNG">  

Create a dataset, so that course will have default value from the dataset.  Notice here, if hidden pararm  TeacherSwitch = All,  I will have teacher = teacher, this will be always true. Therefore include all record, otherwise, it will be filtered by the passed in teacherswitch variable.  

<img src="/images/blog40/course_default.PNG">  

Set the course default value from this dataset.  

<img src="/images/blog40/default_setting.PNG">  

Let us give a run. It will automatically run with all courses. But you can modify it to only select a subset of course if you like in the second run.  

<img src="/images/blog40/course_default_run.PNG">  

Now let us see how we do with DDS.   

<img src="/images/blog40/teacher.PNG">  

In this case, we set it like this, course using default values, we have 3 rows in DDS dataset.  

<img src="/images/blog40/workign.PNG">  

DDS param setting   
<img src="/images/blog40/dds_working_param.PNG">  

DDS run, all successful.   

Let us see if prof. alpha has luck to receive all his scores in attached Excel file. Yes, indeed it is all in one email with 2 courses.  

<img src="/images/blog40/Capture_working.PNG">  

When I test it, I set it to use testemail, which points to my email address. Now everything is set to go, you just need to switch to teacheremail. You are all set.  

This POC shows that we can add a hidden param to solve the first param multi-value DDS issue.  This does need to set a default value to the first param, but it avoids providing the value on the fly (which is not possible by the way).  It did not cause much inconvenience, just need to select different values if you want to run different parameter sets.   
Sql code and both working and non-working SSRS included <a href="/Files/blog40.zip">here</a>.  Personal info was changed to protect privacy.  

I hope this is helpful to help you avoid the hassle of setting up tons of regular subscriptions, which is very hard to manage and maintain for lazy/smart yet productive developers.  

Happy New Year!

Wenlei
