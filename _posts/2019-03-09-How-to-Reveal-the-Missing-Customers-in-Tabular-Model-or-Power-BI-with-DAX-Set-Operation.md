---
layout: post
title: How to reveal the missing customers in tabular model / Power BI with DAX set operation
---

(**Please note:** there are many ways to compare two database tables for difference in SQL. I am focusing on data in the tabular model, therefore, need to use DAX )  

Missing customer is an interesting business question which business cares about.  Business wants to see why or how to make them purchase again.  Therefore, to identify these customer population is important.  

There are quite a few posts on this topic online. The most elegant way I have seen is to use table variable to isolate different time frame and use DAX set operation to identify the target customer population.  The reason I vote for that approach is because of code readability and performance.  

One thing though, most post using set operation is focusing on counting the missing customer, I tried to search if there are posts to further identify those customer. But I am out of luck to find.   

This is actually a legitimate question for business. Once you tell the business that so and so number of customers are missing.  They will naturally ask who those customers are.  

I tried this myself in DAX and struggled for quite some time. This is my solutions.  

I will use a few simple tables containing some dummy data in power BI to imitate tabular model and business problem. Only 6 customers, 2 months and a few line of sale records so that it is easy to understand. The same principle applies to more complicated scenario, you just have to adjust it though.  

First, let us build model in power BI desktop.  
Use DAX datatable function to create customer table in power BI desktop (model->new table). This makes it easier if you want to edit it later.  


