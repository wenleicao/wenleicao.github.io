---
layout: post
title: Programmatically Retrieve Flat File MetaData by Python
---

A fair number of ETL tasks for Business intelligence developers are to load raw flat files.  For large scale flat file loading, BIML provides a good solution to be able to generate massive packages programmatically. The following simple talk post showed how elegant the solution could be.  

<https://www.red-gate.com/simple-talk/sql/ssis/developing-metadata-design-patterns-biml/>  

However, this approach has a limitation that we will need to create the flat file format in advance in order for it to work. I have checked the BIML document if there is an easier way to create this format automatically, but I don’t have luck yet. Imagining you try to go through each flat file and insert the proper  data type for each column, that will be painful.   

To get accurate data type and length has a big impact on the database. It will save the space (int vs varchar) and make data accurately reflect what they really mean (varchar vs datetime).  

I have seen different ways to handle it.  For example, you can load the raw data in a staging database with varchar data type, then you will manually check the data and give the appropriate date type in the destination database. Some ETL tools will scan the first N rows of a flat file to determine the data type and length. The first method is labor intensive,  the second method is automatic, but it only scans the first N row, when you load real data, you could have truncation or overflow error because there could be some records that are out of range after the first N row. 

Do we have a better way to do it yet avoid the above pitfall?  
The goal for this question is we need to have:  
1. Detect right data type automatically, no manual work.  
2. Give the adequate length if data type is text nature (this means we need to scan the full file)  
3. Automatically generate a column data type file to be used later (for e.g., BIML)  

Please Note: if you are interested in usage of BIML, I have a blog talking about it at the following address.
[Link](https://wenleicao.github.io/Generate_Metadata_for_BIML_via_PowerShell/)
