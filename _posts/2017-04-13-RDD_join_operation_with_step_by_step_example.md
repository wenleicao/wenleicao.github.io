---
layout: post
title: Spark RDD join operation with step by step example
---

Compared with Hadoop, Spark is a newer generation infrastructure for big data. It stores data in Resilient Distributed Datasets (RDD) format in memory, processing data in parallel.  RDD can be used to process structural data directly as well. It is hard to find a practical tutorial online to show how join and aggregation works in spark. I did some research.  For presentation purpose, I just use a small dataset, but you can use much larger one. 

Here is a common many to many relation issue in RDBMS world. 
<img src="/images/blog6/table_relation.PNG" alt="relation">

Notice each student could have multiple course, and vise versa. 
Now question is "we want to know each person how much they spend on the course"
In SQL, you would write
select s.student, sum(c.cost) 
from student s 
inner join studentcourse sc on s.StudentID =sc.StudentID
inner join course c  on sc.CourseID =c.CourseID
group by s.student

How this will happen when you use RDD?
Let us import student, course, studentcouse data into RDD. If you want to repeat, I have files download link below, make sure you change the file path to your file location

val student = sc.textFile("file:///home/mqp/Documents/test_data/Student.txt")
val course = sc.textFile("file:///home/mqp/Documents/test_data/Course.txt")
val studentcourse = sc.textFile("file:///home/mqp/Documents/test_data/StudentCourse.txt")

Since imported data a line of string,  we need to tokenize it to break it into studentID and name... Here I convert string to int for ID and cost. Notice string array start from 0, deliminator is tab

val student1 = student.map(rec => (rec.split("\t")(0).toInt, rec.split("\t")(1)))
val course1 = course.map(rec => (rec.split("\t")(0), rec.split("\t")(1),rec.split("\t")(2).toInt))
val studentcourse1 = studentcourse.map(rec => (rec.split("\t")(0).toInt, rec.split("\t")(1)))

let us make sure RDD contain what it is supposed to

student1.collect().foreach(println)

<img src="/images/blog6/student.PNG">


course1.collect().foreach(println)

<img src="/images/blog6/course.PNG">


studentcourse1.collect().foreach(println)

<img src="/images/blog6/studentcourse.PNG">


