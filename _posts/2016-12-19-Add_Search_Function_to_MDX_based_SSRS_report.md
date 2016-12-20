---
layout: post
title: How to solve long dropdown list issue in MDX based SSRS report
---

While working with SSRS, it is very common that you are asked to create a parameterized report. The advantage of this kind of report is flexibility, i.e., client can control the parameter value they want to pass to the report.

A lot of time, the list of parameter value is from a query. The good part is query result will dynamically change when the source value changed. 

Have you ever run into a scenario that the list of value for a parameter is so long that clients have trouble choosing from?

I was working on a project, sourcing data from a SSAS tabular model and need to list providers for client to select. The problem is the provider number is huge. The total provider is about 4000, it is not doable using regular ways.  

<img src="/images/blog2/provider_count.PNG" alt="provider count">

My business analyst spoke to me if only we had an autofill function, which he types something, the rest will pop up. 

That is a good wish, but as far as I know, there is no such function in the SSRS.  However we can imitate it by combining cascading parameter and using wild card.

first design a keyword parameter, configure the parameter property like the follows.

1. define prompts as Search Provider so that client get a hint.
<img src="/images/blog2/Keyword1.PNG" alt="keyword1">

2. don't specify value for this parameter, client will input
<img src="/images/blog2/Keyword2.PNG" alt="keyword2">

3. give a common default value, in my case, I put in arbour as an example
<img src="/images/blog2/Keyword3.PNG" alt="keyword3">

We want to use the keyword to search the provider list, we then get a list provider only related with that keyword.  In regular database, this can be done by using wild card 
Select provider_name from database where provider_name like '%Keyword%' 
However, our data source is tabular model, we can only use MDX not SQL. Unfortunately, there is no "like" in MDX. There is a string function called "instr".  You can use instr to locate the keyword if a keyword in a string. For e.g., instr ("abcde", "bc") =2.  instr ("abcde", "xy") =0. Then we can use filter function to filter in the value >=1, which means it contains the keyword.

First, write the test query in SSMS, pretent you use "arbour" as the keyword that user type in. you can see the result all contain keywords "arbour".
<img src="/images/blog2/test_query_in_ssms.PNG" alt="ssms test">

Now let us create a provider dataset, connect the tabular model, use query designer, put in the script but replace the "arbour" with @Keyword. 
<img src="/images/blog2/SSRS_query_designer.PNG" alt="ssms query designer">

click the query parameter button, to map the paraeter to the keyword, click OK to create provider dataset
<img src="/images/blog2/SSRS_query_designer_parameter.PNG" alt="parameter mapping">







