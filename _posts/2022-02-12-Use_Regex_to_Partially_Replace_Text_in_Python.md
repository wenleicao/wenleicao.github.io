---
layout: post
title: Use Regex to Partially Replace Text in Python
---

People who work on databases know wild card search will help if you don’t want the search to be exact. In SQL server world (and most DBMS systems), you use % to replace multiple characters, _ to replace single character and use like as operator in where clause.  For example, if you want to check if a column contains Massachusetts, sometimes people use Mass for abbreviation.  You can use a where clause:  where column like ‘Mass%’ to get rows containing values starting with Mass.  

Please note: what I have discussed is in the structural data world. What happens when you deal with unstructured data? For example, In Python, we deal with sentiment analysis.  You will want to find some pattern in a message to manipulate. In this case, the Regex library comes in handy.  I think the best way to learn is by using it.  

Here I present a use case. I ran into a tricky issue during my work, where there is no obvious solution online (when I initially worked). I manually crafted one and did troubleshooting. But later on, I was able to find a way to use  regex to solve it more elegantly.  You can compare how powerful the regex is.   

I will assume you have regex basics.  If not, the following are helpful to get you started.  

* This site clearly show rules and code example  
<https://www.programiz.com/python-programming/regex>  

* This site is very helpful to check if your regex pattern is valid  
<https://regex101.com/>  

The process for using Regex is generally like the following.  

You use regex rule to define a pattern, then use a regex function (match, search, findall, sub) to see if there are matches. If so, you might want to list them, or want to replace them with other words.  

Here is use case:  
We are in the process of transitioning SAS proc SQL query to Teradata query. Since a lot of functions used in both systems are different.  I will need to do a lot of changing functions repetitively.  Of course, this is not a fun job.  Can we use python to parse the change?  (You know I am not a big fan of repetitive work :smirk:). For example, I want to change the following.  I already simplified it. You can think there could be many columns.  


