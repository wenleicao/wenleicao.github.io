---
layout: post
title: make batch API request via Python 
---

Recently, I was working with Python on a project. A few features in the dataset are missing, which can be acquired from the third party via API calls.  The original dataset is a csv file.  Basically, I need to loop through each row of csv, pass the value to API, and get the result back.  It will be nice if we can call in batch, return in batch and export all result to csv.  
Here I am using Zillow API as an example.  I have a list of street address and zip code, I need to know the Zillow webpage of those properties.

Let us break this into pseudo code.  This will be a few manageable Python code sections.
1.	Get result from one API call
2.	Read batch info  out from csv
3.	Pass result of 2 to API, get batch result 
4.	Write batch info of 3  into csv
5.	handle exception
