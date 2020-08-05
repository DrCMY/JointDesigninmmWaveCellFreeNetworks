# Check with multi_est.get_params().keys()
#from dask_ml.model_selection import HyperbandSearchCV
import dask_ml.model_selection as dcv
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import make_scorer
# from sklearn.model_selection import GridSearchCV
# from sklearn.multioutput import MultiOutputClassifier
from sklearn.multioutput import ClassifierChain
from sklearn.multiclass import OneVsOneClassifier, OneVsRestClassifier
from sklearn.neural_network import MLPClassifier
from sklearn.svm import LinearSVC, SVC
import numpy

def printer(best_score,best_params,tparameters):
        print('The best score is ',best_score)
        print('The best parameters are \n',best_params)   
        o1=['The best score is ',str(best_score),'\n'] 
        o2=['The best parameters are \n',str(best_params), '\n']    
        o3=['Total number of hyperparameter combinations tested is ',str(tparameters), '\n']    
        filelog='Results_HyperParam.log'
        fo1 = open(filelog, 'w')
        fo1.writelines(o1)
        fo1.writelines(o2)
        fo1.writelines(o3)
        fo1.close()  

def CommonFunction(est,Xtrain,Ytrain,Xtest,parameters):      
    n_cv=5        # Number of cross-validations
    # multi_est=MultiOutputClassifier(est)
    multi_est=ClassifierChain(est)
    [n_trainsamples,n_decisions] = Ytrain.shape   
    tparameters=1
    for keys in parameters.items():
        tparameters=tparameters*len(keys[1])
    print('Total number of hyperparameter combinations to be tested is',str(tparameters))  
    def ScoreFunction(decision,Y):  # Scoring function                      
        return round(numpy.sum(decision==Y)/(n_trainsamples*n_decisions)*100*n_cv,2)
    score=make_scorer(ScoreFunction, greater_is_better=True)     
    multi_est_GS=dcv.GridSearchCV(multi_est,param_grid=parameters,scoring=score,cv=n_cv,n_jobs=-1).fit(Xtrain, Ytrain)   
    decision =multi_est_GS.predict(Xtest)                                      
    printer(multi_est_GS.best_score_,multi_est_GS.best_params_,tparameters)    
    return decision

def MultiLabel_LinearSVC(Xtrain,Ytrain,Xtest):  
    from AIAlgorithmsParameters_AI_v01 import LinearSVCParameters
    parameters= LinearSVCParameters() 
    est=OneVsOneClassifier(LinearSVC(random_state=1))   
    decision=CommonFunction(est,Xtrain,Ytrain,Xtest,parameters)
    return decision

def MultiLabel_SVC(Xtrain,Ytrain,Xtest):        
    from AIAlgorithmsParameters_AI_v01 import SVCParameters
    parameters= SVCParameters() 
    #est=OneVsOneClassifier(SVC(random_state=1))   
    est=OneVsRestClassifier(SVC(random_state=1))   
    decision=CommonFunction(est,Xtrain,Ytrain,Xtest,parameters)       
    return decision
 
def MultiLabel_MLP(Xtrain,Ytrain,Xtest):     
    from AIAlgorithmsParameters_AI_v01 import MLPParameters
    parameters= MLPParameters()
    [n_testsamples,n_features] = Xtrain.shape
    est = MLPClassifier(hidden_layer_sizes=(n_features,n_features), batch_size=min(1000, n_testsamples), random_state=1)
    decision=CommonFunction(est,Xtrain,Ytrain,Xtest,parameters)
    return decision

def MultiLabel_RF(Xtrain,Ytrain,Xtest): 
    from AIAlgorithmsParameters_AI_v01 import RFParameters
    parameters= RFParameters()
    est = RandomForestClassifier(random_state=1)   
    decision=CommonFunction(est,Xtrain,Ytrain,Xtest,parameters)
    return decision

