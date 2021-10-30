---
layout: post
title: Solve DAX Cross Group Calculation in Power BI 
---

Accurate dashboard visual relys on the underlying correct data. I like to first get data right in the table, then build visual on top of that.  

In the matrix power BI report, you will see multiple layers of hierarchy columns and your measures are sliced and diced by the columns.  Most times, we come across single parent hierarchy, like the left diagram. But occasionally you will see multi parent hierarchy (right diagram)  

[![image](/images/blog45/hierarchy.PNG)](https://dwbi1.wordpress.com/2017/10/18/hierarchy-with-multiple-parents/)   

A real example is as follows.

<img src="/images/blog45/store.PNG">  

This is a mall directory I visited the other day. They classify Target store in different categories because it sells both products. In this case, Target has two parents. The real challenge for multi-parent hierarchy is when you do some analytics, you don’t want to double count it.  But sometimes, requirements might want to show aggregate numbers across the group. 

Let me give you an example.  We set up a fake data source like so.  

<img src="/images/blog45/fake_table.PNG">  

This contains two groups and  3 members.  Notice that S1 belongs to both G1 and G2.   

We have the dummy data now.  Just create a base sale measure.  

<img src="/images/blog45/base_sale_formula.PNG">  

Let us create a matrix table in power BI and bring group and member in row, then bring in base sale measure in value.  You will see the following. 

<img src="/images/blog45/base.PNG">   

This looks all correct to me.  Now let us say we want to have a group sum   

<img src="/images/blog45/group_dax.PNG">     

Here I use RemoveFilters function to remove member context filter. So it only left group context filter.   

<img src="/images/blog45/group_sum.PNG"> 

This will give each row the value of group sum.  Notice the sum for each group G1 and G2.   You can use group sum to do ratio and so on.  You think it is all perfect.  Well, not yet  :). Because S1  is in both Groups, Your boss really wants to see  the sum for S1 (cross two group sum) showing in both Groups, so he don’t need to calculate manually,  but they don’t want you to double count S1 in Grand total. Sometimes, I think this is odd. But your customer could have all kinds of requests. Believe me.  







