---
layout: post
title: Implement Microsoft Change Tracking with Talend
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
| CT  | CDC |
| ----------- | ----------- |
| tracking change in hidden table | take use of transaction log|
| light-weighted, only keep last change | keep all change history |
| real time | need to compare transaction log, async |
| available in all sql server version | supported in standard, developer, enterprise, not in express and web |		

## Use Cases
* When only current version need,  use CT
* When history data are need, such as  slow changing dimension to track historical price, address, then CDC is better option.

I am interested in using this technology with new ETL tool Talend. In my case, I use two tables in one database, but this can also apply to use in different type of database, on prem or on cloud. You just need to change last destination component. 


## My Adventure
1. You need to enable change tracking for source table (see above example link)

2. some table prep work  
<img src="/images/blog37/prepare_copy_table.PNG">   

 a. Line 2 -3 , prepare a table for saving version number.  You can have table with column such as  tablename, version, updatetime. After you update destination, you can save new version number in the table  

 b. Line 10-15, truncate destination and insert source table data. Make 2 table the same.  










		
	
	 
