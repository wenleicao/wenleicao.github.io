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

<img src="/images/blog47/1sample_query.PNG">  

#goal: strip(left(b.type_rw)) -> trim(b.type_rw)  

Now if we take a close look, the partial string needs to be replaced (left side: “strip(left(“, right side, “)” ). The middle part needs to be kept.  This is just part of the string, if there are multiple such patterns, we want them all replaced with a new function, but the middle part needs to be dynamically kept as original. Therefore if something like below. Then should be able to converted accordingly. 

strip(left(b.type_rw)) -> trim(b.type_rw)  
strip(left(c.type_rw)) -> trim(c.type_rw)  

In addition, you cannot use the find and replace edit function, because if you replace ‘))’ for all text, the line 10 will be impacted.  

At first, I was not able to figure out how to use regex to do it.  To me, regex will match a pattern and replace all text with another string.   But in this case, I need to keep certain parts of it intact.  I ended up creating a function of my own to do the work.  Let us break it up into pseudo code.  

1. Use regex to find the pattern  
2. Build replacement string  based on what has been matched  
3. Replace the string  

<img src="/images/blog47/2createpattern.PNG">  

Here I imported re.  Set the target text to be recognized.   I use regex syntax to build a pattern.  Use a search function to match the pattern.  Looks we are successful match the target (Here I use .+ to represent anything between parentheses).  

<img src="/images/blog47/3createhelpfunction.PNG">  

I created two helper functions to remove prefix and appendix. Note here I use list comprehension to remove string since string is a list in python.  

<img src="/images/blog47/4rebuildreplacementstr.PNG">  

Here I use the match string and rebuild the replacement string. Eventually change the string to what we want.  
Now in order for it to be used for different scenarios, I change this process to function.  Prefix and appendix can be passed in as param.  

<img src="/images/blog47/5createfunction.PNG">   

Also I add an if statement to avoid unnecessary string manipulation.  

<img src="/images/blog47/6testrun.PNG">  

Test run, it is  able to identify the pattern and do partial replacement.  

<img src="/images/blog47/7checkonquery.PNG">  

But when we use the function to process the query, the first one is replaced.  Try to know why.  

<img src="/images/blog47/8troubleshooting.PNG"> 

Notice, previously we use re.search function. That will only return one match.  Here we use find all functions. To show each result, we need to use a loop.
Rebuild function, use for loop to process each match.  

<img src="/images/blog47/9createnewfunction.PNG"> 

Retest with the query, now problem solved.  

<img src="/images/blog47/10usenewfunction.PNG">  

As I research the Regex, I realize Regex can isolate patterns in groups and we can back refer to those groups. This will help us recover the portion which is not changed.  Here I can use only one line of code to do what I have done  before. 

<img src="/images/blog47/11usesub.PNG">  

I use regex sub function to replace.  In the sub function, we match the pattern defined previously. Notice, we use trim(\1),   here \1 is referring to the first group defined in the pattern, which is in the parenthesis (.+), this refers to anything between prefix and appendix.   When the regex engine finds the match, it will keep the value and put it back in the replacement you defined (‘trim(\1)’).  

In this post, I showed you how to define my own function, troubleshooting the problem and finally found regex can do it better.  

In summary, Regex is very powerful. It has been widely used in different programming languages. Just like you, I was overwhelmed by the regex pattern at the beginning, which looks gibberish.  But it was worth the time. It will save you a lot of time to build your own.  

As always, the Jupyter notebook can be downloaded <a href="/Files/regex_test.ipynb">here</a>.  

Thank you.  
 
Wenlei  











