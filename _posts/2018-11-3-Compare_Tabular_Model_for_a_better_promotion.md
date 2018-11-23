---
layout: post
title: Compare Tabular Model Difference For Better Promotion Experience 
---

If you work on the same project with others, you must be familiar with source control.  There are a variety of source control products on the market. There is open source one, such as Git offered by Github. I worked with SAP products before, which uses central repository to check in and out.  People working with visual studio will probably be more familiar with Team foundation server (TFS).   

One issue we encountered recently is as follows.
We have quite a few Microsoft Tabular Analysis Service projects. In a big team, when multiple people are working on one project over a few weeks, a number of features have developed. Now, the project manager said we will need to promote 6 features of 10 features to QA environment. People may lose track of which underlying tables or views need to be included in the promotion. Often time, this lead to a miserable promotion day because you keep receiving error message that model processing fail in QA due to something is missing. When you fix one, the other one pops up.   

I agree that we can use QA environment as a test ground to see if there are some defects in the promotion pack.  But I want to see if there is better way to make it smoother.  At least, not so many processing fail message.  

One thing I can think of is to compare model between the current version and the one you release last time. 

Method 1  
 In my current company, however, deployment is carried out by other team. Developers were asked to build the model into .asdatabase json file in bin folder. Then other team deploy from there.  This .asdatabase file contained all the metadata which is used to build the model.   
Since you have current .asdatabase  and previous release  .asdatabase file, you can use Visual studio to compare two files.
First, you can create a SSIS project and copy and paste there two file in the project, in my case, I have two model files named Nov_Model and Oct_Model   

<img src="/images/blog21/add_file_solution.PNG">   

Then, go to visual studio menu view-> other windows->command window. Then there will be command window show up at the bottom of your VS window.  Type in the following command,   Tools.DiffFiles filename1 filename2  

<img src="/images/blog21/file_compare.PNG"> 

By analyze the comparison of two version, you will notice there are some difference.  When you see this in one version but not in the other, you will need to check where this column is located and if the underlying table or view has been included in the promotion.  If not, you need to include that.

<img src="/images/blog21/yearsort.PNG">   

Method 2  
While I search online, I also notice there is a third party tool which can be added to Visual Studio. It is called bism-Normalizer, from <http://bism-normalizer.com/>  

It is designed to compare the two model on different server. So it will be very easy if you want to compare your model on dev server and QA server.  There is no need finding the correct changeset in source control.  Unfortunately, while I am writing this post, our QA deployment has completed. So, both version are same.  So I cannot use this tool to tell difference. I will need to wait next deployment to give a try.  (P.S.: I actaully checked the tool in the past release, it works pretty well. By the way, I have nothing to do with the dev team of this product, just recommend it as a good tool if you need)

Here is one result showing on their site. very good from my perspective.  
<img src="/images/blog21/BismNormComparison.png">   

Personally, I would recommend method 2, because it is easiest.  But method 1 definitely works from my research.  

Also, I have tried comparing feature to do comparison between two changeset in visual studio, but no luck. 
I saw someone suggested adding it as a feature online 5 years ago. Maybe VS already can do that but I don't do it correctly.  
<https://visualstudio.uservoice.com/forums/330519-visual-studio-team-services/suggestions/3205750-provide-tfs-with-change-set-to-change-set-diff-com>

Do you have a better way to do it? Please share your thought.  
Again thanks a lot and Happy BI.  

Wenlei



