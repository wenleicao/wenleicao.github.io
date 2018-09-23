---
layout: post
title: Power BI Report Sevice "Could not load folder contents" issue
---
Among current Microsoft reporting service tools. Power BI is mainly design for dashboard type of report, whereas SSRS is designed for old school paginated report, although they can overlap to some extent. Since they are designed for different purpose, you might experience difficulties if you don’t choose the tool carefully. An example is we have a legacy rolling week report, which the week column label will change every week. Power BI takes the column name from measure name, this has been a tough issue to resolve if we are using Power BI because you cannot change measure name every week. But SSRS can easily address that with expression. On the other hand, some reports have aggregation at subtotal and total level for non-addable measure, a lot of visuals. Those are good candidates for Power BI, not for SSRS. SSRS can do it but might need a lot of MDX or DAX coding to work around the issue.   

Please note: Power BI can integrate SSRS, by allowing pin some visual from SSRS, but as far as I know, not tables. Please check the following link  

<https://www.mssqltips.com/sqlservertip/4136/pinning-a-sql-server-reporting-services-report-to-power-bi/>  

To meet both requirements, paginated report/dashboard, we need to have both tools, in turns it means we need both infrastructures (power BI on cloud, SSRS on premise) to support. From cost perspective, it is also expensive to maintain both.   
Do we have a way to put them together?  
PBI RS server might be one options, especially small company, not ready for cloud yet.  
It keeps both power BI and SSRS report on premise.  
Here are the links what it is and how to set it up.  
 https://www.youtube.com/watch?v=B6OPcxxc7Zk  
http://radacad.com/power-bi-report-server-power-bi-in-on-premises-world  

Recently, we try to explore this option. We set up the PBI RS server. 
It works like the report manager website. I was able to access to site and created folder for both SSRS and Power BI report. I add a few report in, they work just fine.  
However, when my colleagues access the same site, they came across the following issue.  




