---
layout: post
title: Log errors in python with examples
---

Most of people use print function to show variable value in python for debugging purpose. It works fine when you are in dev mode. But as time goes by, your code also grows. It is cumbersome to have the print statement everywhere in your code and clean that afterwards.  Python have building-in logging library, which can be leveraged to make our life easier.   

One reason people not using logging much is that it take some efforts to set it up. Especially when it is involved with handler and format, people could get confused quickly. Normally, you would get log handler and format ready, then add to logger. Therefore, it is multi-step processes. Since python 3.7, this has become easier by setting up everything in the basicConfig function. It is still hard for me to remember every detail since I am not going to use on daily bases. So, I put it down here, which can server as a script template and change certain param later.  

First, import package I will use in the example.  logging for log error, Date for timestamp, os for file path manipulation.
I create log file name dynamically so later log will not overwrite the previous ones

<img src="/images/blog57/1settingup.JPG">  

Here is the logger setting. essentially, you stuff all setting in basicConfig.  

<img src="/images/blog57/1.5logger.JPG">  

In this particular case, I set log format and file and stream handler. When I run it I can see it both show in the output and  file as follows.  

<img src="/images/blog57/2fileoutput.JPG">  

I am running this in the Jupyter Notebook, but if your code make calls to multiple python modules, you might want to include logging in each module with module name in the format. This post will help solve some issues you might encounter.  

<https://stackoverflow.com/questions/50714316/how-to-use-logging-getlogger-name-in-multiple-modules>  

Now that the purpose of logging is to trace back the errors should it happen. So it is important to be able to include the trace info into the message.  

Let us simulate a call stack to show a divide 0 error. I create f1 function. Then use this function in try except block.  And intentionally use 0 as denominator which will throw out an error and be captured at the except block.  We use logger.error function to show error. This does show divide 0 error. But did not give us where the problem is.  

<img src="/images/blog57/3showerror.JPG">  

If we add additional exc_info=True param.  It will include the trace. 

<img src="/images/blog57/2.5showerror.JPG"> 

The same thing can be archived using logger.exception (e), which you can think it as short-hand version. but notice the source file format difference. 

<img src="/images/blog57/4showerror.JPG">  

These did not specify the file, so if you are familiar with the place the function located, you are all set. But if you run this through different module. You might also want to include stack_info = True. Like the follows  

<img src="/images/blog57/5showerror.JPG">  

I hope this post can get you a quick start of logging library. It is a powerful tool.  

the notebook can be found [here](/Files/test_logging.ipynb).    

thanks  

Wenlei
