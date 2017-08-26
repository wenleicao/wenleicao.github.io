---
layout: post
title: String builder for BI developer
---

People create tool to make their job easier. Carpenters make wood jig.  Farmers are using spinning wheel for making cloth. 
As a BI developer, I came across many scenario that the job is tedious, but you have to be careful or the code won't work.

I give two examples in SSIS.  The following code are all T SQL code.  

1. I have been using the method describing in the following blog to compared two big tables and do insert and update.  This method works great.  
<http://sqlblog.net/2014/05/01/insert-and-update-records-with-a-ssis-etl-package/>  

The update step is completed by OLE DB command task. This requires you pass in each column value of your incoming record as variables to update your existing record via a stored procedure.  

<img src="/images/blog10/example1.PNG" >

In this case, it only has 5 variables,  what if this is a big fact table that you have 100 columns there. Are you going to manually create 100 variables? 

2. The other example, calling stored procedure in OLE DB source can often confuse SSIS. One way to solve it is to use with result sets clause. There you have to provide the column name and data type.  In my case, query is from a variable. Therefore, it also has SSIS expression, such as double quotation and "\n" for line change. Part of store procedure name is blacked out for privacy.

<img src="/images/blog10/exampl2.PNG" >  

Manually doing this is painful. Most people know to use INFORMATION_SCHEMA.COLUMNS where it has column and data type. By building string from there, you can quickly get the code you want. But you have to rewrite the code each time to the text pattern needed.  In addition, sometime, you need to get info from a temp table.  Temp table column metadata store at tempdb.sys.columns, while data type is at sys.types with different name, make it harder to track info.

<https://stackoverflow.com/questions/7486941/finding-the-data-types-of-a-sql-temporary-table>

Since I am doing ETL quite often, I am also lazy to remember those system table column name. I would like something either procedure or function, I can passing in the table path and sample string, so that based on the table’s  metadata, it will automatically yield the string I want.

Here I walk through the procedure I created.  Procedure code can be download at the bottom of this page.

<img src="/images/blog10/code_section1.PNG" > 

First, this procedure need to pass in full table path, I mean DatabaseName.SchemaName.TableName and string example.   Here the stored procedure need to know the string pattern so that it can replace the column and data type with metadata. So you need to let stored procedure know where column and data type starts and ends.  I sandwich the column name with "*", data type with "#". It is probably not the best choice, but you can select the one you like. In order to avoid confusion, if your example string has single quotation mark, I replace it with "`". 

Next, I declare some variables I need to use during the process. Using string function, I can get databasename and tablename value from table path.  Using substring function, I can  isolate columnname and datatype that will be replaced by table metadata.


<img src="/images/blog10/code_section2.PNG" > 

If databaseName is not tempdb, we will use information_schema. But if we call this procedure to use for other database, you have to specify that database name and add that in front of information_schema. This can only be done through dynamic SQL. The good thing of dynamic SQL is flexibility, the flip side is hard to understand. 
I put the original code before conversion in the comment out block, so you can compare.

<img src="/images/blog10/code_section3.PNG" >

if databaseName is tempdb. it uses a join logic to query different set of table. Notice, we use case when to handle char, varchar, nvarchar differently with other data type. 

Let us see if this procedure can help us to solve the two scenario I mentioned earlier  

Here we use adventureworksDW tables as target tables,   I will call stored procedure and pass in table path and string pattern.  The database where stored procedure reside is blacked out for privacy. Let us see what happen. 

<img src="/images/blog10/string_build_sample1.PNG" >

<img src="/images/blog10/string_build_sample2.PNG" >

we pass a string pattern, sandwitch the column and data type with "*" and "#". you have your string built.

let us work on the 2nd scenario

<img src="/images/blog10/string_build_sample3.PNG" >

We can also quickly build the string.

What about temp table?  we created a temp table. it also returns result we expected. 
<img src="/images/blog10/string_build_sample4.PNG" >

The last step is easy. copy the result to your script, but be careful, since it is mass production, the last of string also contain a coma, you need to remove it, otherwise, you will have syntax error.

Next time, be lazy but be creative :‑P . 

Procedure code can be download <a href="/Files/string_builder.sql">here</a>




