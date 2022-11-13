---
layout: post
title: How to Evaluate Your Model
---

Given a scenario, after a few days of hard work,  you have a model built, are you done?  
Unfortunately, It is not the end of your data science project, it is a new start of many other things!  

I will need to validate a few things (just my list not exausted one though) so that we know the model is good.  

1. Besides good performance metrics score, what are the important features which support prediction? We can use business knowledge to cross check. We can ask ourselves,  Does that make sense?
2. It would be good to check visually whether model is overfitting and underfitting
3. If it is imbalance data, what threshold is optimized to choose from
4. Other useful chart to check model performance

It is easier to explain with an example, so let us use the previous project to explore the question we listed.  For details of the previous project, I include the link [here](https://wenleicao.github.io/How_to_Handle_Textual_Features_along_with_Other_Features_in_Machine_Learning/).  

First, I need to import the pickle file I saved from the previous project. In order to do that, I need to import all packages, custom classes, functions used as I know it will run into errors without those.  

<img src="/images/blog52/1import_object.PNG"> 

In cell 8, I imported  sklearn.model_selection object. when you look at the import object, it shows the pipeline detail.

## 1. feature importance   

In some industries, model explainability is crucial. Imagining we built an insurance pricing model, but we cannot explain how the model works.  When we submit the model to the state regulator for approval. We will fail because regulators need to know why we increase insurance premiums. Over the past 20 years, there have been a few important machine learning frameworks such as scikit-learn, deep learning et al.  Depending on different models, scikit-learn generally provides model properties to reveal the model importance; whereas deep learning framework is famous for its blackbox due to hidden layers despite of fairly high performance. 
Since I used scikit-learn in my previous blog, I will focus more on some of the ways in scikit-learn.  

In Dr. Bronlee’s blog, he illustrated three important ways to get feature importance.  

<https://machinelearningmastery.com/calculate-feature-importance-with-python/>  

1. Coefficients as feature importance if it is linear model  
2. Tree based feature importance (Decision tree, Random Forest, XGBoost  et  al )  
3. Permutation feature importance, (Pass scrambled predictors to model to check performance drop to get importance)   

The optimized model in my previous project is logistic regression. It is the linear model, let us use the first method, i.e. coefficient method. We can use name steps to retrieve the model directly from sklearn.model_selection object.   Using its property  coef_,  We can see 153 features.  The particular coefficient  indicates how much impact this feather can impact. Please note, your data needs to be scaled to a similar level.  In my case, all values are scaled between (-1, 1). So the impact between each feature is relatively comparable.  

<img src="/images/blog52/1.5coefficient.PNG">   

With the coefficients in place, we will need to map the feature name to it.  

In my previous blog, I have numeric features, categorical features and text features.  

<img src="/images/blog52/2Features.PNG">   

Num_column, categorical_column, Title in txt_coloumn  and  ‘Review Text’ in txt column passed through pipeline-1 ~ pipeline-4 within the column transformer  respectively.  After the transformation, the results are in the sparse matrix format.  Unlike dataframe, this format does not have column names. So in order to know the feature importance, we will have to retrieve the feature name if they went through something like one hot encoding, which will expand one column to multiple columns.  

Let us see how we get the feature name for the sparse matrix.  
First of all, they follows sequence how you set the pipeline up  (pipeline 1 to pipeline 4).  

* Num_column: just simple imputing and scaling. The column number  has not changed. 
* Categorical  column: it has the  column expanding transformer, onehotEncoder.  Luckily, scikit-learn provides functions such as named_steps, named_transformers (see cell 12 line 5) so that you can navigate to the onehotencoder step.  Then you can use get_feature_names() to get all feature names (not shown in the screenshot, too wide, but in notebook).  Notice here, scikit-learn renamed the three variables (Division, Department, Class) to X0-X2. 
By the way, showing pipeline like cell 11 is helpful for you to navigate complicate transformation
* For text columns, I divide Title and “Review Text” into two pipelines (3 and 4).  Text is tokenized into words (column expanding). We select 20 and 100 important words respectively with selectKBest transformer (column number changed too).  These Text values are later used as column names. 



  



