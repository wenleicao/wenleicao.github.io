---
layout: post
title: Launch A New Android APP-Solution_Maker
---

About 15 years ago, while I was working at University of Pennsylvania. I started to play with Java to create a few small desktop applications for scientific calculation. For example, solution maker, Real-time PCR calculator.  You can still find those at google code repository.  

* [Solution Maker](https://code.google.com/archive/p/solution-maker/)  

* [Real-time PCR calculator](https://code.google.com/archive/p/gene-expression-calc/)  

Google has stopped the support for Google Code repositories partly because technology moves forward rapidly.  Nowadays, nearly everybody has a cell phone. With computing power and memory much higher than first generation PCs, many things can be done with the tiny gadget in your palms.  I have been wondering if I can convert my desktop application to a mobile platform.  Since I am using an android phone, I started with android studio.  

This turned out to be a much bigger challenge than I thought.   
1. Java has evolved from SE 6 to SE 18. While I am mainly working on the backend in my job, I rarely have a chance to brush up my java skills.  
2. Mobile programming has its own way.  Instead of using Swing, you will need to create layout and activities, fragments.   
 
All in all, I took it as a challenge, it took me a few months instead of a few weeks to implement the functionality I want to achieve. But finally, I am getting there.  

Here is the app play store address  

<https://play.google.com/store/apps/details?id=com.caowenlei.solutionmaker3>  

Before starting work, I looked through Google play app store.   I noticed there are similar Apps.  But the problem is they only calculate concentration for one chemical at a time. In reality, a solution usually contains multiple chemicals. There are NO database support in those apps, which means you will have to redo all the typing if you did not store the result somewhere.  

Based on the analyses, these are the basic goals that I want to achieve:  
1. Being able to handle multiple chemicals, can add, delete, and update chemical info.  
2. Can store chemicals and solution in database, do CRUD operation easily.  
3. Can share easily, you can send solutions to colleagues. You can print it out so that you don’t have to hold your cell phone while you weigh chemicals.  
 
I recorded a video to introduce the app interface, demonstrating how to use the app to make solution calculations along the way, I also showed you how to save chemical/solutions to the database. How to delete/update them should you make a mistake. Please check out the following YouTube video.  

[![image](/images/blog44/video.PNG)](https://www.youtube.com/watch?v=H8lVlpId8oA)   

For folks who cannot access YouTube.  I feel your pain. I have included the following screenshot with a brief intro going along.  

<img src="/images/blog44/Screenshot_1627956668.png" width="250">    

The app interface.  1. Fill in info about your solution name and final volume.  2. You have two options to add chemicals. Manually/search database.  If the chemical is in the database, I highly recommend you use the search function.  It will save you a lot of typing.  But if the chemical is not in the database, you only need to fill in once, then remember to save it, you can use it by searching later.  Selected chemicals will show in the middle portion of windows.  Once you are done with inputting, you can click confirm to show the result.  The left lower button (start over) will clear all info, if you want to redo the process.  

<img src="/images/blog44/Screenshot_1627955601.png" width="250">   

This demonstrated when you click Add manually,   you need to fill in all blank, except the catalog, which is optional   

<img src="/images/blog44/Screenshot_1628164522.png" width="250">   

This shows when you click Search Button. I pre-inserted about 350 commonly used chemicals from Sigma, which is the main chemical source in the US.  It has different catalogs for different levels of purity for the same chemical. But generally, you can choose either one.  Please note, the search is wild card search against chemical name, catalog and formula.    

<img src="/images/blog44/Screenshot_1627955742.png" width="250">   

This displayed an example after I input all chemicals for solution 1X TBST.  Here you review the short list of chemicals.  If you find a mistake, you can simply click it and it will lead you to a window and let you fix the problem.  

<img src="/images/blog44/result.png" width="250">  

Once you are good with the short list, click the confirm button.  This result window will pop up.  Upper portion of the window will show the requirement.  The lower portion of the window will automatically calculate the receipt for you to make the solution.  Notice there are a few buttons below, you can share your receipt, you can save the solution to the database, which can be used and modified later.  

<img src="/images/blog44/result2.png" width="250">  

The above image shows I shared with hangout app with the calculation results  

Notice the beaker sign in the first interface, if you click it, it will show you a list of solutions you have saved so far.  You can click the solution to retrieve or modify the solution as you like.  

<img src="/images/blog44/result3.png" width="250">  

I hope this small app can help people in the wet lab. This is a free version, which including limited number of google ads that will support me to spend more time in improving this app. In the future release, I will include a paid option which is ads free version (should be very acceptable price). If you like the app, please buy the paid version (thinking as if you buy me a coffee 😊).  

please leave your sugguestions and comments below.

thanks and keep safe in pandemic

Wenlei
