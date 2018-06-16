---
layout: post
title: Power BI Dashboard User Side Filter Issue
---

I was asked two questions about Power BI recently. 
Q1.  For a given dashboard, how user can filter data at his/her will?
Q2. How user can keep his/her default filter?

Q1. For first question, visualization pane has slicer, you can bring in one slicer or multiple slicer to the dashboard. User can choose filter value as you like. I use the student-class example in previous post to illustrate that.

This is unfiltered dashboard  
<img src="/images/blog19/unfiltered.PNG">  

I add a slicer and drag in the studentname filter in the slicer. From the slicer, I choose Mary. As you can see, the dashboard has been filtered in Mary data only.   
<img src="/images/blog19/add_slice.PNG">  

You can actually add multiple slicer in the same dashboard. For example, you can add another slicer and drag in classname,  and choose Science. Then the dashboard will only filter in Mary and Science data.  

Q1 is not difficult, how about Q2?   
In old SSRS school, we have different parameter for the report, you can set default parameter value. However, Power BI dashboard's parameters are more helping developer to dynamically load data to model than helping user. When dashboard is published, the parameter value cannot be changed. Please check the following blog for the difference.    
<https://www.mssqltips.com/sqlservertip/4475/using-parameters-in-power-bi/>

In addition, if there are multiple users for the same dashboard, all of them want to have their own default filter value. What are you going to do? 
You can publish customerized dashboard with specific filter for each user.  That is a solution.  But you will have many dashboards to maintain. That is a not good solution. 

Here is a better way to do it, although it is not perfect yet. 

Adam described a way called URL string parameter to help address the default filter issue.  
<https://powerbi.microsoft.com/en-us/blog/filter-a-report-with-a-url-query-string-parameter/>  

When you publish to Power BI site, you first see your work in the report section. You need to pin it to dashboard to share.  

VERY IMPORTANT, you need to click the visual in your report section and copy the link in the broswer address line to get the link. it is not dashboard link you shared with your colleague after you pin it to dashboard. To tell the difference, the correct address should have "reportsection" in it. The following is my report address.  

<https://app.powerbi.com/groups/me/reports/c4c5004b-31d0-4330-8cad-de0fb8f71563/ReportSection>

The following is from Adam's post

"Filters can be added to the query string of a report UR using the following syntax. This is based on OData $filter syntax. Only a string compare is available using eq, however.

?filter=Table/Field eq 'value'
  
There are a couple of things to be aware of when using this.  
1.Field type has to be string  
2.Table and field names cannot have any spaces  
3.Table and field names are case sensitive. The value is not  
4.Fields that are hidden from report view can still be filtered  
5.Value has to be enclosed with single quotes  
6.The field does not need to be present in the Filters pane. It can be used on any table/field within the model."  

if we can use one dashboard source and change the dashboard filter URL, we can have different URL for different user. If the dashboard need to updated, we just need to update one dashboard. That is good for version control and maintenance.  Let us see if this works on our dashboard. 

if we want to filter in only Mary
<https://app.powerbi.com/groups/me/reports/c4c5004b-31d0-4330-8cad-de0fb8f71563/ReportSection?filter=student/StudentName eq 'Mary'>  

click the link I get   
<img src="/images/blog19/filtered.PNG">  

if we want to filter student for Mary and class for math
<https://app.powerbi.com/groups/me/reports/c4c5004b-31d0-4330-8cad-de0fb8f71563/ReportSection?filter=student/StudentName eq 'Mary' and class/ClassName eq 'Math'>  

click the link I get  
<img src="/images/blog19/filterbymultiplecolumn.PNG">   


Apparently, it does work for above purpose including multiple columns. just out of curiosity, I tried to filter in both Mary and John by the following using OR logic operator  
<https://app.powerbi.com/groups/me/reports/c4c5004b-31d0-4330-8cad-de0fb8f71563/ReportSection?filter=student/StudentName eq 'Mary' or student/StudentName eq 'John'>  

click the link, I get the dashboard containing John, Lisa and Mary. So, it actually does not work on OR logic. Therefore, it work for some situation but not all

Now the next question comes. let us say, you have 100 different default filter setting for 100 users. some have one filter, some have multiple filter. How will you manage it?  













