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

VERY IMPORTANT, you need to click the visual in your report section and copy the link in the browser address line to get the link. It is not dashboard link you shared with your colleague after you pin it to dashboard. To tell the difference, the correct address should have "reportsection" in it. The following is my report address.  

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

If we can use one dashboard source and change the dashboard filter URL, we can have different URL for different user. If the dashboard need to updated, we just need to update one dashboard. That is good for version control and maintenance.  Let us see if this works on our dashboard. 

If we want to filter in only Mary  
<https://app.powerbi.com/groups/me/reports/c4c5004b-31d0-4330-8cad-de0fb8f71563/ReportSection?filter=student/StudentName eq 'Mary'>  

Click the link I get   
<img src="/images/blog19/filtered.PNG">  

If we want to filter student for Mary and class for math  
<https://app.powerbi.com/groups/me/reports/c4c5004b-31d0-4330-8cad-de0fb8f71563/ReportSection?filter=student/StudentName eq 'Mary' and class/ClassName eq 'Math'>  

Click the link I get  
<img src="/images/blog19/filterbymultiplecolumn.PNG">   


Apparently, it does work for above purpose including multiple columns. Just out of curiosity, I tried to filter in both Mary and John by the following using OR logic operator  
<https://app.powerbi.com/groups/me/reports/c4c5004b-31d0-4330-8cad-de0fb8f71563/ReportSection?filter=student/StudentName eq 'Mary' or student/StudentName eq 'John'>  

Click the link, I get the dashboard containing John, Lisa and Mary. So, it actually does not work on OR logic. Therefore, it work for some situation but not all

Now the next question comes. Let us say, you have 20 different default filter setting for 20 users. some have one filter, some have multiple filter. How will you manage it?  

Angry Analytics has a blog about using window flow to deliver hyperlink with filter embedded to user. 
<https://angryanalyticsblog.azurewebsites.net/index.php/2017/11/13/data-driven-subscriptions-in-power-bi/>  

It is a good GUI tool if you have this paid app in your office 365 suite (in the example, it only show single filter. I am not positive if it can handle multiple filters). Unfortunately, we don't have this tool. The next thing, I can think is SSIS. If you have worked with SSIS, you can draw all filter setting from database table into an object variable. then in a foreach loop container, use Foreach ADO enumerator to read one row of object at a time. Pass the parameter to form a hyperlink string, then send it using send email task. However, not all report developers are SSIS savvy. But most powerBI developer, I believe, understand T SQL.  Here I am showing how to use script to handle single filter and multiple filter as well as send dashboard link out using dbmail stored procedure all within SSMS.


First we want to know if we are able to send hard coded dashboard link out via SSMS.
You need to set up dbmail following the following link if you have not yet        
<https://blog.sqlauthority.com/2008/08/23/sql-server-2008-configure-database-mail-send-email-from-sql-database/>   
after that, I try to execute the following code(change to msdb database first). Please notice: I use a fake email to replace my real email.

USE msdb  
 GO  

EXEC sp_send_dbmail @profile_name='BeaconETL',  
@recipients='wenlei.cao@example.com',  
@subject='Power BI Dashboard is ready',  
@body='please click the following link  
<https://app.powerbi.com/groups/me/reports/c4c5004b-31d0-4330-8cad-de0fb8f71563/ReportSection?filter=student/StudentName eq ''Mary''>'  

Soon, I received email. I clicked the link, it brought me to the dashboard. The dashboard works fine.      

<img src="/images/blog19/email.PNG">  


Now, we can create a table to save user filter info and insert the info   
I use two user, one has single default filter, the other has multiple default filter.   
<img src="/images/blog19/ddl.PNG">   

This is what we have in the table  
<img src="/images/blog19/configuretable.PNG">  

OK, we have info we need to build email string. Notice John Doe have two filters for the Dashboard. 
What we want is to go through every row, send out an email based on the info in one row.  John Doe has two row of info, it need to combine into one row.  To do that, I using the following code. 

step 1. Create group for each filter set, mark the param1 and param2 if they have more than 1 param. Also combined table, column and value as filter. Notice I add quotation mark on left side, but leave it blank on the right.  That is because I need to add second filter if it has. at the last step, I will add right quotation mark.  
<img src="/images/blog19/step1.PNG"> 

step 2. Pivot the value of of filter. Notice 3 row in step 1 became 2 row. That is because I use the grouping column and you also see the filter is combined in the format of URL string filter 
<img src="/images/blog19/step2.PNG"> 

step 3.  I created cursor. Store the filter info the cursor and read one row at a time to assign variable value. Those variable will be used to build the string for execute sp_send_dbmail. I use print function to print it out. So we can check if it has syntax error. We can copy it out and execute to test. If no issue, we can safely use dynamic SQL to execute it.
<img src="/images/blog19/step3.PNG"> 


In summary, URL parameter filter can apply preset filter to Power BI dashboard. It can take multiple column filter. But it cannot handle more complicated logic, such as 'OR'. 

We can use configuration table to keep filter info, and use script and sp_send_dbmail to deliver the dashboard to user ad hoc or we can schedule a job to run the script in SQL agent.  Please note, I use up to 2 filter set. This is a prototype. We can use more filter set. Only thing to do is to modify the step 2 script (add param3, param4, ...).  

Please download <a href="/Files/blog19_script.zip">code</a> here

Thank you.

Wenlei
