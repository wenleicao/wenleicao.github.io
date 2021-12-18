---
layout: post
title: Compare the Difference between Git and TFS from User Perspective
---

Source control is very important for developers. It keeps a history of code changes.  It frees developers from saving different versions of code.  In case, something goes wrong, you can always roll back the changes.  

There are different ways to do source control. Here we discuss about TFS and Git. I am not an expert on source control. I feel it is difficult to find an article to discuss how TFS and Git workflow are different from a user perspective.  Which one will be a better fit for your projects? This post did not intend to promote a certain product. It is just my user experience.   

People who used Visual Studio before probably will have experience with TFS, team foundation server. This is the first major product of Microsoft which aims to improve source control experience. I really like TFS. It is very easy to use. You just need to check out the file, make the change and check back in the file. You are all set.  Starting from Visual Studio 2019, however, TFS is rebranded as Azure DevOps Server, under which there are 2 different ways to do source control, Git and Old way, which are now called Team Foundation Version Control (TFVC). The default way is Git.  

<https://docs.microsoft.com/en-us/azure/devops/repos/tfvc/comparison-git-tfvc?view=azure-devops>  

This link gives the general idea of the difference between Git and TFVC.  Git is a distributed system, the other is centralized. But it did not actually visualize what users need to do differently.  

I have been using TFVC until I began to use Git about a year ago.  I had a lot of confusion at the beginning for Git and a somewhat steep learning curve before you can comfortably use it.  

If you have been using TFVC for many years, It is natural that people do not want to give up what they used to and embrace the new way to do things unless they have to.  

Here I listed the steps of the life cycle from the start to the end for both TFVC and Git. So you will have an idea what you need to do differently.  This helps you to know what is ahead of the road if you need to take a different route.  

1. TFVC:  
Clone the project, check out the file, working on the change, testing, check in the change.  Deploy the code to prod.  

<img src="/images/blog46/TFS.PNG">   

Note:TFS is centralized model, you will need to connect to the server to check out and check in. The history is only kept at the server side.  
  

2. Git:  
* Clone the project  
* You will create a new branch from master branch, this new branch is a copy of master branch  
* Working on the new branch  
* Periodically commit the change and push the change to your new branch at remove server (it calls origin)  
* Testing  
* Deploy the change by merging the branch to master branch (pull request)  
* Delete the new branch generated before.  


<img src="/images/blog46/Git.PNG"> 

