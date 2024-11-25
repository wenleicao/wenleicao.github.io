---
layout: post
title: Mango vs Optuna in Time Series Modeling
---

For hyperparameter tuning, Scikit-learn has GridSearchCV, RandomSearchCV. Those are good ways to tune hyperparameters. However, it mostly runs through the search space with brute force. Given limited time and resources, people wonder if there are smart ways to do a better job. This is why Bayesian optimization came into picture.  There are quite a few python packages that have Bayesian optimization under the hood. I have been using Optuna.  In the time series prediction field, a lot of posts were using Mango.  I am interested in whether Optuna can do as good as mango and which one is more convenient.

Let us use Sandha's example to see if we can repeat his work and what would be the result if we use Optuna.

[Sandha post](https://medium.com/@sandha.iitr/tuning-parameters-of-prophet-for-forecasting-an-easy-approach-in-python-8c9a6f9be4e8)

In Sandha’s post, he can achieve MAPE as low as 3.95.   

<img src="/images/blog62/original_author_result.JPG">  

I repeated his work with the same code, I can achieve 5.94.  Since the search is stochastic, it is not surprising that number could be slightly different.  

<img src="/images/blog62/old_mape.JPG">

I converted the search space in Optuna format and redo the performance tuning, I found Optuna can do even better with the same search space.  

<img src="/images/blog62/optuna_param.JPG">  

<img src="/images/blog62/optuna_mape.JPG">  

In addition, there are times we try to use other variables for some research other than the model parameters. For example, I would like to see relationship between various prediction horizons (prediction window size) and its MAPE.  Introducing a variable is a breeze in Optuna. Here I include a variable "prediction_horizon_param" and used it later.  

<img src="/images/blog62/addtional_variable.JPG"> 

However, it has been a pain with Mango in my hand (maybe I did not do it right).  You have to deal with various errors and the performance tuning is stalled in the middle. Oftentimes, the error is generic and you are not able to pinpoint the cause and eventually fix the error.   

In my opinion, Optuna can do pretty well in time series study.  Mango maybe has advantage on distributed computing ([link](https://towardsdatascience.com/mango-a-new-way-to-make-bayesian-optimisation-in-python-a1a09989c6d8)), but for personal research and small scale study, I would prefer Optuna unless Mango make it easier for user to use. 

You can find comparison in the [notebook](/Files/time_series_prediction_horizon.ipynb) here. Please note: I have some other testing code with this notebook at the end that you can skip safely.  

thanks 

Wenlei
