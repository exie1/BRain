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
    '1' - '15sd_500time_16res',         # Baseline
    '2' - '15sd_1000time_16res',        # Longer time
    '3' - '25sd_500time_16res',         # Higher detection threshold
    '4' - '15sd_500time_20res',         # Higher histogram resolution
    '5' - '25sd_1000time_16res',        # Higher detection threshold and time
    '6' - '25sd_1000time_20res',        # Higher detection threshold, time and resolution
    '7' - '25sd_1000time_22res',        # Even higher resolution
    '8' - '25sd_1000time_24res'         # Highest resolution we tried
    '9' - 'spont_25sd_1000time_20res'   # Control dataset (no stimulus)
"""

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
from sklearn.preprocessing import StandardScaler

# Algorithms
from sklearn.ensemble import RandomForestClassifier
from sklearn import svm
from sklearn.neighbors import KNeighborsClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.model_selection import cross_val_score
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.neural_network import MLPClassifier

# Accuracy Metric
scorer = make_scorer(metrics.accuracy_score, greater_is_better=True)

def getDataFileName(datakey):
    return {'1' : '15sd_500time_16res.mat',
            '2' : '15sd_1000time_16res.mat',
            '3' : '25sd_500time_16res.mat',
            '4' : '15sd_500time_20res.mat',
            '5' : '25sd_1000time_16res.mat',
            '6' : '25sd_1000time_20res.mat',
            '7' : '25sd_1000time_22res.mat',
            '8' : '25sd_1000time_24res.mat',
            '9' : 'spont_25sd_1000time_20res.mat'
    }[datakey]

def getModel(modelkey):
    return {'SVC': GridSearchCV(svm.SVC(kernel='rbf', gamma='scale', decision_function_shape='ovr', break_ties=True),
                   param_grid={'C': np.logspace(0,3,20)}, scoring=scorer, verbose=0),
            'RFC': GridSearchCV(RandomForestClassifier(criterion='entropy', random_state=42),
                   param_grid={'n_estimators':np.arange(10,30), 'max_depth':np.arange(18,22)}, scoring=scorer, verbose=0),
            'KNN': GridSearchCV(KNeighborsClassifier(),
                   param_grid={'n_neighbors':np.arange(1,30)}, scoring=scorer, verbose=0),
            'GNB': GridSearchCV(GaussianNB(),
                   param_grid={'var_smoothing':np.logspace(-11,-4)}, scoring=scorer, verbose=0),
            'GBC': GridSearchCV(GradientBoostingClassifier(),
                   param_grid={'n_estimators':np.arange(1,200,50)}, scoring=scorer, verbose=0),
            'MLP': GridSearchCV(MLPClassifier(solver='lbfgs', random_state=42),
                   param_grid={'hidden_layer_sizes':np.arange(90,110,2)}, scoring=scorer, verbose=0)
    }[modelkey]

def trainModel(modelkey, datakey, con_mat, f=None):

    # Load training and testing data
    feature_matrix = loadmat(getDataFileName(datakey))
    data = feature_matrix['feature_matrix']
    X = data[:, 0:data.shape[1]-1]
    Y = data[:, -1]
    if modelkey == 'MLP': X = StandardScaler().fit_transform(X)
    X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.25, random_state=42)

    # Model Training
    grid = getModel(modelkey)
    grid.fit(X_train, Y_train)
    print(grid.best_params_)

    # Model Evaluation
    Y_pred = grid.best_estimator_.predict(X_test)
    print(metrics.classification_report(Y_test, Y_pred))
    scores = cross_val_score(grid.best_estimator_, X, Y, cv=5)
    print("%0.2f accuracy with 95%% confidence interval of ± %0.2f" % (scores.mean(),
            1.96*(scores.std()/np.sqrt(len(scores)))))

    if f is not None:
        f.write('\n' + metrics.classification_report(Y_test, Y_pred))
        f.write('\n' + "%0.2f accuracy with 95%% confidence interval of ± %0.2f" % (scores.mean(),
            1.96*(scores.std()/np.sqrt(len(scores)))))

    if con_mat:
        rc = {'figure.figsize':(16,12),
            'axes.facecolor':'white',
            'axes.grid' : True,
            'grid.color': '.8',
            'font.family':'Times New Roman',
            'font.size' : 32,
            'grid.linewidth' : 0}
        plt.rcParams.update(rc)
        metrics.plot_confusion_matrix(grid.best_estimator_, X_test, Y_test)
        plt.savefig(getDataFileName(datakey).split('.')[0] + '.jpg')

# Generate the performance statistics in the report as a txt file.
with open("model_perfstats.txt", 'w') as f:
    modelkey = 'SVC'
    datakeys = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
    for datakey in datakeys:
        f.write('\n' + '#############################\n{}\n#############################'.format(datakey))
        trainModel(modelkey, datakey, False, f)