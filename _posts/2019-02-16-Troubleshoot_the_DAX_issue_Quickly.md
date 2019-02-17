---
layout: post
title: SQL Server Profiler for DAX troubleshooting
---

Assuming you are a developer of big organization, your Power BI dashboards were all built from one popular Tabular model.   
One day, your boss calls you in his office and points to a Power BI dashboard saying this number does not make sense. Can you take a look and tell me why?  I will meet big boss in one hour. Can you give me some insights by then?  

Guess what, you are not sure if you will be able to figure that out within 1 hour. But you need to understand what is going on first.  

What are you going to do?  

This post is about how to get thing rolling quicker, not about how to resolve a particular issue.     

Everybody does things differently. There are no so-called correct ways to do it.  As long as you can solve the issue, it is a right way.  The following is usually what I would do.  

Basically, most of visuals in power BI dashboard are using the attribute in dimension table to slice and dice the measure built on the fact table. Any visual no matter it is gauge, slicer, scatter/line/column, map chart can be converted to table by click the table on the visual panel. After you do that, you can easily found what attributes and measure being used in this visual by checking Field panel.

But in order to understand why the number is off in Dashboard, you need to know How DAX ran under the hood.  

Now depending on if you have complicated filters on the dashboard, if dashboard is simple and filters are limited.  You probably can replicated the process with the tabular model browser. 

First connect the SSAS server interested, right click the tabular model database and choose browse.  You will find the window like the following image.  Then choose language DAX instead of default MDX. 



