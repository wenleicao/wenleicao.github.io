---
layout: post
title: Add percentage to SAP webi chart legend
---

SAP has an array of BI products, which is comparable to Microsoft stack. Check the following table for comparison.
I have been using SAP BI Webi to some annual reports for a client. I am impressed by its section feature and how easy to create a summary and detail break down report. In SSRS you would have to add code for summary and use group feature to do that.  It also has variable feature which like expression in SSRS make it more flexible to handle different situation.

| Function      | Microsoft     | SAP  |
| :-------------|:-------------:|:---------:|
| ETL           | SSIS | Data Service |
| Data Model     |SSAS Mutlidimensional or Tabular     |  Universe |
| Reporting |SSRS, PowerBI      |  Webi, SAP dashboard,Design Studio |

I received one request from a client, that need to show calcuation in the legend. like what the chart shows below 



As you might now, legend is where you show series label. Those are not measure, how do I make measure into legend? I was struggled for a while, one of my colleage give me a hint. I finally make this happen.


