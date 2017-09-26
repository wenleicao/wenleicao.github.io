---
layout: post
title: What if you need to add a large SSIS package to an existing solution 
---

We had a very large ETL project for enterprise data warehouse. I am also on another project that developing a ETL solution for a relatively independent business problem. So, it was designed separately with the data warehouse. But recently, decision has been made we need to integrate these two together. 

When I added the package to data warehouse, problem arose. Here I use adventureworks as example to demo issue. I have a project1, which contains package1. For demo purpose, I just created 3 data flows, but you can think it contains many more data flows.  

<img src="/images/blog11/package1.PNG" >

Now, I need to add a developed package into this project, package2 contains many data flow. It shares some connections with package1. But when you copy the package in, you find there are a lot of errors. 

<img src="/images/blog11/Error_list.PNG" >

Notice, there are 90 errors. Most are connecting errors. The reason why this happens is because when you create a connection in SSIS, it will assign a unique GUID to the connection even though they have same definition. When you add one package into new project, SSIS sometimes detect the same connection, so it will not copy the connection in (as in this case). Or it will copy in connection, making it a redundant connections. 

If you only have limited components in your package, you can go through each component and reconfigure the connection. But there are 90 errors, it won't be a pleasant job.

There are better ways to handle this situation. First, we need to collect the connection id for both package  

<img src="/images/blog11/FindAW_connection_id.PNG" >

Right click the connection and select property and copy the id value to notepad, like the following  

<img src="/images/blog11/connectionID.PNG" >

Now, we need to switch package2 connection to the package1 connection, ie project1 connection.
Right click package2, choose view code, it will open a xml code page  

<img src="/images/blog11/view_code.PNG" >

Now that you are at the xml code page, press ctr + F, replace the existing package2 connection with package1 connection.  

<img src="/images/blog11/replaceID.PNG" >

Save the xml changes. Repeat the process until you replacing all the corresponding connections.  

You save the xml, SSIS file will be automatically saved. The error will probably still there, you need to close the package window and reopen it to see effect. 

<img src="/images/blog11/afterfix1.PNG" >

You see, 90 errors became 9 error.  Most are related with email connection. Simply copy the email connection over and save it. 
Now we only have 3 errors

<img src="/images/blog11/afterfix2.PNG" >

From the error, you notice there is a project parameter is not available. So, when we add package to a project, the original project parameter is not automatically brought over.  Maybe Microsoft need to improve this.

Manually adding project parameter MailTo, this fixed all errors. 

<img src="/images/blog11/final.PNG" >

Hope this makes your SSIS work a bit easier.

Wenlei


