---
layout: post
title: When Python comes across Data Service?
---

I am working on an ETL process lately. The requirements are as follows.
+ Using SAP data service (DS)
+ Destination tables are in oracle
+ Business logic are fairly complicated, using a lot of oracle analytic functions, grouping set to dynamically generate subtotal…

Initially, I was trying to build everything with data service components.  Quickly, I realized it took fairly long time to convert SQL script. Some functions in Oracle do not have the equivalent in data service. Workaround takes time, sometimes even not possible.   Eventually, we decide to convert PL SQL script to data service batch script. 
This is an example of DS script. 

<img src="/images/blog16/ds_script_example.PNG" >   
 
Here I have two statement with same outcome
Compared with Oracle SQL, you can see it use sql ().  Within this function, it has a datastore name (in our case, NATLDWH_UTLMGT_DASHBOARD), then the SQL statements.  You can put all your statement in a single quotation block, like the lower example, but be aware you need to escape the single quotation in case you use single quotation for string, otherwise DS don’t know where the statement ends.  The upper example chops the SQL statement into line of string and pieces them together with ||.  Both works fine. Our team, however, prefers the upper format because the statement color are consistent I guess. Make it easier to tell a block of code from others.  Also, it is noteworthy that DS requires no semi-comma in the SQL statement except that it is a procedure which has a begin and end block. That means each SQL statement need to have a separate sql() in DS.  

You can make format change for a SQL statement within minutes.  But imaging you are going to handle a few hundreds of line of code, or you need to do it over and over because original code change.  A lot of text edit need to be done and it is easy to introduce human error. This drives me to think if there is better way to handle this kind of work. 

I am using Python to do other things at the time. I know python can read file and process line by line. Can I make it read SQL file and apply certain rule to the line process based on the DS requirement? I gave it a try.

The goal:
-	be able to separate PL SQL statement from one to next one
-	be able to automatically add datastore, ||, escape single quotation, et al
-	be able to handle single line comment, in line comment, block comment
-	be able to convert drop table, drop index to something which can handle exception
-	create it as function, take SQL file path as param and print the DS script as output

I build the function from simple to more complex. After a few try and error, fix some bugs. It is pretty much completed. Because I just use the function to run against PL SQL scripts and I only run against less than 10 scripts. There are possibility it is need to be modified when you use for your specific purpose. But you got the idea. The following, I will walk you through the Python code.  The code is written in python 3.  

<img src="/images/blog16/define_function.PNG" >  
  
Create a function, take a path variable
Create file object f0, import file content. 
Since blank line could interfere the later logic, I create a list f1, add non-blank line from f0 into the list 

<img src="/images/blog16/handle_comment_block1.PNG" >  
 
Create Boolean variable isBegin and isCommentBegin, use as switch for indicating normal SQL code begin and block comment begin.  Check each line if “/*” in the line, also it is not parallel SQL indicator. If so, swtich isCommentBegin to True, add DS comment sign “#” to the line. If in the same line, it has “*/”, it indicate the comment block has ended. We need to flag the isCommentBegin to False. Since the line is already add “#”, we will print the line and skip the rest of code using continue key word 

<img src="/images/blog16/handle_comment_block2.PNG" >  
 
If iscommentBegin is true, just need to add # to each line and print. At the same time, check if it is end of commentblock

If line is not related with comment block, this is the code to handle it 

<img src="/images/blog16/handle_ds_rule_main.PNG" >  

If line start with "--", that means it is comment line, we simply add # to it.
If there is "--"  behind the statement, that is in line comment. DS does not like it, it need to be removed.
If isBegin is true, that means it is SQL statement begin, we need to add “sql(datastore name”,  at the begin.  Set isBegin to false afterwards.  Looking for line with ";" as SQL end, if so, you need to replace ";" with " );"  line in between will add "||'" at the begin and "'" add the end.

 I came across some issue for drop table and drop index, when running the DS script. It is complaining table or index is not there. So instead of using drop table directly, I use 'begin execute immediate \'drop table tablename\'; exception when others then null; end;' The same apply to drop index. I also add this logic in by finding the "drop table, drop index" keywords

Using this function, it greatly reduce the tedious work I have to do. I just need to tell the function path.
Like: convertToBODSScript ( r'C:\Users\Wenlei\Desktop\sample15.sql')

 It will spit out the DS script.  Of course, if your source code has issues, it won’t correct it for you. I wish it could though.  

<img src="/images/blog16/result.PNG" >

This is part of result in python shell window, you can see it recognize comment line, comment block, also add exception to drop table, datastore.  The output of python have extra blank line.  You can easily remove it using notepad++, copy output to notepad++, from edit--> line operation --> remove empty line (containing blank characters)
 
 After notepad++ process  
 
 <img src="/images/blog16/final.PNG" >
 
Here you are.  

Hope this trick can help you as well

Download the python code <a href="/Files/read_sql_fn4.py">here</a>

Wenlei
