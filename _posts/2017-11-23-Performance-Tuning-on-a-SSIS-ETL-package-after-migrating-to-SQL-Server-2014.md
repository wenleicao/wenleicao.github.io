---
layout: post
title: Performance Tuning on an SSIS ETL package after migrating to SQL server 2014 
---

We have an ETL process which was built and ran under SQL server 2012 environment. Recently, IT tried to update all SQL server version from 2012 to 2014. Since then, this ETL process has performed very badly. It used to only run about 5-6 hours; now it usually cannot complete on the same day. 

After migrated to another data center and DBA addressed some i/o issues. The duration of ETL run ranges between 7-10 hours. 

With increasing data to run, I think duration of 7 hours is probably reasonable. 

We try to review ETL process to see what else we can do to boost performance a bit more.

This particular ETL is a SSIS package handling 62 different insurance plan data, which takes one plan at a time and loop through all plans via foreach loop. The data source is from a stored procedure which takes data from different database. It needs to join a couple of huge tables and apply certain logic to yield data for an insurance and certain time period. Since different plans can have different logic, we have a few of insurance plangroups. 

To improve this ETL process, we try to minimize unnecessary join since this is most time consuming steps.  We modified the stored procedure to take plangroup as param instead of single plan. Now we only need to loop 7 times instead of 62 times. 

The performance gain is significant, we cut ETL run time to 3.5 hours, almost half of orginal time we needed.

While converting the stored procedure from using plan to using plangroup, one thing is worth noticing. 

The pseudo code I changed in the where clause is as follows

From 
where planid =@planid

to 

Where planid in (select planid from plantable where plangroup = @plangroupid) 


It basically modifies the code and let it run multiple plans in a group instead of one plan.  What happened after the modification is out of my expectation. 

I run the modified stored procedure for a test, which took 5 hours to execute and still running. 

Something is not right.  I recall there is guideline that circulating in the IT for the query tuning after SQL server migrates to 2014. 

Because the cardinality estimator has changed 2014 version, there are possibilities that you query performance can get better or worse.  check the following link for detail

<https://blogs.technet.microsoft.com/dataplatforminsider/2014/03/17/the-new-and-improved-cardinality-estimator-in-sql-server-2014/>

To force the query to use old cardinality estimator, I added the following code at the end of problematic query.

OPTION (QUERYTRACEON 9481)

it did the trick.  The reason why this simple change could cause issue for 2014 is quite surprising though.

There are so many factors that can affect your ETL package performance, software, hardware, add index.... on and on.  Sometimes, you need DBA's help. 

I hope my personal experience could help you when you need to do some performance tuning on migrating your sql server to 2014

Happy Thanksgiving

Wenlei
