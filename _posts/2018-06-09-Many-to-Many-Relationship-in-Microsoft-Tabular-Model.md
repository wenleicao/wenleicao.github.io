---
layout: post
title: Many to Many relationship in Microsoft Tabular model
---

One of features that Multi-dimension cube has whereas Tabular model doesn’t is that Tabular model cannot handle many to many relationship.  This has been resolved in the 2016 release by Bi-directional cross filtering by setting it in the relationship window.  However, not all companies can keep pace with the latest release.  In fact, our company just start to update from SQL Server 2012 to 2014 this year. Our analysis server is still using 2012 SP2.   But that does not mean we cannot deal with many to many relationship in tabular model. Actually, there are workaround by using customized DAX measure.  And if you understand the context concept and know some basic of DAX programming, it is actually not that difficult.

I read quite a few articles online.  Either they don’t have detail steps or the example is too complex to follow.  I try to use a simple example and give detail steps as to how to implement it.  

Here I use student class dataset which I had a post before to use for an example.  Please consult the following link for table setup if you want to follow along. 

<https://wenleicao.github.io/Many_to_Many_relationship_in_SSAS_cube/>

This dataset is like this:
<img src="/images/blog3/data_in_table.PNG" alt="sample data">





