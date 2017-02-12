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

<img src="/images/blog4/original_pie_chart.PNG" alt="original">

what they want 

<img src="/images/blog4/final_pie_chart.PNG" alt="final">

As you might know, legend is where you show series label. Those are not measures, how do I make measure into legend? I was struggled for a while, one of my colleage give me a hint. I finally make this happen. This is how.

first create a percentage measure varible in the report variable section. set the variable like this.  pay attention to the webi syntax for percentage.

<img src="/images/blog4/measure_percentage_setting.PNG" alt="varible measure setting">

next, we create a dimension varible  to use this measure 

<img src="/images/blog4/dimension_percentage_setting.PNG" alt="varible measure setting">




