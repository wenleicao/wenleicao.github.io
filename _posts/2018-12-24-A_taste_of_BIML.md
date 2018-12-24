---
layout: post
title: A Taste of BIML 
---

I having been working on SSIS for many years. I came across BIML in multiple occasions, such as reading reference, browsing BI topics…  BIML as a tool is used to massively create SSIS package and meta-data driven ETL solution. 
So, my view on BIML 
•	Good candidate project for BIML
If your project following certain pattern, such as moving multiple table data from one database to another (you can do it via script if it is between same type of database, but  would be harder between SQL server and Oracle for example).  In addition, it is much easier to maintain the big project using BIML. 
•	Not good candidate project:  small task with unique requirement 

BIML is built on top of XML.  Like HMTL, java script / ASP.Net can be embedded into it and make it more dynamic and more powerful; BIML script (based on C# / VB.Net) can embed in BIML to automate many time consuming or labor-intensive tasks (use loop and condition et al). 
There are tons of blogs and sites over the internet about BIML, but I feels it is hard to find good one for the beginner to follow and appreciate the merit of BIML. 
I like this simple talk one, which guides you through an example for importing data from flat files. 
<https://www.red-gate.com/simple-talk/sql/ssis/developing-metadata-design-patterns-biml/>
One thing, I feels a bit cumbersome that we have to load flat file format header and detail into relational database to be able to use BIML to automate the process.  I understand that ETL needs those info to build the flat file data flow, but if we have to manually insert those, it is not automated in the first place. 
Imaging you have a folder containing bunch of flat files to be loaded, you can loop through it and automatically get the meta data and use for BIML, that would be wonderful. 
I have not seen a BIML extension /help class to do that.  But I think it is possible.  If you have used SAP data service. You know they will set up the different datastore for different type of data sources, one of them is flat file. You can see how it is set up in the following link.  It is pretty accurate in term of choosing data type based on my experience. Maybe BIML creator, Varigence, can build an extension for flat file metadata extraction.
<https://blogs.sap.com/2013/01/14/data-transfer-from-flat-file-to-database/>
If meta-data is easily available, BIML is very robust. I use the following BIML script as example (this example is between two different schemas in the same databases in SQL Server since it is readily available to me, but also apply between different database or between different type of database such as SQL Server to Oracle)
This script is based on Scott Currie’s post with some modification.
<http://bimlscript.com/Walkthrough/Details/3118>




