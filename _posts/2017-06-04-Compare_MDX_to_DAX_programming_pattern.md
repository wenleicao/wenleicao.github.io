---
layout: post
title: Compare MDX to DAX programming pattern
---

SQL is used in relational database (OLTP) for query purpose. For analytical purpose, OLAP cube is built on top of data warehouse. A new type of language called MultiDimensional eXpressions (MDX) was introduced in 1997 by Microsoft to quey the OLAP cube.  Thereafter, MDX is widely adopted by major OLAP vendors such as Microsoft SSAS, Oralce Essbase et al. In 2009, Microsoft pushed out Data Analysis Expressions (DAX) and use it in powerpivot, powerBI desktop and SSAS tabular model. As of now, I am not aware of other major vendor adopted DAX yet.  It seems to me that Microsoft will continue to promote application of DAX. But I don't believe DAX will eventally replace MDX, since MDX is still the only language used in multi-dimensional model (see table below). In fact, DAX is translated into MDX at the backend to query tabular model. Therefore, you can query tabular model with MDX, but not vice versa.

<img src="/images/blog8/mdxvsdax.PNG">

It takes some efforts to learn both language. A lot of people (including me) who knew one language feels it is even harder to learn the other, probably because the way it programs is quite different. I tried to have both MDX and DAX to achieve the same task so that we can take a peek at what the difference is. 

I am going to use Adventureworks sample tabular model as the target database to query against (because both MDX and DAX can be used). 
if you don't have this sample database,  you can use the following link to set it up. 

<http://msftdbprodsamples.codeplex.com/releases/view/55330>

Now, I first wrote DAX code to get product info and create a measure to calculate child-parent ratio. First, I use summarize function to sum total sale amount group by product name, model name and product category.  Next, I use calculate function to alter the current filter context to sum at product category level. Last, I get the child and parent ratio use divide function from above two. 

<img src="/images/blog8/dax.PNG">

 
To achieve the same query in MDX is not that straightforward. The calculation of child-parent ratio relies on hierachy. We have a user defined hierachy in Adventureworks tabular model as follows.

<img src="/images/blog8/hiearchy.PNG">

Noitce that product category is three level above the leaf level of product name. 




 





