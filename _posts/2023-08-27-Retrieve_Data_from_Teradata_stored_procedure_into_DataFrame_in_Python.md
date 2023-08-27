---
layout: post
title: Retrieve Data from Teradata stored procedure into DataFrame in_Python 
---

Teradata has a smaller user base than others like Oracle and SQL Server, which results in less resource you can find online. In this post, I will share my research on how to use stored procedure to output data and retrieve it into a dataframe on the python end.  

To protect the privacy, I blackout the datalab portion of table and stored procedure, you can add your own if you want to repeat. 
First, I create a stored procedure to be able to output a dataset based on parameter values.   

<img src="/images/blog56/stored_proc1.PNG">  

In this dataset, I pass in a major parameter in row 1.  This parameter is used at row 7 to filter a student table. If I use major value = All, this will give me all rows. If I use a particular major, this will give me the student for that major.  Notice, in Teradata, you will need to create cursor for this purpose and need to open cursor to be able to retreive.  

Let us test the stored proc.  

<img src="/images/blog56/verify1.PNG">  

We run row 17, this give all 4 records from student table (using filter value = All).  

<img src="/images/blog56/verify2.PNG">  

When we use major = Business, we only get two records. So, this stored procedure works properly.    
Now let us see how we get the record into the dataframe.   

The output of stored procedure is a little messy, we first created a function to format it. So we can see how data is structured. 

<img src="/images/blog56/3.5function.JPG">   

In jupyter notebook, let us make connection to Teradata using teradatasql library.  

[teradatasql](https://pypi.org/project/teradatasql/)  

<img src="/images/blog56/4jupyter_show_stored_proc_result.JPG">  

I can use it to get business students info by pass filter major= Business. Please note the format, parameters from stored procedure need to be in list or tuple.  Also, notice, the output has more than 1 dataset, the actual data was from the 2nd dataset. 

In order to get the data into the dataframe, the following code get row and column name from the stored procedure (row6 and row7) and then cast the data into dataframe. Before that,  row4 get all dataset, row5 filter dataset only keep dataset with values.   

<img src="/images/blog56/5jupyter_show_stored_proc_result.JPG">  

The other issue, I came across is Teradata has two session mode,  ANSI and Teradata. If python complain you have session mode problem.  Try to change the setting to default, which help me solve the issue (mine using ANSI).

Hope this helps.  
thanks

Wenlei




