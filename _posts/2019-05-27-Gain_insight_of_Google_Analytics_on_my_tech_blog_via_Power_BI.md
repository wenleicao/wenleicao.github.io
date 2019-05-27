---
layout: post
title: Gain insight of Google Analytics on my tech blog via Power BI
---

I have this tech blog for more than 2 years. The blog is built on Github pages, which can be tracked by Google Analytics. I used to go to Google Analytics to see some web activity stat. I have to say Google Analytics did a very good job from tracking to presenting data with various visualization. One drawback though, it has some preset params, like previous week. If I want to see what is going on today, I need to change that at drop down list. In addition, there are some charts I am not interested. It seems there is no options that I can personalize the chart presented. Since Power BI can connect to Google Analytics and retrieve data. I am wondering if I can retrieve data and set up desired chart in Power BI. Next time, if I want to check the web stat, the only thing I need to do is to hit the refresh button.   
First, let us define what I want to see in the dashboard.
1.	I want to know some key statistics, such as total page view, total session, I also want to know what the maximum page view number is within a single day. This one is not available from Google analytics. I will create this measure with DAX in Power BI.  
2.	Show user number and new user number over time. This will be displayed in line chart, so that I can have an idea of my consumers.
3.	Show which post is popular
4.	Where are my consumers from? It is always interesting to me that people from different countries are working on the same thing. It is a small world indeed.  

We need to get data from Google analytics. In Power BI, it is easy to do. There is a connection as follows. Just follow the instruction. You will be able to load data.

<img src="/images/blog27/google_analytics_connection.PNG">  

I only choose the dimension and measure I am interested. The following is the part of data.   

<img src="/images/blog27/raw_pull.PNG">  

Here I create a new measure as follows  

<img src="/images/blog27/dax.PNG">  

For people who is not familiar with DAX. This first calculate total user number in each day, then pick the highest single day total user number. This measure will dynamically change when you change different time period. For example, if you choose year 2017 vs year 2019.  It will calculate the highest single day total user number in chosen period.  

With measure ready, I start to build chart. This is a draft.  
 
<img src="/images/blog27/draft.PNG"> 
