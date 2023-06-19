---
layout: post
title: Use Docker to Operationalize the Data Science Prediction 
---

There are many challenges working in machine learning fields. In terms of the time consuming part, one is data preparation, the other one would be operationalizing the model. If you have the right data, building a model actually is a relatively easier part of the whole process.
Let us talk about the operationalization of the model. I have used batch files ([link](https://wenleicao.github.io/Poor_man_automation)) to handle R and python processes and used the task scheduler to schedule a job at a virtual machine in the cloud.  But it is probably not the best way to go because the followings:  

*	It is hard to switch to different visual machine. In other word, the portability is poor.  
*	You are limited in windows machine, whereas majority of servers in the cloud are using Linux based operation system.

Here I want to explore the possibility of using docker to handle data science operations. It is a modern technology and with great potential to solve the issues I list above.  

Docker is a container technology that can package all your artifacts for your application in one folder and move to the host machine (cloud server). Your application will run without worrying about the operating system, hardware and so on. This will fit in with all cloud service 
 vendors like AWS, Azure, GCP, et al. It uses the same concept of container in the shipping industry.  
 
Majority of docker materials and tutorials online are using Nginx or flask, because the end product is a web App. You can easily see the result by browsing the web page.  In my case, I would like to use docker for data science purposes.  Unfortunately, I don’t find a lot of resources online. I think the following sites help me a lot.  

1. Docker tutorial site is good for getting started, but it is not specific for data science.  
<https://docs.docker.com/get-started/>
2. The following site helps me use docker with data science, but the content are a bit dated (not working anymore) and methods are over simplified for real life project.    
<https://mlinproduction.com/docker-for-ml-part-1/>  

I want to achieve the following goals:    
* Being able to build customized docker images for data science purposes.  
* Training and inference processes are getting data from databases (this is common in real life).  
* Try docker compose if there are multiple containers working together (simplify the configuration step).

To run docker in windows environment, you will need the following set up.  
1. Install docker desktop, remember to also check the option to install Windows Subsystem for Linux (WSL2 ). This essentially allows you to have a Linux dev environment in Windows.  
2. Install Ubuntu app from windows store to be able to use Linux shell to interact with docker desktop.  It is a common language in the container world.  
3. In the docker desktop, configure Ubuntu to integrate with docker(WSL Integration, see below). So you can use Ubuntu shell interact with docker.  
4. Install VS code and add extension WSL, so I can use the VS code to view Linux subsystem files and be able to make dockerfile or compose yaml file.

<img src="/images/blog55/intergate_shell_with_docker.JPG">    

Let us take baby steps.  

The first step, I want to be able to replicate what Luigi did, but minor modifications are needed to make it work.   

I will still use Luigi Patruno’s Boston Housing price data for this exploration. But since he published the blog, the dataset source has been changed, the original code is not working any more. So I will need to make changes to it.  

In addition, Luigi used a Jupyter notebook image as his base image, this image is bulky (over 1gb ).  For some reason, I cannot launch a jupyter notebook by connecting to the container from the host even though this container runs without issue and I put in the token as suggested.  Therefore, I changed it to use python image instead.  I use python 3.8 image from docker hub (about 500 mb).  it might be ok to build from scratch such as Alpine.  But I leave it to the future.  

The folder contains the following files.  

<img src="/images/blog55/first_folder_structure.JPG">   

This is the content of dockerfile, which contains  instruction to build an image as a blueprint for a container.  

<img src="/images/blog55/first_dockerfile.JPG">   

Row 1:  get image from docker hub  python:3.8  version  
Row 4:  create folder under home, form home/wcao/model structure  
Row 5-7:  create environment variables to be used in other files. Those are paths and file names  
Row 10:  install packages which were not included in core library of python  
Row 11: move all file from current folder   
Row 13:  run python3 train.py while build the image  

Train.py  
<img src="/images/blog55/first_train.JPG">   
Row 1-11, import necessary packages
Row 17-21, using environment variables to form the model and metadata paths to be used later.
Row 27-36, getting training data. Due to some value was wrapped to 2nd row, there are some data manipulation between 31-33 using np.hstack, then data was divided into train and test









