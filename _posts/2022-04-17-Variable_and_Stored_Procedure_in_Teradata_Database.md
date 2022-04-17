---
layout: post
title: Variable and Stored Procedure in Teradata Database
---

If you have been using Oracle or SQL Server, creating variables and stored procedures is like a breeze.  When you are told in Teradata, you cannot use a variable in Teradata script (you can declare a variable in stored proc though), you might be shocked, especially when you want to implement something flexible.   

Variables are very useful when you need to change part of code while keeping most of the code intact.  How does Teradata solve the similar situation?   It turned out in Teradata you will need to create a temp variable table, then cross join that to the table/tables which you want to use variables. It will end up with a table containing variable values in each row.  Then use those variables in your statement.  

Let us take a look at an example, you will see what I mean.  

Assume you have a report in which some queries need to go back 2 year, other queries need to go back 4 year.  You have a target year, let us say 2018 (back 2 year, 2016, back 4 year 2014), then next year, this number will become 2019. All the other variables will be changed (back 2 year, 2017, back 4 year 2015). This is very common for BI reporting.  

First let us create  a variable table,  you can use CTE, but CTE is only valid in one query, so a temp table (in Teradata it was called volatile table) will be a better option if you want to use the variable in multiple queries.  

<img src="/images/blog48/1createvariable.PNG">   

Row 1, use default database,   here I block database name to protect privacy. You can change it to the database you are using.  

Row 3-11, create a variable table, which I will use later.  This variable value can be based on target year.  

Now let us insert some data into this volatile table  

<img src="/images/blog48/insert_variable_table.PNG">   

Row 13-20, I inserted some begin and end date. Notice, I use target value 2018 to calculate the final value so that I can easily change it to a pass-in variable if I want to change this script into a stored proc.

Row 22. If you run this now, you will see the variable table was populated.  Only 1 row, so if you cross join it with other tables, it will add the variable columns to the table without causing dup.

<img src="/images/blog48/variable_table_value.PNG">  

I created a fake student table containing 4 records with various enrollment dates.  If you were a SQL Server user, you knew select … union select …  will do. No “from” statement needed.  But in Teradata you will have to provide a “from” statement. 

<img src="/images/blog48/3create_sample_table.PNG">   

The table will contains data like this  

<img src="/images/blog48/3create_sample_table_result.PNG">   

You can see the results.  Notice, the name length is based on your first records. So Hillary is chopped off.  Sorry, Hillary. But that did not affect our purpose.
By the way, I did better than them in school. :)  

Now let us look at how we use variables.

<img src="/images/blog48/4usingvariabletable.PNG">  

Row 44-46, I cross join student and variable table.  In the where clause, I limited enrollment date  between prior2yearbegin and targetyearend, i.e.  2016-2018.  

You see only 2 records show up.  

<img src="/images/blog48/5usingvariabletable.PNG">  

Row  53-58, if I only change the where statement to prior4yearbegin.  I will see 4 records.  

Therefore, this approach works. Sometimes, you will see people write cross join different ways like the following but without join conditions.  This also produced cross join but it is old SQL syntax.  

from table1, variabletabe   

looks the variable table method works.  Oftentimes, we cannot change the world, we will adapt ourselves to interact with the world.  

Now, let us challenge ourselves, can we make it a stored procedure where we can just pass in the target year, then all other variables will change accordingly?  

<img src="/images/blog48/6stp1.PNG">  

Row 64, create a procedure getlast4yearstudent and pass target year variable  year_var.

Row 67-76, add a try catch like handler to deal with drop table error.   If you don’t include this,  the 2nd time you run the stored proc,  it will complain so and so table exists.  Many DBMS have drop table if exists tablename, unfortunately, you have no such luxury in Teradata.

<img src="/images/blog48/6stp2.PNG">  

Row 78-96, I copied the previous script to stored proc.  Only I changed 2018 to year_var, so next time, when I pass in 2019, everything will change accordingly.  

<img src="/images/blog48/6stp3.PNG">  

Row 100-123, I copy the dummy table,  the last output table, I use where clauses limit records within the last 4 years.  

Run code between 64 and 123, you will create the stored procedure in your database.  

Now let us see if it works. 

<img src="/images/blog48/7test1.PNG">  

Run Row 126-127,   you pass in target year 2018  and you will get student from prior 4 year since 2014 (4 students)  

<img src="/images/blog48/7test2.PNG">  

Run Row 129-130.  You pass in 2019, you get 3 student from prior 4 year since 2015.  

Please note, if you are used to writing a select statement as your last statement in your stored proc, you will have to create a cursor. I wrote a create table statement. I select the table outside the procedure.  So, I don’t need that.  Teradata has a lot of quirkiness like other languages. And their documentation is not as good as others.  It is a pain.  

Just wish some of my research will help others save some pain I have experienced.    

Keep safe in this crazy world.  

As always,  code is included <a href="/Files/blog48.sql">here</a> if you want to follow along.  

Wenlei


