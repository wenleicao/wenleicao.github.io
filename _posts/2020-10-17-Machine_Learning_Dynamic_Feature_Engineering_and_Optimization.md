---
layout: post
title: Machine Learning Dynamic Feature Engineering and Optimization
---

Machine learning empower you to explore the deep relation between your data and result. In order to examine the deep relationship, you might need to do some feature engineering. The most common example, you can combine two features to get a more correlated new feature. Occasionally , you might need to generate feature dynamically while you examine the intrinsic relationship.  When I say dynamically, I mean the feature value is based on certain parameter of its own. Let me give you an example.  

If you have bought or sold stock, you will see people are playing indicators like moving average (MA),   Relative Strength Index (RSI)… on stock applications. When the application shows you the indicator,  it has done calculation behind scene with certain param, for example, RSI, using pervious 14 day data for calculate RSI value.  You also may use RSI default value 30 (oversell) and 70 (overbuy) to guide you buy or sell. Since each stock has their own personality, Some are more volatile than others. Experienced traders usually do not use default number. They have their own best parameters. Can machine learning help us to find those secret number?  

Here I just use stock data as an example,  but similar situations can be found in other fields. The goal of this post is not to set a standard for how to do machine learning, but to see how to deal with this situation.        

My goal is try to use current day close price predict next day close with indictor and indictor generated signal.   Indictor and indictor generate signal value can be changed by indicator param. I need to select the best param so that I can get best machine learning score.  

This is what I am going to do.   

1.	Get the stock data, preprocess data   
2.	Create functions that able to handle different type of indicator (I use two, but you can add more)  
3.	Create class that inherits transformer. So we can use pipeline and Gridsearch  
4.	Use pipeline and  Gridsearch to compare to get the optimized param  

## 1. Get the stock data, preprocess data




