---
layout: post
title: Utilize Nested Foreach Loop in SSIS
---

If we are going to collect metadata about tabular model, the most straightforward way is to use the Dynamic Management Views ( DMV ) to query the model in DAX or MDX query window.  Notice here DMV is not department of motor vehicle :).  

This link has a good collection of DMV, but there are some queries not working which might need a bit of tweaking.  If you are familiar with SQL, it should not be a difficult task.  

<https://bennyaustin.com/2011/03/01/ssas-dmv-queries-cube-metadata/>

What if I tell you, the requirement needs to get all model/cube’s metadata instead of one in that particular server?  

There are two ways you can do it.   
1.	First running the following dmv to get the list of model into object variable. Then in a foreach loop to loop through each model to get metadata.   
select [CATALOG_NAME] from $system.dbschema_catalogs   

2.	More elegant way is to take use of built-in loop. There is a rarely used loop type in foreach loop,  SSIS Foreach ADO.NET Schema Rowset Enumerator.  You can loop through object of sql server such as view, table, catlog et al. The following link has an intro.  

<https://www.tutorialgateway.org/ssis-foreach-ado-net-schema-rowset-enumerator/>

What if there are multiple servers, we want to get all models' metadata in each server.  Can I still do foreach loop?  Think about add another loop outside?
Outer loop goes through one server at a time, inner loop goes through the model on that particular server (second method above).  But the key is how to dynamically pass the connection between different loops.  I am not sure if this will work, but I gave a try. Luckily, I made it work.

 Let me show you the key setting  
 
 this is overall component of package. The first two task is used to save old data and truncate table to be ready for new data. The third excute sql task is use to get a list of server info. You can put all your server into a table so that you can add or remove as needed. the nested ForEach loop is to extract data   
  
<img src="/images/blog33/overall.PNG">

let us take a look at the 3rd task setting. Here I got a list of server info and saved into an object variable. Notice full result set will be saved  

<img src="/images/blog33/get_list_server1.PNG">  

detailed query info to get three pieces of info,  servername, serverid, initial cube/model name  

<img src="/images/blog33/get_list_server.PNG">  

save result to an object variable  

<img src="/images/blog33/get_list_server2.PNG">  

