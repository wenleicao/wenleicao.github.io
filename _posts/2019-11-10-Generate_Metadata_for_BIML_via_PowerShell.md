---
layout: post
title: Generate Metadata for BIML via PowerShell
---

This is a real scenario. A request was sent to me a couple weeks ago. 
There are about 15 main tables flat files and 65 reference tables flat files, which need to be loaded into a database so that client can do data analysis on it.  The data is directly outputted from an application, but client does not have access to the application database. All column can be loaded as text. User can convert the data type themselves afterwards in their query. 

Generally speaking, the following are approaches that you can take
1.	You can create data flow for 80 tables manually. This is tedious, but doable.  However, if client need to modify something, you will have to go through every data flow to modify.
2.	I will usually do it with BIML since I am lazy. It will give me more flexibility and make a boring project into an interesting one.  Challenges here are no metadata exported from source database. Can we still use approach?   The question boils down if we can create metadata just based on the flat file only.

This is the pseudo process that I break down and corresponding method I will use.
a.	Put all file in one folder.  Extract first row  (column head) of each file to a combined CSV file (PowerShell)
b.	Load csv file to sql server table and create a view  based on the table and give a layout in the way which can be used in BIML (t sql)
c.	Create a hard code BIML to create a table and load a table (visual studio, biml express)
d.	Using meta data to create BIML script to create all table and load all table  (visual studio, biml express)

