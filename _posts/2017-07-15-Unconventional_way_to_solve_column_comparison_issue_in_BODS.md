---
layout: post
title: Unconventional way to solve column comparison issue in BODS
---

We had a request from an internal customer that they need to compare two tables to see what records are inserted, deleted and updated.  These tables contain thousands of records, therefore it is not manageable for a person to do this work. For this purpose, Business Object Data Service (BODS) table comparison transform and Map operation transform can identify table level change (please check my <a href="https://github.com/wenleicao/wenleicao.github.io/blob/master/_posts/2017-03-11-Observe-SAP-Data-Service-CDC-Behavior-Using-Table-Comparison.md">privous blog</a> ).  Customer also want to detail what particular columns were changed in the format like

|Primary Key|column changed|
| --- | --- |
| 1 | column A, column C |  
| 2 | column B | 

The original method I can think is to join two table together and use decode function to identify the column with difference, then use case transform to isolate those columns, followed by merge transform to collect the info.  We ended up with this  

|RowID|column changed|
| --- | --- |
|1|column A|  
|1|column C|  
|2|column B|

Plan is to either use BODS pivot transform or SQL transform to pivot the column changed to format customer requested  
My colleague shared me a smart yet unconventional way to solve this multi-step processes just in one transform. I think this trick is really good and worth time to record there.   

Here I use two example customer tables to show what happened  

create previous customer table
<img src="images/blog9/customer_before.PNG" >

create curent customer table
<img src="images/blog9/customer_after.PNG" >
