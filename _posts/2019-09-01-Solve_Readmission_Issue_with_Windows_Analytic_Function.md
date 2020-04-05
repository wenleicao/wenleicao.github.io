---
layout: post
title: Solve Readmission Flag Issue with Windows Analytic Function
---

I was requested to rewrite the old readmission script which is cursor based. The script is not long, but it has nested cursor inside code.  It took me some time to figure out how it works.  Basically, it works on one patient at a time (sorted by discharge date). Compare the first record discharge date with the rest record admission date. if the period < =30 (readmission), we flag it 1; if >30, it is a new admission, we flag it as 0.  Now same process will start with this new admission record to compare the rest of record with the same patientID.     

A saying goes "A picture is worth a thousand of words". here is the picture.   

<img src="/images/blog28/create_sample_data.PNG">   

I created some fake records including the readmissionflag. This is what we are supposed to see. You can see between record 2 and record 3. Actually record 2 discharge date and record 3 admission date only differs 7 days. It is marked as 0 because record 1 discharge date and record 3 is more than 30 days. This is the tricky part of project.      

Cursor works on a row at a time, it has maximum flexibility in regards to manipulating data.  But often time, it does not take full advantage of database engine power. So, it could hit performance issue if not design properly.  

I would like to use windows function to rewrite the process.  

First I use row_number function to sort the patient record based on the patientid, discharge date and give the rank value. Now based on this rank, I can compared the previous record with next record within the same patient.   

<img src="/images/blog28/rank_interval.PNG">   

Using lag and datediff function, I compared previous record discharge date and current record admission date.  If the differnece >30, it will be a new admisison. I labelled it as 0,  if <31 (ie <=30), labelled it 1.  

<img src="/images/blog28/first_label.PNG">  

But notice the yellow shaded record?  it is supposed to be 0 if you compare the readmissionflag.  How we identify those?  

Let us say from block 0 record to another block 0 record is a segment. Within this segment, you will compare the first record with the every record. If the period is < 31, this will be readmission, but if it larger than 30, it will be a new admission, therefore will flag as 1.  

The problem is there is no such segment column for us to partition by. We will have to create one ourselves. It took me quite some time to figure this out. I know there is 0 and 1 pattern, it is possible, but the problem is how.  

This is my solution.  I achieved this by switching the block value between 0 and 1 (0->1 or 1->0).  

For example, original the block value is 0, 1, 1, 1, 1, 0, 1, in which 0 represent as new admission.  I switch value to 1, 0, 0, 0, 0, 1, 0.   If I calculate the running total it became 1, 1, 1, 1, 1, 2, 2. So the running total can serves as the segment to partition by.  
As you can see I use this logic to create the segment column. Now I can use segment in the partition by in the next step.  

<img src="/images/blog28/rank_compare_with_previous_record.PNG">    

Here, I used iif to switch the value and sum() analytic function to calculate running total, I got the segment. Next, I used segment to calcualte the firstvalue() of discharge date and current admission date interval.  

<img src="/images/blog28/identfiy_record.PNG">   

Now I used lag function to bring the previous records total days from first record value. With these two yellow shaded value, I can identify the record which are supposed flag as new admission.  The logic is totaldayfromfirst >30, while previoustotaldayfromfirst < =30

<img src="/images/blog28/update_block.PNG">  

You can update the table based on this condition. You can see in the yellow shade, the record 3 has been updated. Also notice record 7 should be 0 as well.  Because record 3 became a new admission, then we will go through this process again. Record 7 will get updated after 2nd round. 

I just use one patient as an example to explain.  In reality, there are thousands and millions of patients' record. Therefore, depending how long the segment you are working on, you need to go through the process X time.   Because we don’t know what the X is. We need to use while loop to do this.  Also we do not want the while loop to be an infinite one, we need to have something to stop it.  The stop condition is the after each round of process, we keep a copy of value, then we go to another round, now we can compare the current value with the previous copy.  If it has any value change, it means still there are long segment need to be broken.  If not, we are all set and we can break the loop.  

Readmission rate calculation is a very common one in Healthcare field.  I wrote this relying heavily on Windows analytic functions. These function are very useful and worth the time to master them.  

Hope this post help you and the script can be download <a href="/Files/full_script.sql">here</a>.  

thanks  

Wenlei
