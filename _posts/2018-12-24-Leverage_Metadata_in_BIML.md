---
layout: post
title: Leverage metadata in BIML 
---

I have been working on SSIS for many years. I came across BIML in multiple occasions, such as reading reference, browsing BI topics…  BIML as a tool is used to massively create SSIS package and meta-data driven ETL solution.   
My view on BIML   
•	Good candidate project for BIML  
If your project is following certain pattern, such as moving multiple table data from one database to another (you can do it via script if it is between same types of database, but  would be harder between SQL server and Oracle for example).  In addition, it is much easier to maintain the big project using BIML.   
•	Not good candidate project:  small task with unique requirement   

BIML is built on top of XML.  Like HMTL, java script / ASP.Net can be embedded into it and make it more dynamic and more powerful; BIML script (based on C# / VB.Net) can embed in BIML to automate many time consuming or labor-intensive tasks (use loop and condition et al). 
There are tons of blogs and sites over the internet about BIML, but I feels it is hard to find good one for the beginner to follow and appreciate the merit of BIML.   
I like this simple talk one, which guides you through an example for importing data from flat files.   
<https://www.red-gate.com/simple-talk/sql/ssis/developing-metadata-design-patterns-biml/>  
One thing, I feels a bit cumbersome that we have to load flat file format header and detail into relational database to be able to use BIML to automate the process.  I understand that ETL needs those info to build the flat file data flow, but if we have to manually insert those, it is not automated in the first place.   
Imaging you have a folder containing bunch of flat files to be loaded, you can loop through it and automatically get the meta data and use for BIML, that would be wonderful.   
I have not seen a BIML extension /help class to do that.  But I think it is possible.  If you have used SAP data service. You know they will set up the different datastore for different type of data sources, one of them is flat file. You can see how it is set up in the following link.  It is pretty accurate in term of choosing data type based on my experience. Maybe BIML creator, Varigence, can build an extension for flat file metadata extraction.  
<https://blogs.sap.com/2013/01/14/data-transfer-from-flat-file-to-database/>  
If meta-data is easily available, BIML is very robust. I use the following BIML script as example (this example is between two different schemas in the same databases in SQL Server since it is readily available to me, but also the idea apply between different database or between different type of database such as SQL Server to Oracle)  
This script is based on Scott Currie’s post with some modification.  
<http://bimlscript.com/Walkthrough/Details/3118>  

<img src="/images/blog23/biml.PNG">  

If you read the code, you can tell even if you have not yet written any BIML code.   
First, create an array of table name. Next, define the connection for data source and data destination.  Here I marked the server name just to protect the privacy.  You can put in your actual server name and change the database name if you want to follow along.  Finally, use foreach to loop the table array to create two package which contains a data flow respectively for both tables.   
This is the solution explorer before I generate package.   

<img src="/images/blog23/solution_before_expansion.PNG">  

Now, after I right click bimlscript.biml and choose generate SSIS package. There are two more packages showing up.  

<img src="/images/blog23/solution_after_expansion.PNG">  

If I drilled down to see detail, I can see that the data flow has been configured and ready to run.    

<img src="/images/blog23/task.PNG">   

<img src="/images/blog23/task_detail.PNG">  

<img src="/images/blog23/task_detail2.png">   

Now I only included two tables in the array. It might not save much time. But what if there are 10 tables.  That will save you a lot of time.  For creating SSIS package massively, in Scott’s post, he showed using ImportDB method to retrieve meta-data from whole database. Actually, there are three main methods out there.  In this post, I will show you how to use the third method. 

1.	ImportTableNodes, limited to one schema   
2.	ImportDB   in a database but not limited to one schema  
3.	GetDatabaseSchema  

The first 2 methods are good if you want to import all table/view in one schema or one database. But if you want to pick a few from the table list, these two methods will not do. The third method, however, has more granularity of control to define a collection. You can define a collection of the schemas or tables, also you can have importoptions to exclude ID, foreign key, index et al.

<img src="/images/blog23/use_method_get_metadata.PNG">  

You define includedschema, includedtables, finally, you have meta-data stored in variable sourceconneciton.  When you retrieve the meta-data, you just need to loop through and use the meta data as before. Please note, the meta-data is in the property of TalbeNotes.  

<img src="/images/blog23/use_method_get_metadata2.PNG">    

The last step is generate the package, it is essentially the same. So, I will not show the pics. 

Up till now, you might say, there is no advantage this method VS table array. But if you want to include table creation before table loading. You will see the advantage.     

I added another task to help create the same table but in different schema. Here I can use getDropandCreateDDL method, which I don’t need to manually find the table DDL. In order to replace the original dbo schema to temp schema, I used replace function.  As you can see the generated package reflects what have been changed in the BIML. 

<img src="/images/blog23/add_another_task.PNG">   

<img src="/images/blog23/add_task1.PNG">     

<img src="/images/blog23/add_task2.PNG">   

Another question is about syntax of tasks.   
If you have BIML studio, you can drag in the task and look the BIML code. Then copy it to your edit window. What if you use the BIML express? This link give you some example (not all scenario though) that you can copy from.   
  
<https://varigence.com/Documentation>    

Hope this example helps you understand the power of BIML. It will take some time to digest.    
 
if you want to follow along, the biml can be download in the following link  
<a href="/Files/bimlscript.zip">download all example BIML here</a>  
 
Again, happy BI.  

Wenlei
