---
layout: post
title: How to Handle Textual Features along with Other Features in Machine Learning
---

When working on a real-life data science project. You will realize there are things you might not expect from what you learn in school.  
1. You spend the majority of your time working on data prep and data preprocessing.  
2. You will need to handle all kinds of data, not just numeric and categorical.  
 
Scikit learn’s pipeline will greatly simplify the data prep and make it much easier that you can apply the exact same data prep logic to up-coming new data. But in real work, you often come across text type data, like notes, or social media text saved in the database.  Those could be important features, which means you will have to use text mining techniques. People usually stay away from those due to challenges. It is a pity that we cannot take advantage of that, oftentimes then not, it could improve overall model performance.  

Text is a bit trickier than other types of data in that you usually have to clean it and then vectorize it before it can be put into use. Other forms of dataset, like audio and image, which by default is already in a numpy array format. Therefore, those are relatively easier to incorporate than text.  

Before I write this, I only see a blog discussing this. I would suggest people take a look since the author mentioned two different ways when you are using scikit and deep learning networks.  One issue with the blog is the author did not provide a source dataset, so it is hard for readers to repeat the work.  

<https://towardsdatascience.com/how-to-combine-textual-and-numerical-features-for-machine-learning-in-python-dc1526ca94d9>

Here, I would like to show how I go about it with an example via scikit learn framework.  

I use Womens Clothing E-Commerce Reviews dataset.  This dataset contain numeric, categorical and text field.  You can download the dataset [here](/Files/Womens Clothing E-Commerce Reviews.zip) to follow along.  

First, we import all packages that will be used in the analysis.   

