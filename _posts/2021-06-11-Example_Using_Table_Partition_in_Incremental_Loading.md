---
layout: post
title: Example Using Table Partition in Incremental Loading
---

Many SQL Server database developers have heard of table partition. These technologies have been around for quite some time.  But most people have never used it partially because people think they can make it do without it.  However, If you work with large amounts of data such as a data warehouse or dealing with incremental loading. It is actually a very powerful tool should you know how to use it.  

A real use case is as follows if I can redo it. 

A couple of years ago, I had a [post](https://wenleicao.github.io/How-to-let-SSIS-wait/) about how to let SSIS wait. Business scenario is that a table was used by a report. It took more than 30 min to copy data to the table. So ETL cannot take place until 7PM to avoid affecting user experience. The strategy I was using is to preload data in the staging table, create a SSIS timer. Set a logic if it is past 7PM, go ahead and load to the final table, if not, wait till 7PM to load. If I use table partition, I might not need to wait, I can just switch in to final table because there is no actual data move. It is only metadata change behind the scene. Therefore, the change is so fast that the user will almost not notice that.  

There are quite some documentation and  blogs about partition. These really help me to get started. I listed links which I think are great for beginners.  

* This speaker is great and good primer to get you started
<https://www.brentozar.com/archive/2013/01/sql-server-table-partitioning-tutorial-videos-and-scripts/>  

* Catherine shows different scenario and good examples to get your feet wet  
<https://www.cathrinewilhelmsen.net/table-partitioning-in-sql-server/>  



