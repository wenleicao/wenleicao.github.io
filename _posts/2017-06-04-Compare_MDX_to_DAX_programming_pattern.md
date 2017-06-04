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

Noitce that product category is three level above the leaf level of product name. Thus, I used 3 parents in my MDX code to get product category.  Also, notice that I need to make model name and product category name as a measure to be able to show them side by side product name and ratio.

<img src="/images/blog8/mdx1.PNG">

Because the column dimension uses product category hierarchy, to achieve some layout as DAX, I need to filter out first column level <> product name and ratio is null, then order product name ascendingly across the product category hierarchy (BASC). The result show as follows. The result is the same as DAX results.

<img src="/images/blog8/mdx2.PNG">


Through this exercise,  what I learned.

+ DAX can use Calculate or Calculatable to change filter function, MDX does not have such function
+ To list hierarchy column side by side with measure,  MDX need to create "helper" measure
 
In this particular setting, I use MDX to replicate DAX query, it took extra steps. But it does not mean MDX inferior to DAX. It depends on the requirements. If I am use DAX to replicate MDX, it will DAX extra step to achieve too.

Hope this is helpful.

please download DAX code here and MDX code here. 

thanks.

Wenlei

<a href="/Files/mdx_dax_code.zip">Please download DAX and MDX here</a>



