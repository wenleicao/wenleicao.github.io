---
layout: post
title: Sklearn Pipeline Deep Dive
---

Whoever used the Sklearn pipeline knew how convenient it could be when handling train and test data.  
In this post, I want to deep dive in the Sklearn pipeline.  I will try to answer the following questions. I will answer with a minimal working example (MWE).  
1. By default, a Sklearn transformer will output a numpy (np) array for computation efficiency. Is this always the case in every transformer?  
2. How do we dynamically choose different columns for different pipelines in a column transformer?  
3. People have been complaining about the np array output, as the column names are gone, they cannot tell which is which. This could be important for feature importance analysis.  Sklearn has an option to enable pandas output.  But does it always work?  
4. What if you have to use np array output, are you stuck with the feature name?

<img src="/images/blog67/1data.png"> 

Let us first create a MWE.  I imported all packages necessary and created a dataset containing 4 columns, two categorical, 1 numerical, 1 textual columns.  Here I forgot to create a target. The values might be ['president', 'celebrity', 'grass root'].  That might be a data scientist’s favorite.  Today, we are mainly focusing on the pipeline. I will replace those with an arbitrary list when I need a target down the road.  Please note here, I don’t set output = 'pandas'.  So, the transformer will output np.array by default.
 
Oftentimes than not, you will do some post extraction processes.  That could be something you forget to do in previous steps. Or you could adjust something ad hoc.  Here, I just created a function transformer to add 1 to the age.  I will design the next step to use the age column by name. 
