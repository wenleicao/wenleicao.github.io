---
layout: post
title: Implement Analytical SQL Function in Data Service
---

To accomodate the analytical requirement of business, both PL SQL and T SQL have developed similar analytical function over the years.  For example, row_number(), rank(), dense_rank(), max(), sum(), lead(), lag(). The main purpose of these functions is to help business get insight of data more conveniently.  It works differently from ordinary aggregation in that it can add aggregation in the same row, as oppose to regular aggregation which only list the unique combination of columns you grouped by 

for example, you have data like this  

| Name     | Value     |
| :-------------|:-------------:|
| A           | 100 | 
| A           | 200 |
| B           | 150 |

when you run the aggregation like the follows
select name, sum(value) as total from data group by name
you will get

| Name     | Total     |
| :-------------|:-------------:|
| A           | 300 | 
| B           | 150 |

when you run analytical SQL function, you would write like this

select name, value,
sum(value) over (partition by name, order by name) as Total
from data 

Run it, you will get

| Name     | Value     | Total     |
| :-------------|:-------------:|:-------------:|
| A           | 100 | 300 | 
| A           | 200 | 300 |
| B           | 150 | 150 |

if you want to calculate different A row value contribution to total, the second approach has advantage, you just use Value/total.
The regular approach will have to join back to original dataset to do calculation.

Now let us get to data service part.  Recently, my colleague hand me a project which contains script using Lead and lag analytial function. The backend database is oracle.  

lead and lag function is used to retrieve the value from next row and previous row.

find more about lead and lag function at here   <https://oracle-base.com/articles/misc/lag-lead-analytic-functions>

I have not used Data service to try translating those function. As far as  my research goes, I know data service can create row number within group using gen_row_num_by_group. Also, it has is_group_changed and previous_row_value function. Somebody suggested online, but no examples. We might give a shot.   

<https://archive.sap.com/discussions/thread/3885872>

Let us set up the stage by creating a dataset that we want to experiment on

using the following script, we create a dataset   
<img src="/images/blog14/table.PNG" >

now, I can use this table to try some analytical function  
<img src="/images/blog14/partitionby_sql.PNG" >

As you can see, I have use Lag, Lead and sum function to get some value. We use dept as group, we can get previous record, next record and sum of salary with in same dept.

question is how we can implement this on the fly with data service?

1. first, let us try with embedded data service function

this is the overview 
<img src="/images/blog14/df_overview.PNG" >

in the order query transform, I set data order by dept asc, salary asc,  so that I can use it for dept group and for set the sequence for previous_row_value
<img src="images/blog14/df_overview_order.PNG" >

in the group query transform 
grouprecordid definition
<img src="/images/blog14/group_id.PNG" >

isgroupchanged definition  
<img src="/images/blog14/isgroupchanged.PNG" >

previous value defination
<img src="/images/blog14/df_overview_previous_salary.PNG" >



