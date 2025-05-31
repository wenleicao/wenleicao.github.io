---
layout: post
title: Using Sphinx to Document Python Project in Nested Folders
---

I like creative and smart solutions, when it comes to task preference. Documentation is usually my least favorite type of job. What if you were told that there is a package to help you do documentation? Like you, I cannot wait to give it a shot.   

Sphinx is a powerful documentation tool for python users. [This post](https://towardsdatascience.com/documenting-python-code-with-sphinx-554e1d6c4f6d/) will give you a quick start on that.  But my python projects is more invovled than the simple example. Unfortunately, Sphinx documentation does not seem to help me sort out the issues I come across.  

I have to read a lot of online posts and blogs, solve the puzzle by trial and error. This is what I learned along the way.    

1. You will need to install the sphinx in every environment your project runs. I have tried to generate documentation using sphinx installed in a separate environment. It can export the rst files without issue, but will run into errors when making html.  
2. a potential pitfall, when installing sphinx, you are changing your current environment. With some critical packages updated. That could potentially impact the results. Therefore, a system testing after installation is necessary.  
3. Besides installing sphinx, you are also required to install sphinx_rtd_theme if you plan to use it in place of the default theme for html.  
4. Most tutorials put the docs folder side by side with the project folder, which may be fine for a simple project. But a real project could usually contain many layers of folders, some even have more than one project in one folder. For example, I have a project folder like this.  
<img src="/images/blog66/folder_structure.png">   

Here module means a python file, which could contain multiple functions and classes. Ellipses means there are many similar items.   
Let us say, I completed project1 and project2 is still ongoing. I need to document project1, where do you place the docs folder?  under Projects folder, side by side with Projects folder, or outside of Projects folder.  

There is lots of confusion around this. I have tried almost all solutions provided in these two links. For example, set the project1 path directly in sys.path. It will create rst files fine, but you will have issues to build html later.  

<https://stackoverflow.com/questions/17086273/specifying-a-relative-path-in-sphinx-conf-py-for-collaborative-documentation>  
<https://stackoverflow.com/questions/10324393/sphinx-build-fail-autodoc-cant-import-find-module>  

The only working solution is setting the docs folder outside projects folder in my hands. That will create docs for not only project1, project2, as well as all folders under the projects. So don’t overthink about the path. Sphinx already takes care of nested folder structure for you. Would not be better if they tell you in their own documentation?  

This is the acutal folder structure.  
<img src="/images/blog66/folder_structure2.PNG">     

This is the html files generated.  
<img src="/images/blog66/output_doc_structure.PNG">   

I block the project name to protect privacy. shoud not affect your understanding.     
My conf file for this documentation project is like [this](/Files/conf.py)   
Hope this helps others.   

Wenlei





