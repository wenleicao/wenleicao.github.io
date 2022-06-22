import os
import pandas as pd
import numpy as np
from IPython.display import display
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import norm
from sklearn.preprocessing import StandardScaler
from scipy import stats
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import chi2, f_regression
import sklearn.preprocessing
import warnings
warnings.filterwarnings('ignore')





#EDA related 

class color:
   PURPLE = '\033[95m'
   CYAN = '\033[96m'
   DARKCYAN = '\033[36m'
   BLUE = '\033[94m'
   GREEN = '\033[92m'
   YELLOW = '\033[93m'
   RED = '\033[91m'
   BOLD = '\033[1m'
   UNDERLINE = '\033[4m'
   END = '\033[0m'
   
def eda_overall (df):
    print (color.BOLD + "Get list of column, data type and see if there are data missing" + color.END)
    display(df.info())
    print (color.BOLD + "Get descriptive statistics for numeric column " + color.END)
    display(df.describe())
	
#further EDA on data variation and dup
def eda_showDup(df, uniqCol):
    return df[df.duplicated( keep=False)].sort_values([uniqCol])
#df1 = df.drop_duplicates()	
    

def eda_getMissingData (df):
    total = df.isnull().sum().sort_values(ascending=False)
    percent = (df.isnull().sum()/df.isnull().count()).sort_values(ascending=False)  #isnull change it to boolean array, sum only count with true,which is 1, count cout all
    missing_data = pd.concat([total, percent], axis=1, keys=['Total', 'Percent'])
    return missing_data.query('Total >0') 

def eda_getInfData (df):
    col = list(eda_getNumericColumn (df))
    df_num = df[col]
    ndf = df_num.to_numpy()
    r = []
    for i, _ in enumerate(col):
        x = np.isinf(ndf[:,i]).sum()      
        r.append(x)
    s = pd.DataFrame (r, index = col, columns = ['Inf count'])
    s['Inf Ratio'] = s['Inf count']/df.shape[0]
    return s.sort_values('Inf count', ascending = False)
	

  

def eda_getLowHigh (df,var):
    var_scaled = StandardScaler().fit_transform(df[var][:,np.newaxis]);  #add 1 dimension, this return np array
    low_range = var_scaled[var_scaled[:,0].argsort()][:10]  #sort the array, this returd index
    high_range= var_scaled[var_scaled[:,0].argsort()][-10:]  
    #print('outer range (low) of the distribution:')
    #print(low_range)
    #print('\nouter range (high) of the distribution:')
    #print(high_range)
    return low_range,high_range

def eda_getOutLier (df, devnum):
    import math
    df1= pd.DataFrame(df.describe()).transpose()
    inflist = list(df1[df1['max'] == math.inf].index)   # containing inf column list

    numerics = ['int16', 'int32', 'int64', 'float16', 'float32', 'float64']
    Numeric_column = df.select_dtypes(include=numerics).columns

    b = []
    l= list(Numeric_column)
    #l.remove('Car.Per.Driver')  #contain inf
    l = [i for i in l if i not in  inflist] 

    devnum = devnum
    for c in l:        
        b1, b2 = eda_getLowHigh (df,c)
        if min(b1) <-1*devnum or max(b2) >devnum:
            b.append (c)
    print (f'outlier standard is out of {devnum} standard deviation \n' )
    print(b)

    
def eda_getCorrelation (df, targetcolumn):
    corr_matrix = df.corr()
    print(corr_matrix[targetcolumn].sort_values(ascending=False))
    

def eda_corr_scatter_matrix (df, xlist):
    from pandas.plotting import scatter_matrix
    if (type(xlist) == list):
        print("OK")
        scatter_matrix(df[xlist], figsize=(12, 8))      
        
    else:
        'please pass in a list argument'
		
        
        
def eda_show_distribution(var_data):
    from matplotlib import pyplot as plt

    # Get statistics
    min_val = var_data.min()
    max_val = var_data.max()
    mean_val = var_data.mean()
    med_val = var_data.median()
    mod_val = var_data.mode()[0]

    print('Minimum:{:.2f}\nMean:{:.2f}\nMedian:{:.2f}\nMode:{:.2f}\nMaximum:{:.2f}\n'.format(min_val,
                                                                                            mean_val,
                                                                                            med_val,
                                                                                            mod_val,
                                                                                            max_val))

    # Create a figure for 2 subplots (2 rows, 1 column)
    fig, ax = plt.subplots(2, 1, figsize = (10,4))

    # Plot the histogram   
    ax[0].hist(var_data)
    ax[0].set_ylabel('Frequency')
    #ax.set_xscale('log')

    # Add lines for the mean, median, and mode
    ax[0].axvline(x=min_val, color = 'gray', linestyle='dashed', linewidth = 2)
    ax[0].axvline(x=mean_val, color = 'cyan', linestyle='dashed', linewidth = 2)
    ax[0].axvline(x=med_val, color = 'red', linestyle='dashed', linewidth = 2)
    ax[0].axvline(x=mod_val, color = 'yellow', linestyle='dashed', linewidth = 2)
    ax[0].axvline(x=max_val, color = 'gray', linestyle='dashed', linewidth = 2)

    # Plot the boxplot   
    ax[1].boxplot(var_data, vert=False)
    ax[1].set_xlabel('Value')

    # Add a title to the Figure
    fig.suptitle('Data Distribution')

    # Show the figure
    fig.show()
 
