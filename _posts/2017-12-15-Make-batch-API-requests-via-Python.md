---
layout: post
title: make batch API requests via Python 
---

Recently, I was working with Python on a project. A few features in the dataset are missing, which can be acquired from the third party via API calls.  The original dataset is a csv file.  Basically, I need to loop through each row of csv, pass the value to API, and get the result back.  It will be nice if we can call in batch, return in batch and export all result to csv.  
Here I am using Zillow API as an example.  I have a list of street address and zip code, I need to know the Zillow webpage of those properties.

Let us break this into pseudo code.  This will be a few manageable Python code sections.
1.	Get result from one API call
2.	Read batch info  out from csv
3.	Pass result of 2 to API, get batch result 
4.	Write batch info of 3  into csv
5.	handle exception

Preparation
You need to install Pyzillow and apply for an API Key.  The following two links can help you if you are new to python.
Install Pyzillow through pip  
<https://stackoverflow.com/questions/43298789/install-module-with-pip-command-in-python/43298826>

API key   
<https://mohitbagde.wordpress.com/2015/01/22/using-the-zillow-property-api-to-extract-property-listings/>


1.	Get result from one API call
To get the Zillow property link from API, you need to first pass street info and zip code to GetDeepSearchResults function, here you can get property Zillow_id. Next, you pass the Zillow_id to GetUpdatedPropertyDetails function, you can get property link.  To make things a little easier, I created a user defined function, get_zillowinfo. This function will take zip code and street info and return the property link.  As you can see, when I passed one example address to the function, it gave me a link.   
<img src="/images/blog13/function.PNG" >


2.	Read batch info  out from csv
Now, we test if we can bring multiple record in at the same time.
We can import csv module, use its reader method to read csv. Here we created a csv file, contain two line of info.  We can print row out in batch.  Please note, the csv contain header. In order to skip that, I used next ().   

<img src="/images/blog13/address1.PNG" >  

Record were read  

<img src="/images/blog13/read1.PNG" > 


3.	Pass result of 2 to API, get batch result 
Next, we try to pass batch info into the get_zillowinfo function through for loop.  Yes, it return 2 links. That is great.   Here row[0] is first column, row[1] is second column in a row, ie, address and zip code. 

<img src="/images/blog13/read2.PNG" > 


4.	Write batch info of 3  into csv
Of course, you don’t want the results just stay on the screen, you want to export it to another csv.  Here we used writer method. When reader loop through the record, we append the get_zillowinfo function result with row head by outrow = row+[get_zillowinfo (row[0], row[1])].  The combined result was written to another file.  
<img src="/images/blog13/write.PNG" > 

Two result rows have been written to another csv
<img src="/images/blog13/result1.PNG" > 


5.	handle exception
What happen if you put in an invalid address?  I know 75 main blvd is a wrong address, when I put it in get_zillowinfo function, it will show error.  What if your csv file contain such error info, let us give a try.  We input the third address as 75 min blvd, 01545.  We reran code 4, we got same error.  It would be nice, we can handle these kind of exception elegantly, we can use try clause to see if there is an error, and in the catch clause, we can define “data is not available” if there is an error.

Directly call API, turn out error  
<img src="/images/blog13/error1.PNG" > 

If our source csv contain this record   
<img src="/images/blog13/address2.PNG" >  

We reran code of fourth step, it will show the same error  
<img src="/images/blog13/error2.PNG" > 

After add try catch block, code reran without error 
<img src="/images/blog13/final.PNG" > 

The record was written in new csv, show "data not available". This will help you identify which record is problematic  
<img src="/images/blog13/result1.PNG" > 

Python is very useful tool, combined with multiple modules, it can be very powerful and make some tedious stuff easy to deal with. 

Hope you feel it is useful.

You can download csv here 

Wenlei 




