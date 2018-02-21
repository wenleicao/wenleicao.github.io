---
layout: post
title: Use Temp Table in SSIS?
---

As a database developer in SQL SERVER world, you will use temp table quite often to store data temporarily for next step in your SQL script. But when it comes to the SSIS, is it necessary?  

If you have used SSIS for some time, you must have used merge join, which is equivalent part of join operation in SQL.  Let us say you have a request that you need to upsert an existing table.  You use left join option of merge join, identify the row that is not in existing table. The next step, you will usually use OLEDB command task in data flow to update the existing table.  This operation is notoriously slow, especially, if your existing table is large. The reason is OLEDB command is a row-by-row operation. From performance perspective, some experts suggest that save the update row in another table and then update the existing table by joining in execute SQL statement.  This way, SSIS use set operation and will perform much better. 

I was thinking whether we can save the update row in a local temp table. This way, we can boost the upsert performance.  In addition, we have less physical table to maintain and keep our footprint small.  Since working with temp table in SSIS is not easy, someone will argue, can you create physical table and use it, then drop it afterwards?  I would say that this is definitely an option, but footprint are bigger (create and drop table).


* How?
SSIS is not designed natively working with temp table, there are a few property need changing to be able to work.  
Let us take a look at the following example. We will go over the setting later.  

1. Example 1
<img src="/images/blog15/overall.PNG" >
I have 4 components here. The first execute SQL Task is used to create temp table, just like what you would do in SSMS.  The second data flow task is populate the temp table created. The third execute SQL task is to test if we can do some DML on the temp table. The last data flow task is to test if we can use temp table to populate another physical table in data flow. This covers most possible usage of temp table.

In the first example, we use global temp table because when configure the data flow, SSIS will automatically validate the table. You can create the same global temp table in SSMS so that you can pass the validation and then drop the global temp table afterwards in SSMS. It will still work. But if you use local temp table first, it won't work.  

Let us go into each step to see the configuration. 
1st task: create global temp table  
<img src="/images/blog15/create_globle_tmp_table.png" >  
<img src="/images/blog15/create_global_table_statement.PNG" >

2nd task, you will see OLE DB source and destination
In OLE DB source
Populate temp source
<img src="/images/blog15/populate_temp_source.PNG" > 

In OLE DB destination
Run the same create temp table script from task1 in SSMS first, so you can map the column. 
Please also note here we use variable to represent table because you are not going to find temp table in the drop downlist.  
<img src="/images/blog15/populate_temp_destination.PNG" >   
Variable setting   
<img src="/images/blog15/variable setting.PNG" > 

3rd task 
let us do a update on the temp table. Here we update the second record only   
<img src="/images/blog15/globle_update.PNG" > 

4th task 
OLE DB source: use the temp table in data flow  
<img src="/images/blog15/dataflow_populate_physical_table_source.PNG" >   
OLE DB destination
<img src="/images/blog15/populate_physical_table_destination.PNG" >

before running this, you need to know, 
SSIS designed in a way that close connection whenever an individual task is completed. We need to keep it open so that the temp table created will be able to be used by downstream steps. Right click the database connection and set like the following  
<img src="/images/blog15/retain_same_connection.PNG" >

Also you need to set validate external metadata to false in any dataflow component which use temp table    
<img src="/images/blog15/validation disable.PNG" >
Some people also set delayvalidation True at data flow level. I did not do this, it still work fine.
 

Run the package  
<img src="/images/blog15/process_successfully.PNG" >

You see the final physical table also show data correctly, because we updated 2nd record and it reflect that.    
<img src="/images/blog15/result.PNG" >

Now if you drop global temp table in SSMS, it should still work fine

2. Example 2  
Let us change it to local temp table because global temp table can be accessed from different users, it might cause some issues unexpected. 
What we have to do is change all global temp table ##test to #test including the variable value for table name.  Then run it.
The first time, it works.  I was thrilled.
After a few days, I tried it again using different database, it did not work. 
I have tried two different databases as sometimes I get this working but I did not the other times.
This puzzled me for quite some time, I am not sure if this is related with database setting. Now as a test, I put both adventrureworks and the other database side by side. You can see that adventureworks did not work, while the other one works.  

<img src="/images/blog15/twodatabasefail1.PNG" >

* Why?
  
Use sys.databases to check the setting for these two database, copy the comparison of setting to excel, I found the difference of databse are list below  

<img src="/images/blog15/database_setting_difference.PNG" >

I tweaked the setting of adventureworks database to be the same as the working database except the one log_reuse_wait. 
Rerun the package, It seems not working either.  

The error shows that 
An OLE DB record is available.  Source: "Microsoft SQL Server Native Client 11.0"  Hresult: 0x80040E37  Description: "Invalid object name '#test'.".

But it did not make sense to me since the working dataflow also need to open this #test

Something still mysterious to me.  I might not find the real differences between two databases correctly.

Conclusion:  
 	1. Keep database connection open   (Remain same connection as true)  
	2. when use temp table, you cannot find it in dropdown list, use variable instead  
	3. Also when use temp table, it cannot find in the ssis source, you need to first create in ssms, pass the column mapping validation, then disable the ValidateExternalMetadata,  in data source or data destination whichever use the tmp table  
	4. globe temp table should work, local temp table will depends on database setting, I have not figured out which one affect this. But alternative way is to create physical table and drop it after use.  

thanks

Wenlei



