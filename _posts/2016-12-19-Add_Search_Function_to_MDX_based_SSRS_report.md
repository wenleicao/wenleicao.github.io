---
layout: post
title: How to solve long dropdown list issue in MDX based SSRS report
---

While working with SSRS, it is very common that you are asked to create a parameterized report. The advantage of this kind of report is flexibility, i.e., client can control the parameter value they want to pass to the report.

A lot of time, the list of parameter value is from a query. The good part is query result will dynamically change when the source value changed. 

Have you ever run into a scenario that the list of value for a parameter is so long that clients have trouble choosing from?

I was working on a project, sourcing data from a SSAS tabular model and need to list providers for client to select. The problem is the provider number is huge. The total provider is about 4000, it is not doable using regular ways.  


