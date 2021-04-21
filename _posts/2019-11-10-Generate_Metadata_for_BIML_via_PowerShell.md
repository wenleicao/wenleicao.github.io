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
* a.	Put all file in one folder.  Extract first row  (column header) of each file to a combined CSV file (PowerShell)
* b.	Load csv file to sql server table and create a view  based on the table and give a layout in the way which can be used in BIML (t sql)
* c.	Create a hard code BIML to create a table and load a table (visual studio, biml express)
* d.	Using meta data to create BIML script to create all table and load all table  (visual studio, biml express)  

c and d. is not the focus of this post, but I will quickly go over and list biml file in the download link at the end of the post.  

### a.	extract meta data from flat files
Let us assume we have two files in a folder, course.csv and student.csv.  If this is successful, you can use it for hundreds and thousands file likewise. I am just use two files as an experiment (csv file are also in download link).  

<img src="/images/blog30/course.PNG">  

<img src="/images/blog30/students.PNG">  

Notice that the column number and row number are different. I deliberately create file like this.  I put them in a same folder.  Now I use PowerShell to extract both files's column header into a csv file.

<img src="/images/blog30/powershell.PNG"> 

Let me go over the PowerShell script. First define path and assign all file with .csv appendix to $files variable.  Loop through each file in this $files variable, combine file path and file name. So that it is a complete path, extract the first line of each file.   I also defined $outarray as an empty array before loop. Inside loop, I created $myobject to hold extracted info and dump the info to $outarray each loop. Once loop is done, I export csv file, here if you have permission, you can also directly save to a sql server table. 
This is what I have extracted from the source file in a csv file.  

<img src="/images/blog30/meta_data_content.PNG"> 

### b.load meta data in SQL Server and make corresponding changes for BIML	
As you can see, the column header is in the columnstring.  In order to use that, I need to split the string into column name. It is much easier to be done when this is loaded into sql server table. Here I loaded it to a table named as source_flat_file_header by right click a databae and click tool then input flat file in SSMS or you can use SSIS.  

<img src="/images/blog30/import_flat_file.PNG"> 

Now, in order to use these in biml, I need to extract file info and column info from it. I create two views at file and column level so that if there are some changes, I don’t need to load data back and forth.  

File level view  
<img src="/images/blog30/file_metadata1.PNG">   

Column level view
<img src="/images/blog30/create_metadata2.PNG"> 
you can also make column data type as int here for example if column name has ID. 

### c. Create hard-coded BIML file	
I like to create a POC hard-coded and just see if it will succeed. Once it works, I will add biml script to be able to load more table. I assume readers who are interested in this post are more or less experienced.   
Attached in download has hard-coded biml file, I call it vanilla biml, because it has no biml script.  If you let it expand, it will only create one execute sql task, which only create a table.  The same thing for loading data flow.  Vanilla biml can be download at the end of post. 

### d. implement BIML Script for larger scale
Since out purpose is to load many tables.  I have modified the vanilla biml with biml script and be able to use the meta data I created to have multiple table load in one package. Notice I use nested loop, outside loop through files,  inside loop,  I will loop through columns for that particular table.   
You can see multiple create table statement in one execute sql task  

<img src="/images/blog30/create_table.PNG">   

The same way, I created loading flat file biml and generated package from both biml files.

<img src="/images/blog30/create_sample_table_ssis.PNG">   

then  
<img src="/images/blog30/load_to_table_ssis.PNG">   

Let us check final table to see if it get populated.   

<img src="/images/blog30/final_result.PNG">  

This is an example, I use only two flat files as example. But it helps me to load ~80 tables without having to create each table and load it. Most importantly, it converted a tedious project into an interesting one.  If there are future request, you can just modify the biml to adapt the changes as oppose to go through each data flow task to fix things.  

The script used in this project including powershell, t sql, biml and source files can be found <a href="/Files/blog30.zip">here</a>.  

To protect privacy, you need to replace the server and database name in your environment.  

Hope this helps.  

Keep warm! 

Wenlei

