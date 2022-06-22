---
layout: post
title: Custom Python Functions Used in Exploratory Data Analysis
---

A thousand miles begins with a single step. Similarly, any fancy machine learning begins with  exploratory data analysis (EDA). Because of that, you would think there will be a lot of resources for this. Surprisingly, it is not. Let us google the best book for EDA.  Here are two top links for EDA from google search.  

<https://www.kaggle.com/getting-started/173448>

<https://www.quora.com/What-is-a-good-book-on-exploratory-data-analysis>

The first link gave us a few more kaggle links with some experts in the field sharing their notebooks, which did enlighten me quite a bit. In the second link, a few people mentioned a book authored by John Tukey, named “Exploratory Data Analysis”. This book was first published in 1977. I don’t question the theory of the book. But it will not teach you too much about using python to do EDA.   

After reading a few Kaggle articles and data science blogs, I think the following links are very helpful. They provide different perspectives that how others do this part.  You might want to read it over.    

* regression  
<https://www.kaggle.com/code/pmarcelino/comprehensive-data-exploration-with-python/notebook>  

* classification  plus methodology  minimal model to chubby model and monitor model performance   
<https://www.kaggle.com/code/pmarcelino/data-analysis-and-feature-extraction-with-python/notebook>

* NLP  
<https://towardsdatascience.com/sentiment-analysis-with-text-mining-13dd2b33de27>

* visualize  variable relationship  
<https://towardsdatascience.com/exploratory-data-analysis-eda-python-87178e35b14>  

I personally do not like to keep repeating myself. But if you have a different project, you might have to repeat the similar process. Therefore, I would like to make those commonly used processes into functions. So that, I can just save the function somewhere and call it when I need it.  

In this blog, I would like to share how I go about doing EDA using the Titanic dataset. I just started my collections, these functions are not fully tested. So they might be buggy.  Please let me know if you have issues.    

<img src="/images/blog49/1package.PNG">  

First I imported common packages, then added the function folder to the module search path at row 11 so that the system could find the function file.  Then import EDA_function.py  file at row 12. This file  contains all functions needed. Please change your folder accordingly (either absolute or relative  path will do).  

Seaborn has some built-in datasets. I will use the Titanic dataset as an example.  

<img src="/images/blog49/2importdataset.PNG">  

I am going to touch several aspects of EDA  
1.  overall EDA  
2.  further EDA on data variation and dup  
3.  further EDA on data missing or inf  (inlier)  
4.  further EDA on data with outlier   
5.  further EDA on feature correlation  
6.  further EAD on feature selection  







