# %%
"""
MODEL KEYS:
    SVC - Support Vector Classifier
    RFC - Random Forest
    KNN - K-Nearest Neighbours
    GNB - Gaussian Naive Bayes
    GBC - Gradient Boosting Classifier
    MLP - Multi-Layer Perceptron

DATA PROPERTIES:
    spont - LFP data recorded when no stimulus was perceived by the animal.
    sd(1.5/2.5) - threshold sd value for gamma burst detection
    time (500/1000) - time period over which gamma burst patterns where detected
    res(16,20,22,24) - resolution of the probability density map (number of histogram bins)

DATA KEYS: 
    '1' - '15sd_500time_16res',     # Baseline
    '2' - '15sd_1000time_16res',    # Longer time
    '3' - '25sd_500time_16res',     # Higher detection threshold
    '4' - '25sd_1000time_16res',    # Higher detection threshold and time
    '5' - '25sd_1000time_20res',    # Higher detection threshold, time and resolution
    '6' - '25sd_1000time_22res',    # Even higher resolution
    '7' - '25sd_1000time_24res'     # Highest resolution we tried
"""
# Define the data to use and model to train
modelkey = 'SVC'
datakey = '1'

# Basic Tools
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
import seaborn as sns
import pandas as pd

# Preprocessing, Training and Evaluation
from scipy.io import loadmat
from sklearn.model_selection import train_test_split
from sklearn.model_selection import GridSearchCV
from sklearn import metrics
from sklearn.metrics import make_scorer

# Algorithms
from sklearn.ensemble import RandomForestClassifier
from sklearn import svm
from sklearn.neighbors import KNeighborsClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.model_selection import cross_val_score
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.neural_network import MLPClassifier

def getDataFileName(datakey):
    return {'1' : '15sd_500time_16res.mat',
            '2' : '15sd_1000time_16res.mat',
            '3' : '25sd_500time_16res.mat',
            '4' : '25sd_1000time_16res.mat',
            '5' : '25sd_1000time_20res.mat',
            '6' : '25sd_1000time_22res.mat',
            '7' : '25sd_1000time_24res.mat'
    }[datakey]

# Load training and testing data
feature_matrix = loadmat(getDataFileName(datakey))
data = feature_matrix['feature_matrix']
X = data[:, 0:data.shape[1]-1]
Y = data[:, -1]
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.25, random_state=42)

# Accuracy Metric
scorer = make_scorer(metrics.accuracy_score, greater_is_better=True)

def getModel(modelkey):
    return {'SVC': GridSearchCV(svm.SVC(kernel='rbf', gamma='scale', decision_function_shape='ovr', break_ties=True),
                   param_grid={'C': np.logspace(-2,3,20)}, scoring=scorer, verbose=4),
            'RFC': GridSearchCV(RandomForestClassifier(criterion='entropy', random_state=42),
                   param_grid={'n_estimators':np.arange(10,30), 'max_depth':np.arange(18,22)}, scoring=scorer, verbose=4),
            'KNN': GridSearchCV(KNeighborsClassifier(),
                   param_grid={'n_neighbors':np.arange(1,30)}, scoring=scorer, verbose=4),
            'GNB': GridSearchCV(GaussianNB(),
                   param_grid={'var_smoothing':np.logspace(-11,-4)}, scoring=scorer, verbose=4),
            'GBC': GridSearchCV(GradientBoostingClassifier(),
                   param_grid={'n_estimators':np.arange(1,200,50)}, scoring=scorer, verbose=4),
            'MLP': GridSearchCV(MLPClassifier(solver='lbfgs', random_state=42),
                   param_grid={'hidden_layer_sizes':np.arange(90,110,2)}, scoring=scorer, verbose=4)
    }[modelkey]

# Model Training
grid = getModel(modelkey)
grid.fit(X_train, Y_train)
print(grid.best_params_)

# Model Evaluation
Y_pred = grid.best_estimator_.predict(X_test)
print(metrics.classification_report(Y_test, Y_pred))
scores = cross_val_score(grid.best_estimator_, X, Y, cv=5)
print("%0.2f accuracy with a standard deviation of %0.2f" % (scores.mean(), scores.std()))

rc = {'figure.figsize':(16,12),
      'axes.facecolor':'white',
      'axes.grid' : True,
      'grid.color': '.8',
      'font.family':'Times New Roman',
      'font.size' : 32,
      'grid.linewidth' : 0}
plt.rcParams.update(rc)
metrics.plot_confusion_matrix(grid.best_estimator_, X_test, Y_test)
plt.show()