---
layout: post
title: Pass Query Result to Variable_in_Talend
---

Talend is new competitor in the Data integration tool market. If you has been using Microsoft SSIS, you know it is a very good tool. But when it comes to the needs for connecting to different type of databases, you will have a lot of hassle to make it work. Talend is very good at this. Also it has tons of components to be able to work with big data and cloud. If you know how to use, it is a very powerful tool.  

As a saying goes, a coin has two sides. On the other hand, however, I don’t think talend did a good job to build a powerful help system. The documentation is hard to understand without good example. Many time, I have to google other examples and try to achieve something by try and error.  

Variable is very an important part of ETL process. It makes ETL more dynamic and being able to handle complicate situation.  

In Talend, you can use two types of variable, context variable or Global variable.  

When working with database,  you often need to get value from a query and save it to the variable to be used later.  

For example, you have a table with id column as an identity column and  primary key. The id keep growing as record are loaded.  Now you want this table to be copied into another database for reporting. But the table is big, you don’t want to copy the whole table each time.  So one way to do that is find out what the maximum id is in your destination table and save it to a variable (because it will change each time you ran the ETL). Then in the source, only choose record whose ID is larger than the variable value.  This is one simpliest way to do incremental loading.  

Now the question is how to pass this max value to talend variable? 

These are top 3 posts what I get from the top Google search.   

<https://community.talend.com/t5/Design-and-Development/How-to-pass-a-sql-query-result-set-to-a-variable-in-talend/td-p/85892>  
<https://community.talend.com/t5/Design-and-Development/Using-query-output-as-a-variable/td-p/142837>  
<https://community.talend.com/t5/Design-and-Development/resolved-Get-result-of-query-as-variable/td-p/75883>  

If you browse these posts, most information you notice is text, which I am sure answer giver knew what he/she was trying to say but the requester might not know what the answer really meant.  

I , myself, also struggled with this setting a bit.  I would like to show step by step in images. So people will be able to copy the concept.  Also different database could have subtle difference. I will point that out how to fix that to overcome the frustration.   


I use MySQL as an example first 

Overall, two subjobs, one use global variable, the other use context variable; Each subjob uses database input to query, javaRow assigns variable and prints the value to show if it is working. Please note: I block some info to protect privacy, but should not affect conveying the info. 

<img src="/images/blog36/mysql.png">   

Setting in database input.  Select max(id) and give new column name maxid  

<img src="/images/blog36/mysql_databaseinput.png">   

tjavaRow_4  using global variable,  because id data type is bigint,  I use long talend data type  

<img src="/images/blog36/mysql_java_row_global2.PNG">  

tjavaRow_3 using context variable. You need to set up the context variable maxid in context tab first.  I set up two context variable, one for mysql, the other for mssql.

<img src="/images/blog36/context_setting.PNG">  

<img src="/images/blog36/mysql_java_row_context2.PNG">  

It works in my sql.  What about we do the same thing in sql server. You will think it will automatically work, right?  not really.

<img src="/images/blog36/sql_server_error1.png">  

detailed error is as follows, showing maxid is not found??

<img src="/images/blog36/sql_server_error.PNG">  

My setting in MSSQLinput is as follows. As you can see maxid is alias 

<img src="/images/blog36/sqlserver_databaseinput2.png">  

Setting for tjavaRow_1  

<img src="/images/blog36/sql_server_java_row_global1a.PNG">   

Double check schema, do you notice that the db column name still is id even I explicitly name it " max(id) as maxid"  

<img src="/images/blog36/java_row_schema.png">  

Change setting to  

<img src="/images/blog36/sql_server_java_row_global1.PNG">  

Now it works. 

also I add contect varialbe too for sql server. 
<img src="/images/blog36/sql_server_java_row_context1.PNG">    


<img src="/images/blog36/success0.png">  

<img src="/images/blog36/success.PNG">  

I hope this post helps you with the variable setting in Talend.

thanks and have a nice summer!


Wenlei

