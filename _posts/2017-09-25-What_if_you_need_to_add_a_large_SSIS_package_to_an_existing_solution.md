---
layout: post
title: What if you need to add a large SSIS package to an existing solution 
---

We had a very large ETL project for enterprise data warehouse. I am also on another project that developping a ETL solution for a relatively independent business problem. So, it was designed separately with the data warehouse. But recently, decision has been made we need to integate these two together. 

When I added the package to data warehouse, problem arose. Here I use adventureworks as example to demo issue. I have a project1, which contains package1. For demo purpose, I just created 3 data flows, but you can think it contains many more data flows.    
<img src="/images/blog11/package1.PNG" >

Now, I need to add a developped package into this project, package2 contains many data flow. It shares some connections with package1. But when you copy the package in, you find there are a lot of errors. 

<img src="/images/blog11/Error_list.PNG" >







