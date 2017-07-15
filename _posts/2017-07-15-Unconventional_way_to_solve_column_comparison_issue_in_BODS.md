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

We first join this two table using query transform (q_join) with inner join and join with the customerID
<img src="/images/blog9/join_condition.PNG" >

We brought in customerID, this can be from either previous or current table, they are the same. 
Now, we add two columns to show the comparison result of name and city. In the image below, I use c_NAME and c_CITY. The function I used is decode, ie, if both tables have the same value in the same column, I will assign value 1, otherwises, I will assign value 0.  
<img src="/images/blog9/column_def.PNG" >

If you hook up with a template table now with the query transform. you will see the followings.  
<img src="/images/blog9/middle change.PNG" >

Magic actually happened in the validation step, where we created two rules
It is hard for me to understand initially, over the time, I understand that rules set up in the validation step is "AND" relationship. Any of them gets voilated, the record will be sent to fail path.  Here, we set rule as c_CITY =1 and c_NAME =1. Only the record meets all rules will send pass path.
<img src="/images/blog9/validation.PNG" >


We linked the success path and fail path to two template tables. let us run the job and see what happened.
<img src="/images/blog9/result1.PNG" >

On the left, it is success path which only contain customer 1 because he has no changes. The rest customer who has changes is in the fail path. Insteresting part is BODS generates a DI_ERRORCOLUMNS in the fail path. If you take a look at this system generate column, it actually contains the info we wanted (Yes, we need some string operation on it, but the components are there). 


The last step is we add a query transform behand the validation step and use replace_substr function to replace "Validation failed rules(s):" with "", replace prefix "c_" with "" for the column name,  replace ":" with ",". 
<img src="/images/blog9/reformat_di_errorcolumns.PNG" >

The final data flow looks like this  
<img src="/images/blog9/data_flow2.PNG" >

The final result is   
<img src="/images/blog9/final result.PNG" >

I need to give credit to my colleague, Goutham, for this wonderful trick.

Hope you enjoy this post.

Wenlei  


The code to generate the dummy data can be downloaded <a href="/Files/blog9_code.sql">here</a> .  You might need to make slight modification if you use database other than Oracle.


