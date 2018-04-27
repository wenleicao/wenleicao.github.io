---
layout: post
title: SAP Data Service SQL Push Down
---

SAP Business Object Data Service (BODS) is a powerful ETL tool. Part of ETL developer job is to convert SQL script into data flows. This is good for both data lineage and documentation. When you build a data flow, you add different components together, source, target, query transfer, merge…  As you add more and more components to the data flow, it becomes more complex.  Do you notice, at the beginning, the data flow run very fast, but once it become complex, it can take hours to run. But the same SQL script only run 10 min in Toad, what is wrong with the data flow?

 Most likely, your data flow did not get pushing down to the database level. DS engine is powerful, but a lot of tasks, such as data transformation, aggregation from relational database is far more efficiently processed at the database level. 
 
There is a section in the book called "SAP Data service performance optimization guide" talking about this. But it only have few examples.
Dirk Venken has a post about this topic, which gave some suggestions and examples on how to make full push down in some scenario.  The link is as below. 

<https://blogs.sap.com/2014/02/13/let-the-database-do-the-hard-work-better-performance-in-sap-data-services-thanks-to-full-sql-pushdown/>  


Unfortunately, there is not a step-by-step guide for how to implement pushdown for beginner online.

I had a data flow, the corresponding script ran about 10 min at database. This data flow ran over an hour. I decide to rebuild this data flow from ground up.  This is what I experienced.

* First and foremost important, watch the display optimized SQL, while you are developing your data flow. This menu is only available when you open a data flow. 

<img src="/images/blog17/optimize.PNG" >  

When you see the converted SQL like the following, it is pushed down  
INSERT /*+ APPEND */ INTO "schema name"."table name" ….  

When you see SQL begin with “select”, it did not  

* Transformation is too complex to push down  
The first query transform took 7 tables join and output 50 columns.   There are 5 columns need transformation  
  Column1: User defined function call (I imported into datastore and use the function in mapping)  
	Column2: use ltrim_blanks, rtrim_blanks function  
	Column3: use ltrim_blanks, rtrim_blanks function  
 	Column4: use nested decode function (about 40 case when)  
	Column5: use decode function (about 4 case when)  

When I add column 1-3, it still show “insert /*+ APPEND */ INTO”. Once I add column 4 transformation, it became “select…”

Solution: instead of making all transformation in one query transform, I split column4 and column5 transform into 2nd query transform.    Like the following structure. 

Original :   data source -> query transform (column1-5) -> downstream data flow  
Change to:   data source -> query transform (column1-3) -> transfer transform -> query transform (column4-5) -> downstream data flow

This can make both become full push down.  Transfer transform (I used table option) servers as a temp table to bridge two query transform. Since you need columns for column4 and 5 transformation, you need to add those in first query transform.  You can first mimic this at SQL level and make sure data match, then do it at the data flow level.   

* Do not include other transform except query transform and transfer transform in your data flow.  
I need to merge two client data first to be used for a single source. Since this process include a merge transform, this will prevent the data flow push down.  

Solution: create a separate data flow and let merge transform take place there and use the target table as source in your data flow.  This will make your data flow with complicated logic push down.  

* When call customer function in mapping, try to import the custom function under the datastore you are currently working.    

Solution:  your current destination is currentdatastore.table,   you can use otherdatastore.function, but it is likely to prevent the data flow from pushing down.  Import the function under currentdatastore. You can call currentdatastore.function in your transformation.   
* Sometimes DS engine just did not push down for unknown reason, as long as we keep most complicated process pushing down, you should feel performance improvement. In my case, I boosted performance from over 1 hour to about 10 min.   

For example, I have transformation using decode: 

Decode (condition, ‘A’, ‘B’)   this can be fully pushed down  
But if it likes this  
Decode (condition, null, ‘B’) this cannot fully pushed down  

It seems to me Data service does not like to push down null value somehow.  

It is somewhat frustrating, but Data service will accommodate more and more function with each release.  I believe those will be resolved in near future. This process is ELT rather than ETL, which avoids unneccessary data moving. As a developer, we just need to do our best.   

Happy BI!

Wenlei

