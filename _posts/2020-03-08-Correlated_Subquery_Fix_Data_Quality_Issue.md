---
layout: post
title: Using Correlated_Subquery Fix Data_Quality Issue
---

Correlated subquery is a special type of subquery. It takes outer query value and uses in inner query. Therefore, it will loop though every row of outer query.   Unlike regular subquery, correlated subquery has the dependency on outer query. Thus, it cannot run by itself. 

This post gives a good prime for correlated subquery  
<https://www.geeksforgeeks.org/sql-correlated-subqueries/>  

Generally speaking, row-by-row operation is not recommended for query from performance perspective. But for smaller table, it is a life-saver under certain circumstance in BI world. This applies to cursor as well.  They exists for certain purpose.  

The following is real life scenario.

One of our customer exports data from SSRS and would like those data load into SQL Server database. The particular SSRS is a stepped report with same row header only appeared once in multiple rows.  

Something like the following table, you will see one customer only appear once. There are transaction with customer name as null. For example, The third transaction belong to Susan. The 6th and 7th transaction belong to Bob and so on.

<img src="/images/blog34/raw_table.PNG">  

We need to backfill the name to the table. How can we do it?  

Here the pseudocode is as follows,  
* If customer is not null, then use customer value
* If customer is null, then use the top 1 customer value  where saleID < its saleID and customer value is not null, sort the saleid in descending order   

Let us see how we use correlated query to write this code.  

<img src="/images/blog34/backfilledtable.PNG"> 

Notice, I create Saleid as identity column always give you correct sequence to compare based on loading. 
I also created a new column in the script, backfilledcustomer, using the logic highlight in the pseudocode. Notice "i.saleid < o.saleid"?  This is how outer query and inner query correlated. Also, i.

Next, you can load the backfilledcustomer to downstream ETL.  You just fixed a data quality issue.




