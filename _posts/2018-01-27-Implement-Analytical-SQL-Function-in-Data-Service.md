---
layout: post
title: Implement Analytical SQL Function in Data Service
---

To accommodate the analytical requirement of business, both PL SQL and T SQL have developed similar analytical function over the years.  For example, row_number(), rank(), dense_rank(), max(), sum(), lead(), lag(). The main purpose of these functions is to help business get insight of data more conveniently.  It works differently from ordinary aggregation function in that it can add aggregation in the same row, as oppose to regular aggregation which only list the unique combination of columns you grouped by 

For example, you have data like this  

| Name     | Value     |
| :-------------|:-------------:|
| A           | 100 | 
| A           | 200 |
| B           | 150 |

When you run the aggregation like the follows  
select name, sum(value) as total from data group by name
you will get

| Name     | Total     |
| :-------------|:-------------:|
| A           | 300 | 
| B           | 150 |

When you run analytical SQL function, you would write like this

select name, value,
sum(value) over (partition by name, order by name) as Total
from data 

Run it, you will get

| Name     | Value     | Total     |
| :-------------|:-------------:|:-------------:|
| A           | 100 | 300 | 
| A           | 200 | 300 |
| B           | 150 | 150 |

If you want to calculate different A row value contribution to total, the second approach has advantage, you just use Value/total.
The regular approach will have to join back to original dataset to do calculation.

Now let us get to data service part.  Recently, my colleague hand me a project which contains script using Lead and lag analytical function. The backend database is Oracle.  

Lead and lag function is used to retrieve the value from next row and previous row.

Find more about lead and lag function at here    
<https://oracle-base.com/articles/misc/lag-lead-analytic-functions>

I have not used Data service to try translating those function. As far as  my research goes, I know data service can create row number within group using gen_row_num_by_group. Also, it has is_group_changed and previous_row_value function. Somebody suggested online, but no examples. We might give a shot.   

<https://archive.sap.com/discussions/thread/3885872>

Let us set up the stage by creating a dataset that we want to experiment on

Using the following script, we create a dataset   
<img src="/images/blog14/table.PNG" >

Now, I can use this table to try some analytical function  
<img src="/images/blog14/partitionby_sql.PNG" >

As you can see, I have use Lag, Lead and sum function to get some value. We use dept as group, we can get previous record, next record and sum of salary with in same dept.

Question is how we can implement this on the fly with data service?

1. First, let us try with embedded data service function

This is the overview   
<img src="/images/blog14/df_overview.PNG" >

In the order query transform, I set data order by dept asc, salary asc,  so that I can use it for dept group and for set the sequence for previous_row_value
<img src="/images/blog14/df_overview_order.PNG" >

In the group query transform 
grouprecordid definition
<img src="/images/blog14/group_id.PNG" >

isgroupchanged definition  
<img src="/images/blog14/isgroupchanged.PNG" >

previous_salary defination. When the group changes (is_group_changed("order".DEPT  ) =1), it indicate it is a new group, the first record should not have previous record, so I set is as null. Otherwise it use previous row value  
<img src="/images/blog14/df_overview_previous_salary.PNG" >

After I execute the job, this is what I got  
<img src="/images/blog14/df_overview_result.PNG" >


Notice 
grouprecordid correctly identify there are 2 group and marked correctly
isgroupchanged column also mark correctly where group changed
The result in previous salary, however, is not what we expected. 
For group finance, the second record should be 1000, but it mark as null (in yellow shade); for group IT, second line should be 2000, but mark as 3000 (in red line)
The issue looks like the previous_row_value function did not notice there is order in data somehow.  Maybe someone can find out something not right in my setting.

Since this approach did not work as expected, I start work on an alternative solution, self join.

2. Self join

this is the setting overview, notice, I use the same table twice, also you need to create grouprecordid as the previous method in advance
<img src="/images/blog14/self_join_over_view.PNG" >

Two table join setting in the self_join_lag as follows. I map one table's grouprecordid = another table's grouprecordid +1
<img src="/images/blog14/self_join_join_settng.PNG" >

In the field mapping part, I include one table's all field, also include another table's grouprecrodid, I call it map_record to see if it maps correctly 
<img src="/images/blog14/self_join_join_settng.PNG" >

The most important thing is include another's table's salary as previous salary 
<img src="/images/blog14/self_join_previous_salary.PNG" >

After execution, the result is what we expected.
<img src="/images/blog14/self_join_result.PNG" >

This is an example for solve Lag() analytical funciton. For lead(), you just need to change join funciton from +1 to -1. 
for sum(), avg(), count() etc. analytical function,  what I think, the easiest way is to create an ordinary aggregation table first and join back to orginal table using the group by column.

Thank for visiting my site. 
If you want to follow along, the code is <a href="/Files/analytic_sql.sql">here</a>. 
Good luck!

Wenlei