#check if the column is date
def eda_isDateColumn (s):
    x = True 
    try: 
        pd.to_datetime(s, format='%Y.%m.%d')
    except:
        x = False
    return x


#https://stackoverflow.com/questions/61529345/how-can-i-check-whether-a-scipy-distribution-is-discrete
#only recognize object not list, so not that useful for detect discrete or continous
def is_discrete(dist):

    if hasattr(dist, 'dist'):
        return isinstance(dist.dist, rv_discrete)
    else: return isinstance(dist, rv_discrete)

def is_continuous(dist):

    if hasattr(dist, 'dist'):
        return isinstance(dist.dist, rv_continuous)
    else: return isinstance(dist, rv_continuous)
	
def eda_feature_variance_ratio (df): 
    a = pd.DataFrame(df.nunique()).reset_index()
    a.columns = ['column', 'count']
    a['unique/total'] =  a['count'] / len(a)
    return a.sort_values('unique/total', ascending = False)



	
def eda_getNumericColumn (df):
    numeric_column = [c for c in list(df.columns) if pd.api.types.is_numeric_dtype(df[c]) and not pd.api.types.is_bool_dtype(df[c]) ]
    return numeric_column
    
def eda_getCategoricalColumn (df):
    categorical_column = [c for c in list(df.columns) if pd.api.types.is_object_dtype(df[c]) and not eda_isDateColumn (df[c]) ]
    return categorical_column
	
def eda_getOutlierBoxPlot (df, col):
    sns.boxplot(y =col, data = df )

def eda_getHistPlot (df, col):
    sns.distplot(df[col], fit=norm)
	
def eda_getBulkPlot(df, cols, plotFun):
	cols = cols
	for i, col in  enumerate (cols) :
		plt.figure(i)
		plotFun(df, col)
	
    
def eda_getScatterPlot(df, xvar, yvar):
    data = pd.concat([df[yvar], df[xvar]], axis=1)
    data.plot.scatter(x=xvar, y=yvar, ylim=(0 if df[yvar].min() >0 else df[yvar].min() , df[yvar].max() +df[yvar].max()*0.1));
    
def eda_getBoxplot (df, xvar, yvar):
    data = pd.concat([df[yvar], df[xvar]], axis=1)
    f, ax = plt.subplots(figsize=(8, 6))
    fig = sns.boxplot(x=xvar, y=yvar, data=df)
    fig.axis(ymin= 0 if df[yvar].min() >0 else df[yvar].min() , ymax=df[yvar].max() +df[yvar].max()*0.1);
    if len(df[xvar].unique()) > 20:  #if x variable too many
        plt.xticks(rotation=90)
        
def eda_getCorrlationHeatMap (df):
    corrmat = df.corr()
    f, ax = plt.subplots(figsize=(12, 9))
    sns.heatmap(corrmat, vmax=.8, square=True,  cmap = 'RdYlGn', center=0.11);
    

def eda_getTopKCorrelatedColumnHeatMap (df, k, yvar ):
    corrmat = df.corr()
    cols = corrmat.nlargest(k, yvar)[yvar].index
    cm = np.corrcoef(df[cols].values.T)
    sns.set(font_scale=1.25)
    hm = sns.heatmap(cm, cbar=True, annot=True, square=True, fmt='.2f', annot_kws={'size': 10}, yticklabels=cols.values, xticklabels=cols.values,cmap = 'RdYlGn', center=0.11)
    plt.show()
    
#col_list =  ['SalePrice', 'OverallQual', 'GrLivArea', 'GarageCars', 'TotalBsmtSF', 'FullBath', 'YearBuilt']

def eda_getPairPlot(df, col_list):
    sns.set()
    sns.pairplot(df[col_list], size = 2.5)
    plt.show()
	
	
#https://johaupt.github.io/blog/columnTransformer_feature_names.html

