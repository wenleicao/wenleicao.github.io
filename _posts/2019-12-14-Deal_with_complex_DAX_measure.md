---
layout: post
title: Deal with complex DAX measure
---

If you are working on tabular model, power BI, or Excel pivot table, you probably are familiar with DAX. Although DAX seems like excel expression, I have experienced many frustration moments. In real life, you might ask to create measure like sum(value). But it is not usual, you will be requested to create something much more complex than that. I will use an example to show you my approach to solve complex measure.  

I was asked to help with a DAX measure about creating third available appointment date.  This is for helping someone scheduling patient appointment. Just so you know,  it is common clinical practice that clinic will reserve the first and second available appointment date for emergency case. I was told the business rule is as follows,  

1.	If patient was seen by a provider group in a particular clinic, let us call C1,  but  those providers also practise in other clinic (C2). If the third available appointment date located in C2,  you can schedule on that date in C2.
2.	If patient see certain Tier provider, then you can only choose that tier. for example,  only tier 1 (t1) provider allowed  

Using Datatable function, I created a table in Power BI desktop so that we can play with.  

<img src="/images/blog31/create_table.PNG">  

These is pseudo process for creating measure   
* a.	I need to isolate the records which can be use for rank the availabledate. Assuming we are choose C2 and T1.  If I write it in SQL, it will be as follows 
Select * from clinical_data where provider in 
(Select provider from clinical_data where  clinic = 'C1' and Tier = 't1')
* b.	With records in hand, I can use the rank function to rank the record and get the record with rank =3
* c.	It is possible there are a couple of appointments with rank =3.  In that case,  we can use concatenatex function to loop through the result and provide a list of physican and date 

