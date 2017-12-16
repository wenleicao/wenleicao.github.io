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

Preparation
You need to install Pyzillow and apply for an API Key.  The following two links can help you if you are new to python.
Install Pyzillow through pip
<https://stackoverflow.com/questions/43298789/install-module-with-pip-command-in-python/43298826>

API key 
<https://mohitbagde.wordpress.com/2015/01/22/using-the-zillow-property-api-to-extract-property-listings/>

1.	Get result from one API call
To get the Zillow property link from API, you need to first pass street info and zip code to GetDeepSearchResults function, here you can get property Zillow_id. Next, you pass the Zillow_id to GetUpdatedPropertyDetails function, you can get property link.  To make things a little easier, I created a user defined function, get_zillowinfo. This function will take zip code and street info and return the property link.  As you can see, when I passed one example address to the function, it gave me a link 


2.	Read batch info  out from csv
Now, we test if we can bring multiple record in at the same time.
We can import csv module, use its reader method to read csv. Here we created a csv file, contain two line of info.  We can print row out in batch.  Please note, the csv contain header. In order to skip that, I used next ()


