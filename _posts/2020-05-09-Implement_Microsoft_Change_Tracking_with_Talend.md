---
layout: post
title: Implement Microsoft SQL Server Change Tracking with Talend
---

If you have been using Microsoft SSIS to do ETL work, you must heard CDC (change data capture). You can even find some CDC tasks in SSIS tool box. But many people are not aware Microsoft provide another way to do similar work, Change Tracking (CT).

I have found the following blogs are interesting to read.  They compared the difference between this two technologies.  

[comparison blog](https://blog.syncsort.com/2019/07/big-data/change-data-capture-change-tracking-three-examples/)  

[example blog](https://www.timmitchell.net/post/2016/01/18/getting-started-with-change-tracking-in-sql-server/)

If you are in a hurry, this is my summary 

## Common
* both used for tracking the change made to a table
* not enabled by default, need to enable

## Difference 
<img src="/images/blog37/difference.PNG">   

## Use Cases
* When only current version need,  use CT
* When history data are need, such as  slow changing dimension to track historical price, address, then CDC is better option.

I am interested in using this technology with new ETL tool Talend. In my case, I use two tables in one database, but this can also apply to use in different type of database, on prem or on cloud. You just need to change last destination component. 


## My Adventure
1. You need to enable change tracking for source table (see above example link)

2. some table prep work  in Sql Server Management Studio (SSMS)
<img src="/images/blog37/prepare_copy_table.PNG">   

 a. Line 2 -3 , prepare a table for saving version number.  You can have table with column such as  tablename, version, updatetime. After you update destination, you can save new version number in the table  

 b. Line 10-15, truncate destination and insert source table data. Make 2 table the same.  

3. confirm two table data are the same 
<img src="/images/blog37/data_same_before_change.PNG"> 

4. let us make some code changes in source table  
<img src="/images/blog37/change_source_table.PNG"> 

I made one insert, one update and one delete in source table.
Let us compare two table again

5. Check difference between source and destination after source table change.  You can see saleid 5, 8, 14 has changed
<img src="/images/blog37/confirm_difference_after_source_change.PNG"> 

6. I open a Talend job, which I created to run CT process

<img src="/images/blog37/run_talend3.PNG">   

The next few screenshots are not completed because Talend component window cannot enlarged freely. I have included all codes in the file which can be download below.

a. Upper panel:
Get version to be used box
* tMSSqlInput:  get the last version for a particular table by querying the tmp.change_tracking_version table
<img src="/images/blog37/get_version.PNG">  

* tJavaRow_1:  assign version value to context param
first create a context variable,  I use Long data type because version is bigint datatype in SQL Server database
<img src="/images/blog37/assign_varible0.PNG">  

assign the value to context variable from previous query  
<img src="/images/blog37/assign_varible.PNG">  

* tDBRow_3:  save most updated version number to version table  (if table change frequently, it might be possible when you run this process, the version has been changed, so keep a record of this before the process kicks off)
<img src="/images/blog37/save_version.PNG">  

b. Lower panel  
table prep box
* tDBRow_2: Deleted the destination table records that has been deleted and updated in source table 
<img src="/images/blog37/get_difference_delete.PNG">  

load inserted and updated data 
* tMSSqlInput:  get data that has been inserted and updated in source table (2 row total, delete row has been process in previous step)
<img src="/images/blog37/get_difference.PNG">  

* tMSSqlOutput: load to destination  (because the insertion need to include saleid, I enable identity insert in yellow shade )
<img src="/images/blog37/outputsetting.PNG">  

7. After talend job run, go back to SSMS and run the script to check data in destination and compare with source table
<img src="/images/blog37/change_agin.PNG">   

We can see the change in saleid 5, 8, 14 has been showed in the destination table. 

In conclusion, I have tested both Talend and CT and it appears to work nicely together. 

I hope this post is helpful for you.  The SQL and code used in Talend can be downloaded  <a href="/Files/code_blog36.zip">here</a>.

thanks

Wenlei
