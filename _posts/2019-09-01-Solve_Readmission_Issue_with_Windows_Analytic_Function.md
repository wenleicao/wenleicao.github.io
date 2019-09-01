---
layout: post
title: Solve Readmission Flag Issue with Windows Analytic Function
---

I was requested to rewrite the old readmission script which is cursor based. The script is not long, but it has nested cursor inside code.  It took me some time to figure out how it works.  Basically, it works on one patient at a time (sorted by discharge date). Compare the first record discharge date with the rest record admission date. if the period < =30 (readmission), we flag it 1; if >30, it is a new admission, we flag it as 0.  Now same process will start with this new admission record to compare the rest of record with the same patientID.     

A saying goes "A picture is worth a thousand of words". here is the picture.   

<img src="/images/blog28/create_sample_data.PNG">   

I created some fake records including the readmissionflag. This is what we are supposed to see. You can see between record 2 and record 3. Actually record 2 discharge date and record 3 admission date only differs 7 days. It is marked as 0 because record 1 discharge date and record 3 is more than 30 days. This is the tricky part of project    

Cursor works on a row at a time, it has maximum flexibility in regards to manipulating data.  But often time, it does not take full advantage of database engine power. So, it could hit performance issue if not design properly.

I would like to use windows function to rewrite the process.  

First I use row_number function to sort the patient record based on the patientid, discharge date and give the rank value. Now based on this rank, I can compared the previous record with next record within the same patient.  

