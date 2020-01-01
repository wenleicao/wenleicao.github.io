---
layout: post
title: Use Recursive CTE Solve Real Life Issue
---

If you go through SQL interview, more often than not, you will be asked what difference between common table expression (CTE) and temporary table (temp table) is. Well, CTE can do what temp table does, i.e. holding data in a temporary space, but CTE has additional unique functionality which cannot be replaced by temp table: Recursive.  

This is a concise but to-the-point post about recursive CTE.  
<https://www.sqlservertutorial.net/sql-server-basics/sql-server-recursive-cte/> 
for more detail reading, this simple talk one is good  
<https://www.red-gate.com/simple-talk/sql/t-sql-programming/sql-server-cte-basics/>  

This is my understanding about "recursive CTE":   
You get initial result via SQL. You then want to perform the same action on the initial result. This process will keep going until you run out or you meet certain stop condition.  

For more conceptual understanding what the recursive is, I recommend the following post. Keep in mind that recursive not only appears in SQL but also in other programming language. It is good to understand it.    
<https://www.essentialsql.com/recursive-ctes-explained/>     

Recursive CTE has 3 part structures   
1.	Anchor member   -- initial SQL query  
2.	Recursive member  --subsequent SQL query referring previous result  
3.	Stop condition.    –either you run out previous SQL query result or you set stop condition  

A classic example for using recursive CTE is to establish the organization chart. But beyond that, how often do you use recursive CTE in your work? For me, very rare. That is why most database developers feel it so close yet so far to grasp.  

But in certain scenario, it becomes a life saver if you know how to use it.  

A request was sent to me recently which required me to do an analysis on a complicated stored procedure with thousands line of code. We need to know what underlying table, view, function, nested stored procedure being used. So that, we can move those database objects to another server and being able to run that stored procedure. You might say, do not be silly, just back up the database and restore in another server.  Unfortunately, the database is huge, we don’t want to move whole database over.  

Under this circumstance, I first started to go through the code. I quickly realized it was not cost-effective. Maybe this approach is OK for less than 100 line of code.  But not for this case.  

I feel like this is a good use case for recursive SQL. Since I first get the table, view, called function, called stored procedure in the first pass, I will further do the same thing for the view, function and stored procedure I get from first pass. This process will goes on and on until I reach base table finally.    

Laziness is mother of invention. Let us see if I can find a better way to accomplish this.  

For anchor member, I need to find if there is a query to get table, view, function for a given stored procedure. Luckily, I found Devart had a solution for this. But I will need to make a slight modification since he is only looking for table and view, I will look for almost all objects.  

<https://stackoverflow.com/questions/16229493/how-can-i-get-the-list-of-tables-in-the-stored-procedure/16229560>  

I also would like to make this a table function, so that all I need it to do is to pass the object name and yield a list of table or other objects that being used.  Notice in the object type, I add more type in.  Here U is for table, V is for view, P is for procedure, FN is for function,  IF, TF is for inline and table function, I am not sure what the difference is, but I select them just in case.  

<img src="/images/blog32/base_function.PNG">  

Now I can use this function to get a list of object which used by a given object. Please note: the name of function might be better off use getunderlyingobject to reflect it precisely. I originally tried to get all table, but I expanded get other objects.  You can change function name as you like.  

Now that we have this squared away , we can see how recursive CTE  solve the issue.  

<img src="/images/blog32/get_all_function.PNG">  

Line 15 start the recursive CTE.   
Line 16, I create an anchor member including object_name, type, level (0 represent directly usage by original object, add 1 means one level away from original object), parent represents the parent object using current object (column 1) in the same row.    
Line 18 is recursive member, which using recursive CTE to pass previous object_name for next level run. Because it is table function, I will have to use Cross apply, otherwise if it is a table, I can use table join.  
Line 19, I am only running the same thing for view, function, stored procedure to get the base table  
Line 17, combined different run together.    
I make it a table function to capsulate the logic.   
Let me create some dummy data to see if it works.  

I first created a few tables using my favorite student course scenario.   

<img src="/images/blog32/create_table.PNG">  

Now let me populate these table with dummy data

<img src="/images/blog32/populate table.PNG">  

Since student and Course is many to many relation, they will need the student course bridge table to join together. In order to simplify query, I created a view.   
I also create a function to calculate student age based on student DOB and today's date.  

<img src="/images/blog32/create_view_function.PNG">  

Finally, I created a stored procedure, it will take a course name as param  and then get all student name, age taking that course.  

<img src="/images/blog32/storedprocedure.PNG"> 

So, in this example, the stored proceudre will use the view and function which both are first level object used. Then the view in turn uses three base tablse.  

let me use the my recursive CTE function to see if it can capture what objects has been used. 

<img src="/images/blog32/test_drive.PNG">  

As you can see, at the first level (0), the function captured view and age calculation function. Next level, it captures 3 tables. It works as expected.  

Thank you for following along.  

I wish you feels this helpful.  You can download the scripts <a href="Files/recursive_CTE_script.zip">here</a>. 

Happy New Year!

Wenlei
