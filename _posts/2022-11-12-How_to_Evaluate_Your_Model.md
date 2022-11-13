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

In cell 8, I imported  sklearn.model_selection object.  



