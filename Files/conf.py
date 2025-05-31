# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'Your Project Name'
copyright = '2025, Data Science Team'
author = 'Data Science Team'
release = '1.0'

import os
import sys
sys.path.insert(0, os.path.abspath('..'))
#sys.path.insert(0, os.path.abspath('../projects/maths'))

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration



extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.viewcode',
    'sphinx.ext.napoleon'
]

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']



# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']

if __name__ == '__main__':
    print(os.path.dirname(__file__))
    
    # print(os.path.abspath('../..'))
    
    print(os.path.abspath('..'))