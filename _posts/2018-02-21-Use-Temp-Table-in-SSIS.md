---
layout: post
title: Use Temp Table in SSIS?
---

As a database developer in SQL SERVER world, you will use temp table quite often to store data temporarily for next step in your SQL script. But when it comes to the SSIS, is it necessary?  

If you have used SSIS for some time, you must have used merge join, which is equivalent part of join operation in SQL.  Let us say you have a request that you need to upsert an existing table.  You use left join option of merge join, identify the row that is not in existing table. The next step, you will usually use OLEDB command task in data flow to update the existing table.  This operation is notoriously slow, especially, if your existing table is large. The reason is OLEDB command is a row-by-row operation. From performance perspective, some experts suggest that save the update row in another table and then update the existing table by joining in execute SQL statement.  This way, SSIS use set operation and will perform much better. 

I was thinking whether we can save the update row in a local temp table. This way, we can boost the upsert performance.  In addition, we have less physical table to maintain and keep our footprint small.  Since working with temp table in SSIS is not easy, someone will argue, can you create physical table and use it, then drop it afterwards?  I would say that this is definitely an option, but footprint are bigger (create and drop table).


*How?
SSIS is not designed natively working with temp table, there are a few property need changing to be able to work.  
Let us take a look at the following example. We will go over the setting later.  

1. example1
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
<img src="/images/blog15/populate_temp_destination.PNG" > 

Run the create temp table script in SSMS first, so you have 
Please note here we use variable to represent table because you are not going to find temp table in the drop downlist
Populate temp destination
Variable setting 

3rd task 
Globe update, update the second record only 

4th task 
OLE DB source
dataflow_populate_physical_table_source
OLE DB destination
populate_physical_table_destination

before running this, you need to know, 
SSIS designed in a way that close connection whenever task is completed. We need to keep it open so that the temp table created will be able to be used by downstream steps. Right click the database connection and set like the following
Remain the same connection

Also you need to set validate external metadata to false in any dataflow component which use temp table
Validation disable 
Some people also set delayvalidation True at data flow level. I did not do this, it still work fine.
 

Run the package 
Process successfully

You see the final physical table also show data correctly, because we updated 2nd record and it reflect that.
result

Now if you drop global temp table in SSMS, it should still work fine

Example 2
Let us change it to local temp table because global temp table can be accessed from different users, it might cause some issues unexpected. 
What we have to do is change all global temp table ##test to #test including the variable value.  Then run it.
The first time, it works.  I was thrilled.
After a few days, I tried it again using Adventureworks database, it did not work. 
I have tried two different databases as sometimes I get this working but I did not the other times.
This puzzled me for quite some time, then I realize it is related with database.  Now as a test, I put both adventrureworks and the other database side by side. You can see that adventureworks did not work, while the other one works.  So, it must be related with the database setting. 

Two database fail1
  
Use sys.databases to check the setting for these two database, copy the comparison of setting to exce, I found the difference of databse are list below


I tweaks the setting of adventureworks database to be the same as the working database. 
Rerun the package, It seems not working either.  


The error shows that 
An OLE DB record is available.  Source: "Microsoft SQL Server Native Client 11.0"  Hresult: 0x80040E37  Description: "Invalid object name '#test'.".

But it did not make sense to me since the working dataflow also need to open this #test
Something mysterious!

Conclusion:
 	1. First Create the globe tmp table separately so that you can pass the validation
	2. Use this tmp table in 2nd task need to  connection    (Remain same connection as true)
	3. Need to insert the table, cannot find table, need to set temp table as variable
	4. Also when use temp table, it cannot find in the ssis source, you need to create in ssms, make it error free, then disable the ValidateExternalMetadata,  in data source or data destination, which use the tmp table, next time, will not have validate error
	5. Both globe temp table should work, local temp table will depends on database setting, I have not figure out which one affect this. But alternative way is to create physical table and drop it after use.







