---
layout: post
title: Kaggle Notebook Tips
---

You might have been working on Jupyter notebook, VS Code, Google Colab.  Kaggle notebook is yet another one if you plan to join the competition. You don’t need to learn specifically for Kaggle notebook, because most skills you used in others still apply. But Kaggle notebook geared more toward Kaggle competition.   So I try to leverage those features which are unique to Kaggle notebook to maximize the benefits of what Kaggle notebook has to offer.  

I try to explore the follow common scenario:

* If I need to repeatedly use the same environment, how can I use the one I created before and not need to retype commands again?

You can save the notebook with the installation command as utility script (File>set as utility script).  Then in your main notebook, you can import the utility script.

I would like to install RAPIDS and use it speed up with data manipulation and machine learning    
<img src="/images/blog68/1.test_rapids_env.png">   

In the main notebook, you input it as utility script  
<img src="/images/blog68/1.input_utility_scipt.png">   

You can then use it in the new notebook. What I observe is the new notebook will install the package again. But you don't have to remember the command.  
in this case, I import package and check the version.  
<img src="/images/blog68/1.import_package.png">   

2.  What if you refactor your function and save it in a Github repo, how are you able to load it?

3.  

