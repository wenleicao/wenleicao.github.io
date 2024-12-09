---
layout: post
title: A Working Machine Learning Model REST API
---

After you create a model, if you would like other IT developers to inference from the model. API would be the best interface between you and others.  Even a web developer does not understand python, who still can render predictions via API.
There are three approaches in Python you can use to create an API,   using Flask, Django, and Fastapi.  For beginners, Flask might be a better choice.
I tried to follow some blogs to build a machine learning API.  They usually cover theory very well, but once I try to repeat the experiment, it often fails, partly because the environment might be different. Or the related packages have been updated since the post published, the original code is not able to run any more.  
The following is the blog I have read.  

This one is data science related. But when I clone the project and try to repeat, I get 400 error from both notebook and http requests. Still not sure what the problem is.  
<https://towardsdatascience.com/deploying-a-machine-learning-model-as-a-rest-api-4a03b865c166>

This following one extends my knowledge with server and client example, but not data science specific though.  
<https://medium.com/@muhammadirfan92/creating-and-deploying-a-simple-flask-api-server-and-client-side-7d4f5690551>  

I experienced a lot of errors, I would suggest you start from simple by creating an API without a machine learning model. Once that works, we add model prediction and parameter in. That makes trouble-shooting much easier.  

If you would like to follow up, this is my folder structure.    
<img src="/images/blog63/folder_structure.JPG">  

Let us make a simple flask API without machine learning model  
<img src="/images/blog63/flask_simple_api.JPG"> 
In this helloworld example,
Row 3: import necessary package. “jsonify” automatically sets the correct response headers and content type for JSON responses.  
Row 5: instantiate a Flask object, using file name as name.  
Row 8: using decorator function app.route, to establish endpoint for interaction, Method argument contains "GET".  There are a couple of different methods for API action. Like GET, POST, DELETE, PUT et al.  For data science purposes, the user requests predictions, therefore, GET is the usual action used here.  The "/hello" here is to define the endpoint address as root address/hello.  
Row 9-12. Indicate when endpoint receive get request, this function will return "Hello world"
Row 15-16, is used for local unit test to stand up the endpoint

If I run the following command at command prompt:  
<img src="/images/blog63/flask_simple_api_command.JPG"> 

Notice, I am using conda to manage the environment.  First I change the environment to ai (activate ai), where your flask and other packages are installed.  
If you would like to get the same env as me, I have the ai.yml file in the download at the end of the post and just need to import this environment in anaconda.  
You can see the endpoint is running from the last row.  If you go to this address in your browser http://127.0.0.1:5000/hello
The result shows as follows. 
<img src="/images/blog63/flask_simple_result.JPG">  

Great, that indicates our process works as expected. We can then add a data science component in.  
The idea is to let users input necessary feature values and the model will spit out predictions and return that  to the users.  
Let us use iris dataset to create a simple random forest model and pickle it outside the main python file to simulate our normal work process.  Inside the main python file, we can load the pickled model and take user input values and return the prediction.  
Let us create a machine learning model first. The codes are inside rest_api_model.ipynb.  

<img src="/images/blog63/model_import package.JPG">  
Iris is contained in the Sklearn datasets.  We just need to import it and I also import other packages in cell2  for preprocessing data and evaluating  model performance. I  also imported joblib for pickling model purposes. But I later noticed this package did not work with flask. I used pickle package instead.

<img src="/images/blog63/model_import_data.JPG"> 
Here I saved features in X and target in y.  Original data only contain 0, 1, 2 as labels. I use map function to convert it to string for user friendly purposes.

<img src="/images/blog63/model_data_split.JPG">  
The original data was divided into train and test.  

<img src="/images/blog63/model_created.JPG">   

I imported the random forest classifier, using it to fit a model with train data.
Then the model predicted unseen test data and used it to compare with actual.  Looks the model perform well and we get 97% accuracy.   
For our purpose, user will send one request at a time. In that case, we will still need to keep data structure like dataframe because the model was trained as dataframe and it expected that.  Therefore, I need to use to_frame and T to convert data series to like original data as follows 

<img src="/images/blog63/model_simulate_single_record_request.JPG">   
I mentioned joblib gave me some trouble. It works fine in the notebook. But whenever I use it in python file with flask. It always complained about the unpickle version issue.  I ended up using the pickle package without any problem.  

<img src="/images/blog63/model_test_pickled.JPG">  

Ok, we have the pickled model now with the name iris_rf_model2.pkl. Let us work on the API file to integrate the model into it. To avoid overwriting previous main.py,  I actually save as different file name main_with_ds_model.py   

<img src="/images/blog63/flask_model_import.JPG">     

let me explain something different from the last api file.  
Row 1-4, import additional package, here include pickle for load, pandas for handling data. I thought the random forest classifier might be needed. Obviously, when I comment out, it still works. So it is optional.
Row 8 -10, model is loaded using pickle package.
Row 12, I defined a new endpoint for this. 
Row 15-18, we will need to parse user input, so this model takes four features. I use request.args.get function to retrieve variable value and save into internal variable. 
Row 20-25, I save user input into a param dictionary 

<img src="/images/blog63/flask_model_predict.JPG"> 

Row 29, Likewise, I structure user input data the way model like to see as dataframe
Row 30, get prediction, this is an array. I just have one value, so use [0]
Row 33-36, return user input and prediction.  

Let us set up the endpoint by doing so,  

<img src="/images/blog63/run_new1.JPG"> 

then we put in request with parameters like so. 
<img src="/images/blog63/model_prediction1.JPG">

try different set of parameters.
<img src="/images/blog63/model_predicton2.JPG">

As you can see, different parameters have different results. That indicate the API is fully functional.
This is the first steps.  There are actually a lot things can improve.  The following blog post is on this topic in depth.  
<https://auth0.com/blog/developing-restful-apis-with-python-and-flask/>  

I hope this post can help you better understand flask. You can find all related file in this zip file [here](/Files/flask.zip). 

thanks for following along.

Wenlei
