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

For more conceptual understanding what the recursive is, I recommend the following post. Keep in mind that recursive not only appears in SQL but also in other programming language.
<https://www.essentialsql.com/recursive-ctes-explained/>    

