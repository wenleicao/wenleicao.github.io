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
| Paragraph | Text |

CT         	CDC			
		
light-weighted, only keep last change	keep all change history	
real time	need to compare transaction log, async
available in all sql server version	supported in standard, developer, enterprise, not in express and web 
