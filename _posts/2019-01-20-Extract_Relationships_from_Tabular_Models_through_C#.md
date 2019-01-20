---
layout: post
title: Extract Relationships from Tabular Models through C#
---

Let us say, your BSA found something fishy when he checks data. The whole month of sale in MA is only $2000.   He suspects something wrong at the model level or database level.  He is not familiar with visual studio. So he is asking you for help to identify the source table and join key, so that he can write some SQL query to  pinpoint if this is data issue.  

<img src="/images/blog22/scenario.png">   

To look up that, in the past, I used to go to the diagram view of visual studio if model is simple, first find the table used in this scenario, then look for the relationship.  

Microsoft tries to ease our pain by introduce a new feature, called tabular model explorer in visual studio. In the relationships node, you can find tables relation and join key.  The table is presented there with tabular table name. So, in order to get real table source; one more step, you need to go to table node,  right click the table and choose table property and find source table there.   

If small number of tables are involved, it is probably ok to check this way, but what if it is involved with 10 different tables, it will take quite some time to complete all these steps.  

The other approach is use DMV to search meta data.   
For multi dimension model, we can use MDSCHEMA_MEASUREGROUP_DIMENSIONS DMV to retrieve fact and dimension relationship. But for tabular model, this one did not work.   
There are some new DMV are introduced specific for tabular model.   
•	Select * from $SYSTEM.TMSCHEMA_TABLES  
•	Select * from $SYSTEM.TMSCHEMA_RELATIONSHIPS  
•	Select * from $SYSTEM.TMSCHEMA_PERSPECTIVES  

Like precursor MDSCHEMA DMV, for some reason, Microsoft did not allow DMV to join. Because of that, you have to query multiple times among these views to get answer. Not convenient!    

Yet, another approach. Microsoft introduce the .Net library, Microsoft.Analysis Service.Tabular.  Essentially, if you look at tabular model source code of model.bim, it is a Json file.  This library entitle you the capacity to extract info from this Json file  

Advantage:   Since it is .Net library, it is a lot flexible as to what to extract and transform.  Also you can use foreach loop to loop through several models as opposed to only one model in DMV.   
Disadvantage:  you will need to understand .Net code and manually code it.  

This link gives you an overview about Tabular object model  
<https://docs.microsoft.com/en-us/bi-reference/tom/introduction-to-the-tabular-object-model-tom-in-analysis-services-amo>

The following link shows how you install the library and reference the library in visual studio  
<https://docs.microsoft.com/en-us/bi-reference/tom/install-distribute-and-reference-the-tabular-object-model>

Divya did a good job by introducing various way C# can do to extract info from tabular model. I tried some of her code. Somehow, there are syntax errors. The link is as follows 
<https://www.sqlshack.com/automate-documentation-of-sql-server-analysis-server-tabular-model/>  

Here I walk you through a working script  

I will assume you have basics of using C# in script task for SSIS.  

<img src="/images/blog22/namespaces.png">   

In the namespaces, I import miscrosoft.analysisservies.core/tabular to create Tabular object. I also include other library to help. The reason is in comment out.   

<img src="/images/blog22/codebody1.png">  

Here I use two tabular models as example.  Stringbuilder object is created to help file creation. Variable env is to indicate environment (dev, QA, prod). I created a string list. Add both model names in the list. Since, I only have one server, "vmwenlei", holds these two models. So, I assign the servername ="vmwenlei". In reality, different models often live in different servers.  You can use switch case statement to resolve that based on the model name.  Then for each model, we create a tabular server object svr.  Once you define the connection, you can get the database object under the particular svr.  

<img src="/images/blog22/codebody2.png">  

A bunch of string variables are created to hold the value when loop through the particular model relationship property.  

<img src="/images/blog22/codebody3.png">  

Finally, the variable value needed is appended to the stringbuilder object created before and write to flat file.  Behind scene, C# is extracting the relationships like the follows showing in the tabular bim file.  









