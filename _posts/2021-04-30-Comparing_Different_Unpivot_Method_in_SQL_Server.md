---
layout: post
title: Comparing Different Unpivot Methods in SQL Server
---

Recently, I have a request to unpivot two sets of multiple columns into two columns. It gave me an opportunity to explore different ways to do unpivoting, which is not common, but these methods are life saver when you need them.

You probably think unpivot will revert what pivot (its more famous brother) does. The answer is yes and no. 

Please check this example (I am not good at drawing, I will use an example from other people's post)  

<img src="/images/blog42/UNPIVOT-Example-in-Sql-Server.jpg">  

Image are from this [Link](https://sqlhints.com/2014/03/10/pivot-and-unpivot-in-sql-server/)   

Please note: the original data has two records at year 2012 and .Net course.  after pivoting and unpivoting,  the final result has only one aggregate row for year 2012 and .Net course. This is because the unpivot statement does not know what the original data supposed to be. it can only return aggregated data based on the given group. That is  why I say yes and no.  Yes, it can reverse the action. No, but it cannot go back to original status. 

In SQL Server, there are three different ways that you can perform unpivot action. As this wonderful stack overflow post summarized.  

<https://stackoverflow.com/questions/24828346/sql-server-unpivot-multiple-columns>  

The first one is obviously manual work, which probably only applies to a handful columns. The latter two are more likely to be used when you handle large scales of data.

We will focus on comparing the latter two methods.

### Using Cross Apply
One probably won’t think cross apply can play a role in unpivoting.  But it does.

The following Kenneth Fisher’s post gives a good intro about using cross apply for unpivot.  

<https://sqlstudies.com/2013/04/01/unpivot-a-table-using-cross-apply/>   

We will use Kenneth's example, but I notice the latter two methods handle null values differently, so I also include some test records with full null value or partial null value.

let us take a look at the example  

We first make some fake data.  

create a table  

<img src="/images/blog42/create_table.PNG">  

insert data

<img src="/images/blog42/insert_value.PNG">   

show data we have now, notice the last two records contain null data  

<img src="/images/blog42/inserted_records.PNG">  

Now we want all questions in one column, all answers in one column.   
let us see how cross apply tackle the unpivot issue  

<img src="/images/blog42/cross_apply.PNG"> 

This method has the advantage in that  the syntax is very intuitive. It follows the format you would like  your final result to be. You will  not go wrong about it. Like many other people, I have never thought that cross apply could play a role here :)
One thing you will notice that all records including  null anwer value has been kept


### Use Unpivot Statement

I try to replicate the process with unpivot.  This is the script

<img src="/images/blog42/pivot_script.PNG">   

let me walk you through the code.

Between line 128 to line 142, provide data source for unpivoting
between line 143 to line 151, the first unpivot for question
between line 152 to line 161, the second unpivot for answer
between line 120 to line 127, final selection
line 162,  you will need a where clause to map question and answer using last character, or it will cross join between answer and question. 

The result is as following

<img src="/images/blog42/pivot_result.PNG">   

Notice, by default, unpivot will not keep null records. 

### Conclusion

I personally like cross apply method better based on the following reason.
* cross apply syntax is much simple clear
* cross apply keep the null value, you can easily remove the null value using subquery. but if removing null by defaul like unpivot, it is a bit harder to add them back. 
* unpivot has to include a where clause to prevent cross join between unpivot1 and unpivot2. if you miss that, you screw up the results.

I hope you feel this useful.   
thanks, the code can be download <a href="/Files/unpivot_using_cross_apply.sql">here</a> 

Wenlei
