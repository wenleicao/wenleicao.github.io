---
layout: post
title: Poor man's automation
---


One bottleneck of machine learning is to operationalize the model you build. Let us say you are satisfied with the model performance. Now the question is how you link your data engineering step with your model prediction and then save the prediction somewhere. Above all, you will need to make it run automatically. So that you can do something more important.  

I have been a BI developer on Microsoft platform. ETL tools, such as SSIS, are well capable of doing data extraction. Besides that, it also has an Execute Process task, with which you can run other applications, such as python, R. You can put tasks sequentially so that tasks will carry out based on your design. Alternatively, if you are allowed to use containers, you might be able to recreate your entire environment in Docker and run it from the cloud.
What if you are in an environment where the more advanced technology is not available to you yet?  Luckily, we have a very old friend, a command line tool, and batch files, which we can use to automate the process.  Because it is old, the majority of softwares supports it.  You can run python, R from the command line, which means you can put that in your batch file.  

I have a data science project, from which source data comes from a Microstrategy report, data was extracted using R mstrio package (step 1). Some feature engineering took place in R (step 2). More features were brought in from a variety of sources with python, data went through merge and transformation, fed to the model, finally saved the prediction in AWS S3 (step 3). You can see different technologies used. We are able to use a few batch files to automate it.  

I will share the structure of my implementation of batch files. But I will not go into very basic level. I think people should be able to do some research themselves.  

This is what I want to achieve:  

1. I can just run master.bat to get prediction and no need other commands
2. I want to modularize the child process.  If the problem happen  at child process level, I do not need touch master.bat
3. I want to save job logs into text files. So in case I need to check what is wrong. I can see those for troubleshooting
4. The process needs to have error handling. If there is an error, the batch file will report the error.  

<img src="/images/blog53/1filename.PNG">   

Row 1: @echo off command do not output verbose command. by default, it will repeat your command in output  

Row 2-4,  automatically use system time, generate date time format for e.g.,   step1-2_09-25-2023_1928.txt
 
Notice  %xxx% is the syntax of the variable in the batch file.  Some are system variable like %CD%, %TIME%.  
you can pull system variable value directly. When you need to create a variable yourself, you will need to follow a format like row 14.  Then you can use it like row 15 to show value.   

<img src="/images/blog53/2path.PNG">    

Row 12,  when you schedule a job via task scheduler.  This will tell change directory to current running file location  (otherwise, it did not know )  
 
Row 14,  The parent folder of the running file is code folder. So I save this path. It makes easier to change to this path later  
 
Row 19. I get the directory one level up, because I want to save the log file in the output folder, whereas the output folder is at the same level as the code folder.  
Row 24.  I combined the file path for two log files.





