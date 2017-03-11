---
layout: post
title: Observe SAP Data Service CDC Behavior Using Table Comparison Transform
---

Change data capture (CDC) is very important for ETL developer. It is the foundation of data incremental loading. A lot of companies now require data to be refreshed on the daily basis. If full load of ETL process takes less than 24 hours, you can still manage to do it with full load daily.  As source data is growing, the full load cannot be finished within 24 hours. Now, it is the time that CDC comes in to play. 
In SAP data service, table comparison transform can be used to compare incoming data with existing data and further update the existing data. It has some configurations which might affect the outcome of CDC, I would like to use some dummy data to see different CDC behaviors so that we can understand the configuration and know when to use it.
Let us first create a customer info dummy table test_cdc_1, we use it as an existing table
<img src="/images/blog5/orignal_customer_info_script.PNG" alt="original">
In this case, I have 3 persons and they have the address info listed in table. Now we want to see CDC's three actions, insert, update, and delete.  We design an incoming table,  test_cdc_2. So we can see these 3 actions.  
<img src="/images/blog5/Second_customer_script.PNG" alt="2nd">
In this table, you can see John keeps the same location, Kevin changed location to Cambridge, Lisa is not customer anymore. But we have new customer Mary. So John keep the same, Kevin will need to be updated, Lisa will be deleted and Mary will be inserted.
I created data service job like the follows, what is displayed is data flow part. 
<img src="/images/blog5/DS_Dataflow.PNG" >

In this data flow, you can see the data before the job is run. I included three map operation transform to collect the records, which defined by table comparison as insert, update and delete. 

Double click the table comparison, we can see the configuations. You can see we are comparing two tables based on their customernumber and monitor the change of customername and address. Please note, I checked "Detected deleted row" options because I want to monitor what in deleted in existing table. If you don't need, you can leave it unchecked.  
<img src="/images/blog5/table_comparison_config1.PNG" >

After the job is run, we can see test_cdc_1 table data has changed as we expected.
<img src="/images/blog5/cdc_1.PNG" >

In the real life, things is not always simple as that. let us say, the same customer show multiple times in the incoming data.  For e.g., Kevin has to move twice because he did not pay the rent. His name show twice in the table.  How table comparison transform handles that?
<img src="/images/blog5/cdc_2.PNG" >
this is happened after I ran the data service job
<img src="/images/blog5/cdc_2_after.PNG" >

