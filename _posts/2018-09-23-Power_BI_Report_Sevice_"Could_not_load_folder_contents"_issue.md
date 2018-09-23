---
layout: post
title: Power BI Report Sevice "Could not load folder contents" issue
---
Among current Microsoft reporting service tools. Power BI is mainly design for dashboard type of report, whereas SSRS is designed for old school paginated report, although they can overlap to some extent. Since they are designed for different purpose, you might experience difficulties if you don’t choose the tool carefully. An example is we have a legacy rolling week report, which the week column label will change every week. Power BI takes the column name from measure name, this has been a tough issue to resolve if we are using Power BI because you cannot change measure name every week. But SSRS can easily address that with expression. On the other hand, some reports have aggregation at subtotal and total level for non-addable measure, a lot of visuals. Those are good candidates for Power BI, not for SSRS. SSRS can do it but might need a lot of MDX or DAX coding to work around the issue.   

Please note: Power BI can integrate SSRS, by allowing pin some visual from SSRS, but as far as I know, not tables. Please check the following link  

<https://www.mssqltips.com/sqlservertip/4136/pinning-a-sql-server-reporting-services-report-to-power-bi/>  

To meet both requirements, paginated report/dashboard, we need to have both tools, in turns it means we need both infrastructures (power BI on cloud, SSRS on premise) to support. From cost perspective, it is also expensive to maintain both. 

Do we have a way to put them together?  
Power BI Reporting Service (PBI RS) might be one options, especially small company, not ready for cloud yet.  
It keeps both power BI and SSRS report on premise.  
Here are the links what it is and how to set it up.  

<https://www.youtube.com/watch?v=B6OPcxxc7Zk>  
<http://radacad.com/power-bi-report-server-power-bi-in-on-premises-world>  

Recently, we try to explore this option. We set up the PBI RS server. 
It works like the report manager website. I was able to access to site and created folder for both SSRS and Power BI report. I add a few report in, they work just fine.  
However, when my colleagues access the same site, they came across the following issue.  

<img src="/images/blog20/issue.jpg"> 

I have tried to adjust at Site level security and folder level security, give them even admin privilege. 
Also, google the problem on the web, I can see people have the similar issue, but struggle to find a solution.
https://community.powerbi.com/t5/Report-Server/Power-BI-Report-Server-You-are-not-allowed-to-view-this-folder/td-p/236338

None is working. It took us two weeks to figure out the problem. Here I share how it get fixed.

The above powerbi link is right, but one thing not so clear is about "manage folder". People will go straight to folder security to change the setting, but that will not work. you need to go here. see the yellow shaded. You need to be admin who build the server to see that. Even you are site admin, you cannot see that. So, you need to be in right group.

<img src="/images/blog20/managefolder.PNG"> 

once click that, you will see the security 

<img src="/images/blog20/folder_level_security.PNGimages/blog20/managefolder.PNG">

once I give permission to my colleague, the problem resolved. 

Hope this clarifies the solution. 

Again, Happy BI, 

Thanks

Wenlei
