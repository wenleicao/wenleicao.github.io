---
layout: post
title: Using Correlated_Subquery Fix Data_Quality Issue
---

Correlated subquery is a special type of subquery. It takes outer query value and uses in inner query. Therefore, it will loop though every row of outer query.   Unlike regular subquery, correlated subquery has the dependency on outer query. Thus, it cannot run by itself. 

This post gives a good prime for correlated subquery  
<https://www.geeksforgeeks.org/sql-correlated-subqueries/>  

Generally speaking, row-by-row operation is not recommended for query from performance perspective. But for smaller table, it is a life-saver under certain circumstance in BI world. This applies to cursor as well.  They exists for certain purpose.  

1. The following is real life scenario.

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
I also created a new column in the script, backfilledcustomer, using the logic highlight in the pseudocode. Notice "i.saleid < o.saleid"?  This is how outer query and inner query correlated. Also, "order by i.saleid desc" enforce the closed record being used.  "i.customer is not null" will limit record only has customer name.
Now, if you compare customer and backfilledcustomer column, you find all blank has been filled.

Next, you can load the backfilledcustomer to downstream ETL.  You just fixed a data quality issue.

2. Correlated query is not limited to only use in select statement,  you can use it in other places. 

another example using it in where clause 

I used to be in charge of data driven subscription (DDS) via a sharepoint hybrid SSRS environment in my previous company. For those who is not familiar with DDS, just like regular subscription, you need to pass a set of param value to a report to let it produce a report.  The differnece is that you pass N set of params to product N reports.  In my case, I need to pass several set of insurance plan name to run the DDS. 
One of the  insurance plan always run into the issue. The reason is its data currently did not meet the condition X. The simple but brute way is to remove this insurance plan from the list, but what if next period this insurance plan meets the condition. You cannot always watch for that. Therefore, we need a dynamical way to qualify this insurance plan.  

The following will be a pseudo code.

select o.planname  from  dimplan o  where  conditionX (o.planname =i.planname)

Notice you can use correlated subquery in where clause. Unfortunately, I cannot recall the condition since it has been many years ago. But this is how I solve that issue. 

I hope you feel this is helpful. 

As always, the script in the post can be found <a href="Files/blog34_script.sql">here</a>.  

thanks and keep safe from this coronavirus crisis.

Wenlei
