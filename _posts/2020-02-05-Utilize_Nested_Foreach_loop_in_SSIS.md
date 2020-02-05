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

* let us take a look at the 3rd task setting. Here I got a list of server info and saved into an object variable. Notice full result set will be saved  

<img src="/images/blog33/get_list_server1.PNG">  

detailed query info to get three pieces of info,  servername, serverid, initial cube/model name  

<img src="/images/blog33/get_list_server.PNG">  

save result to an object variable  

<img src="/images/blog33/get_list_server2.PNG">  


* Outer Foreach loop setting (this loop is used to loop through server list, provide server and inital database info to inner loop )  

This loop use the object variable. Enumerator is Foreach ADO Enumerator. it take a row in the object variable at a time.  

<img src="/images/blog33/outloop_setting1.PNG">  

one row in object variable contains 3 piece of info. These info are mapping to three variables.  Please note: here serverid is not necessary. it is only for my record in data flow. you just need servername nad model name to dynamically create connection.   

<img src="/images/blog33/outloop_setting2.PNG">   

* Inner Foreach loop setting  
this loop takes the servername and inital model name from outside loop, start loop through all models in a particular server
Notice the enumerator is ADO.NET Schema Rowset Enumerator
here we need to specify the connection used. I like to first create it hard code and then in the expression, I change the servername and catelog name to variable (I will show connection setting shortly)  

<img src="/images/blog33/inner_loop_setting1.PNG">   

The first tab gave you inital start setting. Then it starts looping through each model on that server.  The current model name is passed to the variable in the following setting. You will use this varialbe to create OLE DB connection which will be used in data flow inside inner loop.  Please note: the varialbe name is still same, which a bit weird to me. I tried to use different variable, the project crashes whenever you close the project and reopen. so keep the same variable name, it does the job just fine.   
<img src="/images/blog33/inner_loop_setting1.PNG">   

* connection
For this ETL process, I just need 3 connection. 

<img src="/images/blog33/connection.PNG">   






