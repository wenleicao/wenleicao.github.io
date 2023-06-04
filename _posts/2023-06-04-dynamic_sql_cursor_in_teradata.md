---
layout: post
title: Dynamic SQL and Cursor in Teradata
---

Dynamic SQL is SQL statement formed when it is at run time.  You can use variable to increase the flexibility of SQL, but variable won’t help in certain occasions. For e.g., you want to change the table name or column name of script in run time.  This is where dynamic SQL shines.  

Cursor in SQL has been ditched as low efficient old technology in favor of set operation because cursor operate is in row by row nature. But cursor is very useful when you deal with handful of repetitive jobs because of its flexibility.  Thinking cursor as a foreach loop might be helpful to understand.  

It can achieve amazing results if you combine dynamic SQL and cursor together. Let us take a look at a real life example.  

I was tasked to convert some R code into SQL. R saved data into dataframe and handled by dplyr package.  In one line of code, you can use lapply to trim all column’s whitespace for a given dataframe.  But it will not be that easy to do in Teradata.  

I am not an expert on Teradata. But I will give it a shot. The least techy way will be to run a trim function for every char/varchar column in a table.  But what if you have 5 tables, a total of 100 columns?  What if the columns will be changing in the future?  Manually maintaining the code will be a disaster.  

I am thinking of using dynamic SQL and Cursor because we can pass a list of column names to a cursor. The cursor then releases the column name one at a time to dynamic SQL to execute update statement with trimmed values.   To give a list of char/varchar columns, we can query the metadata system view  dbc.columnV so even if the table changes, we are still good.  

I have been complaining about the documentation of Teradata. It is difficult to find example code which fits your needs.  Of course, I also need to boost my searching skills.  

I feel the following two sites are helpful for Teradata users if you cannot google what you need.  

<https://docs.teradata.com/>                	use search function here to locate some examples  
<https://dbmstutorials.com/random_teradata/teradata-dynamic-statements.html>  

The second site gives some actual Teradata scripts. Although in this case, it is using dynamic SQL to create tables or insert tables. It is close enough to our purpose.  

I use the script from the 2nd link as a template to create my own stored procedure and create a fake table to test the stored procedure.  

Teradata syntax is quite different from other RDBMS. Honestly, I don't remember all those syntax unless I am doing it on a daily basis. So if you are on the same boat, I will suggest using a template and modify the code based on your need.  

It is time to get our hands dirty. let us go over the code. 

<img src="/images/blog54/stored_proc1.PNG">   






