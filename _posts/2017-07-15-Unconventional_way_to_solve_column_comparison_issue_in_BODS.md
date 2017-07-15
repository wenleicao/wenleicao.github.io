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
<img src="/images/blog9/customer_before.PNG" >

create curent customer table  
<img src="/images/blog9/customer_after.PNG" >

Based on info, we know customer 1 did not changed, we used it as negative control; Customer 2 changed name from Jenny to Jennifer; customer 3 changed City from Philly to Seattle; customer 4 changed both name and city info. Now, let us see how we identify those to the request of customer.  

This is the first data flow I built.  you will see it contained a query transform and validation transform and a couple of template table. This gives you an overview. 
<img src="/images/blog9/data_flow.PNG" >

We first join this two table using query transform with inner join and join with the customerID
<img src="/images/blog9/join_condition.PNG" >

We brought in customerID, this can be from either previous or current table, they are the same. 
Now, we add two columns to show the comparison result of name and city. In the image below, I use c_NAME and c_CITY. The function I used is decode, ie, if both tables have the same value in the same column, I will assign value 1, otherwises, I will assign value 0.  
<img src="/images/blog9/column_def.PNG" >