def get_feature_names(column_transformer):
    """Get feature names from all transformers.
    Returns
    -------
    feature_names : list of strings
        Names of the features produced by transform.
    """
    # Remove the internal helper function
    #check_is_fitted(column_transformer)
    
    # Turn loopkup into function for better handling with pipeline later
    def get_names(trans):
        # >> Original get_feature_names() method
        if trans == 'drop' or (
                hasattr(column, '__len__') and not len(column)):
            return []
        if trans == 'passthrough':
            if hasattr(column_transformer, '_df_columns'):
                if ((not isinstance(column, slice))
                        and all(isinstance(col, str) for col in column)):
                    return column
                else:
                    return column_transformer._df_columns[column]
            else:
                indices = np.arange(column_transformer._n_features)
                return ['x%d' % i for i in indices[column]]
        if not hasattr(trans, 'get_feature_names'):
        # >>> Change: Return input column names if no method avaiable
            # Turn error into a warning
            warnings.warn("Transformer %s (type %s) does not "
                                 "provide get_feature_names. "
                                 "Will return input column names if available"
                                 % (str(name), type(trans).__name__))
            # For transformers without a get_features_names method, use the input
            # names to the column transformer
            if column is None:
                return []
            else:
                return [name + "__" + f for f in column]

        return [name + "__" + f for f in trans.get_feature_names()]
    
    ### Start of processing
    feature_names = []
    
    # Allow transformers to be pipelines. Pipeline steps are named differently, so preprocessing is needed
    if type(column_transformer) == sklearn.pipeline.Pipeline:
        l_transformers = [(name, trans, None, None) for step, name, trans in column_transformer._iter()]
    else:
        # For column transformers, follow the original method
        l_transformers = list(column_transformer._iter(fitted=True))
    
    
    for name, trans, column, _ in l_transformers: 
        if type(trans) == sklearn.pipeline.Pipeline:
            # Recursive call on pipeline
            _names = get_feature_names(trans)
            # if pipeline has no transformer that returns names
            if len(_names)==0:
                _names = [name + "__" + f for f in column]
            feature_names.extend(_names)
        else:
            feature_names.extend(get_names(trans))
    
    return feature_names


def eda_getKBestFeatures (df, k, numeric_features, categorical_features, score_func ):   #classification use chi2, regression: f_regression
    from sklearn.compose import ColumnTransformer
    from sklearn.pipeline import Pipeline
    from sklearn.impute import SimpleImputer
    from sklearn.preprocessing import  MinMaxScaler, OneHotEncoder
    numeric_transformer = Pipeline(steps=[("imputer", SimpleImputer(strategy="median")), ("scaler", MinMaxScaler())])
    categorical_transformer = OneHotEncoder(handle_unknown="ignore")
    preprocessor = ColumnTransformer(
    transformers=[
        ("num", numeric_transformer, numeric_features),
        ("cat", categorical_transformer, categorical_features),  ]
    )
    X= preprocessor.fit_transform(df)
    y = df['survived']
    select = SelectKBest(score_func=score_func, k=k)
    features = get_feature_names(preprocessor)
    select.fit(X, y)
    filter = select.get_support()
    return pd.Series(features)[filter]

    
def eda_plot_learning_curve(estimator, title, X, y, ylim=None, cv=None,
                        n_jobs=1, train_sizes=np.linspace(.1, 1.0, 5)):
    plt.figure()
    plt.title(title)
    if ylim is not None:
        plt.ylim(*ylim)
    plt.xlabel("Training examples")
    plt.ylabel("Score")
    train_sizes, train_scores, test_scores = learning_curve(
        estimator, X, y, cv=cv, n_jobs=n_jobs, train_sizes=train_sizes)
    train_scores_mean = np.mean(train_scores, axis=1)
    train_scores_std = np.std(train_scores, axis=1)
    test_scores_mean = np.mean(test_scores, axis=1)
    test_scores_std = np.std(test_scores, axis=1)
    plt.grid()

    plt.fill_between(train_sizes, train_scores_mean - train_scores_std,
                     train_scores_mean + train_scores_std, alpha=0.1,
                     color="r")
    plt.fill_between(train_sizes, test_scores_mean - test_scores_std,
                     test_scores_mean + test_scores_std, alpha=0.1, color="g")
    plt.plot(train_sizes, train_scores_mean, 'o-', color="r",
             label="Training score")
    plt.plot(train_sizes, test_scores_mean, 'o-', color="g",
             label="Validation score")

    plt.legend(loc="best")
    return plt
    
def eda_plot_validation_curve(estimator, title, X, y, param_name, param_range, ylim=None, cv=None,
                        n_jobs=1, train_sizes=np.linspace(.1, 1.0, 5)):
    train_scores, test_scores = validation_curve(estimator, X, y, param_name, param_range, cv)
    train_mean = np.mean(train_scores, axis=1)
    train_std = np.std(train_scores, axis=1)
    test_mean = np.mean(test_scores, axis=1)
    test_std = np.std(test_scores, axis=1)
    plt.plot(param_range, train_mean, color='r', marker='o', markersize=5, label='Training score')
    plt.fill_between(param_range, train_mean + train_std, train_mean - train_std, alpha=0.15, color='r')
    plt.plot(param_range, test_mean, color='g', linestyle='--', marker='s', markersize=5, label='Validation score')
    plt.fill_between(param_range, test_mean + test_std, test_mean - test_std, alpha=0.15, color='g')
    plt.grid() 
    plt.xscale('log')
    plt.legend(loc='best') 
    plt.xlabel('Parameter') 
    plt.ylabel('Score') 
    plt.ylim(ylim)
    





