def LinearSVCParameters():    
    # All parameters
    # parameters={ #'estimator__estimator__penalty': ['l2'], # default=l2
    #             # 'estimator__estimator__loss': ['hinge','squared_hinge'], # default=squared_hinge - best option
    #             # 'estimator__estimator__dual': [False], # default=True. default=False is not supported with loss=hinge
    #             # 'estimator__estimator__tol': [1e-2], # default=1e-4
    #             # 'estimator__estimator__C': [0.5,1,1.5],    # default=1 (lower the stronger regularization)
    #             # 'estimator__estimator__class_weight': ['balanced',None], # default=None (equal weight)
    #             # 'estimator__estimator__max_iter': [5,10] # default=1000 # No need to use - the higher the better
    #             }            
    # dual=True related parameters
    # parameters= {#'estimator__estimator__dual': [True], # default=True. default=False is not supported with loss=hinge # was on
                 # 'estimator__estimator__loss': ['squared_hinge'], # default=squared_hinge - best option # was on
                 # 'estimator__estimator__tol': [1e-3], # default=1e-4 # was on
                  # 'estimator__estimator__C': [0.01],    # default=1 (lower the stronger regularization)
                # 'estimator__estimator__class_weight': ['balanced'], # default=None (equal weight)
                # 'estimator__estimator__max_iter': [5,10] # default=1000 # No need to use - the higher the better
                # }          
    # dual=False related parameters
    # parameters= {'estimator__estimator__dual': [False], # default=True. default=False is not supported with loss=hinge
    #             # 'estimator__estimator__loss': ['squared_hinge'], # default=squared_hinge - best option
    #             'estimator__estimator__tol': [1e-2], # default=1e-4
    #             # 'estimator__estimator__C': [0.5],    # default=1 (lower the stronger regularization)
    #             # 'estimator__estimator__class_weight': ['balanced'], # default=None (equal weight)
    #             # 'estimator__estimator__max_iter': [5,10] # default=1000 # No need to use
    #             } 


    # ChainClassifier
    # All parameters
    # dual=False related parameters
    parameters={ #'base_estimator__estimator__dual': [False], # default=True. default=False is not supported with loss=hinge
                  # 'base_estimator__estimator__loss': ['hinge'], # default=squared_hinge - best option                  
                 # 'base_estimator__estimator__tol': [1e-3], # default=1e-4
                # 'base_estimator__estimator__C': [0.01],    # default=1 (lower the stronger regularization)
                # 'base_estimator__estimator__fit_intercept': [False], # default=True 
                # 'base_estimator__estimator_intercept_scaling': [1.5], # default=1
                # 'base_estimator__estimator__class_weight': ['balanced'], # default=None (equal weight)
    #             # 'estimator__estimator__max_iter': [5,10] # default=1000 # No need to use - the higher the better
                }    


    return parameters

def SVCParameters():    
    # MultiOutputClassifier
    # parameters={#'estimator__estimator__C': [0.1,1,2], # default=1 (lower the stronger regularization) # was on
                 # 'estimator__estimator__kernel': ['linear','poly','rbf','sigmoid'], # default=rbf - The best option # No need to use the others
                 # 'estimator__estimator__degree': [7], # default= 3. For poly kernel
                # 'estimator__estimator__gamma': ['auto'], # default=scale. Kernel coefficient for rbf, poly and sigmoid
                ## 'estimator__estimator__coef0': [0,1], # default=0 For poly and sigmoid. No need to use
                # 'estimator__estimator__shrinking': [False], # default=True
                ## 'estimator__estimator__probability': [True], # default=False. It will slow down. It is really slow, no need to use
                # 'estimator__estimator__tol': [1e-3], # default=1e-3
                ## 'estimator__estimator__class_weight': ['balanced'], # default=None (equal weight). It takes a lot time. No need to use.
    #             # # 'estimator__estimator__max_iter': [150,200], # default=-1 (no limit) # No need to use - the higher the better
                ## 'estimator__estimator__decision_function_shape': ['ovo'] # default=ovr. However, one-vs-one (‘ovo’) is always used as multi-class strategy. No need to use
                # 'estimator__estimator__break_ties': [True] # default=False. True is computationally expensive # No need to use
                # }         
    
    
    # ChainClassifier
    parameters={#'base_estimator__estimator__C': [10], # default=1 (lower the stronger regularization) # was on
                 # 'base_estimator__estimator__kernel': ['linear'], # default=rbf - The best option # No need to use the others
                 # 'estimator__estimator__degree': [7], # default= 3. For poly kernel
                 # 'base_estimator__estimator__gamma': ['auto'], # default=scale. Kernel coefficient for rbf, poly and sigmoid
                ## 'estimator__estimator__coef0': [0,1], # default=0 For poly and sigmoid. No need to use
                # 'estimator__estimator__shrinking': [False], # default=True
                ## 'estimator__estimator__probability': [True], # default=False. It will slow down. True option is really slow, no need to use
                # 'base_estimator__estimator__tol': [1e-1], # default=1e-3. No need to use
                ## 'estimator__estimator__class_weight': ['balanced'], # default=None (equal weight). It takes a lot time. No need to use.
                # 'base_estimator__estimator__max_iter': [1000], # default=-1 (no limit) # No need to use - the higher the better
                ## 'estimator__estimator__decision_function_shape': ['ovo'] # default=ovr. However, one-vs-one (‘ovo’) is always used as multi-class strategy. No need to use
                # 'estimator__estimator__break_ties': [True] # default=False. True is computationally expensive # No need to use
                }         
    
    return parameters

def MLPParameters():     
    import numpy
    # MultiOutputClassifier
    # All parameters
    # parameters={#'estimator__solver': ['sgd','adam'], # default=adam
                # 'estimator__activation': ['identity', 'logistic', 'tanh', 'relu'], # default=relu            
                #'estimator__alpha': [1e-4,1e-2], # default=1e-4                
                # 'estimator__learning_rate': ['constant', 'invscaling', 'adaptive'], # default=constant. Only used when solver='sgd'.
                # 'estimator__learning_rate_init': [1e-3,1e-1], # default=1e-3. Only used when solver='sgd' or 'adam'.
                # 'estimator__power_t': [0.1,0.5], # default=0.5. Only used when solver='sgd' and estimator__learning_rate='invscaling'.
                # 'estimator__max_iter': [200,250], # default=200
                # #'estimator__shuffle': [True, False], # default=True # No need to use
                # 'estimator__tol': [1e-4,1e-2], # default=1e-4
                # 'estimator__warm_start': [True,False], # default=False
                # 'estimator__momentum': [0.5,0.9], # default=0.9. Should be between 0 and 1. Only used when solver='sgd'.
                # 'estimator__nesterovs_momentum': [True,False], # default=True. Only used when solver='sgd' and momentum>0.
                # 'estimator__early_stopping': [True,False], # default=False. Only effective when solver='sgd' or 'adam'
                # 'estimator__validation_fraction': [0.1,0.5], # default=0.1. Must be between 0 and 1. Only used if early_stopping is True
                # 'estimator__beta_1': [0.5,0.9], # default=0.9. Should be in [0, 1). Only used when solver='adam'
                # 'estimator__beta_2': [0.6,0.999], # default=0.999. Should be in [0, 1). Only used when solver='adam' 
                # 'estimator__epsilon': [1e-8,1e-4], # default=1e-8. Only used when solver='adam'
                # 'estimator__n_iter_no_change': [5, 10] # default=10. Only effective when solver='sgd' or 'adam'
                # }    
    # ADAM related parameters	
    # Baseline: learning_rate_init=1e-2, (to eliminate non-convergence problem) tol=1e-3 (tol=1e-2 is super fast)
    # parameters={#'estimator__solver': ['adam'], # default=adam
                # 'estimator__activation': ['tanh'], # default=relu   # was on
                # 'estimator__alpha': [1e-2], # default=1e-4          # was on                           
                # 'estimator__learning_rate_init': [1e-2], # default=1e-3. Only used when solver='sgd' or 'adam'.      # was on          
                # # # 'estimator__max_iter': [200,250], # default=200 # No need to use - the higher the better
                # 'estimator__tol': [1e-3], # default=1e-4   # was on
                # # 'estimator__warm_start': [True], # default=False
                # 'estimator__early_stopping': [True], # default=False. Only effective when solver='sgd' or 'adam'. Adjust validation_fraction and n_iter_no_change parameters as well # was on
               #  'estimator__validation_fraction': [0.5], # default=0.1. Must be between 0 and 1. Only used if early_stopping is True. The lower: the longer time (shorter than the baseline), the higher accuracy # was on
                ## 'estimator__beta_1': [0.5], # default=0.9. Should be in [0, 1). Only used when solver='adam'
                ## 'estimator__beta_2': [0.6], # default=0.999. Should be in [0, 1). Only used when solver='adam' 
                ## 'estimator__epsilon': [1e-4], # default=1e-8. Only used when solver='adam'
                # 'estimator__n_iter_no_change': [3] # default=10. Only effective when solver='sgd' or 'adam'. Correct (MLPClassifier on scikit.learn is explaining this better)->I guess that this means the maximum number of iterations allowed without any change. Therefore, the smaller the faster
                # }  
    
    # parameters={#'estimator__solver': ['sgd'], # default=adam
    #             # 'estimator__activation': ['tanh'], # default=relu  
    #             'estimator__alpha': [1e-2], # default=1e-4                                
    #             'estimator__learning_rate_init': [1e-2], # default=1e-3. Only used when solver='sgd' or 'adam'.                
    #             # # 'estimator__max_iter': [200,250], # default=200 # No need to use - the higher the better
    #               'estimator__tol': [1e-3], # default=1e-4
    #             ## 'estimator__warm_start': [True], # default=False. No need to use
    #             'estimator__early_stopping': [True], # default=False. Only effective when solver='sgd' or 'adam'. Adjust validation_fraction and n_iter_no_change parameters as well
    #             'estimator__validation_fraction': [0.1], # default=0.1. Must be between 0 and 1. Only used if early_stopping is True. The lower: the longer time (shorter than the baseline), the higher accuracy
    #             'estimator__beta_1': [0.5], # default=0.9. Should be in [0, 1). Only used when solver='adam'
    #             'estimator__beta_2': [0.6], # default=0.999. Should be in [0, 1). Only used when solver='adam' 
    #             'estimator__epsilon': [1e-4], # default=1e-8. Only used when solver='adam'
    #             'estimator__n_iter_no_change': [3] # default=10. Only effective when solver='sgd' or 'adam'. Correct (MLPClassifier on scikit.learn is explaining this better)->I guess that this means the maximum number of iterations allowed without any change. Therefore, the smaller the faster
    #             } 
    
    # SGD related parameters	
    # parameters={'estimator__solver': ['sgd'], # default=adam
    #             # 'estimator__alpha': [1e-4,1e-2], # default=1e-4                
    #             # 'estimator__learning_rate': ['adaptive'], # default=constant. Only used when solver='sgd'.
    #             'estimator__learning_rate_init': [1e-2], # default=1e-3. Only used when solver='sgd' or 'adam'.
    #             # 'estimator__power_t': [0.1,0.5] # default=0.5. Only used when solver='sgd' and estimator__learning_rate='invscaling'.
    #             # 'estimator__max_iter': [200,250], # default=200
    #             ## 'estimator__shuffle': [True, False], # default=True # No need to use
    #             'estimator__tol': [1e-3], # default=1e-4
    #             # 'estimator__warm_start': [True,False], # default=False
    #             # 'estimator__momentum': [0.5,0.9], # default=0.9. Should be between 0 and 1. Only used when solver='sgd'.
    #             # 'estimator__nesterovs_momentum': [True,False], # default=True. Only used when solver='sgd' and momentum>0.
    #             # 'estimator__early_stopping': [True,False], # default=False. Only effective when solver='sgd' or 'adam'
    #             # 'estimator__validation_fraction': [0.1,0.5], # default=0.1. Must be between 0 and 1. Only used if early_stopping is True
    #             # 'estimator__n_iter_no_change': [5, 10] # default=10. Only effective when solver='sgd' or 'adam'
    #             } 
    
    # ChainClassifier
    # ADAM related parameters	
    # Baseline: learning_rate_init=1e-2, (to eliminate non-convergence problem) tol=1e-3 (tol=1e-2 is super fast)
    parameters={#'base_estimator__solver': ['adam'], # default=adam
                #'base_estimator__activation': ['tanh'], # default=relu   # was on
                #'base_estimator__alpha': [1e-5], # default=1e-4          # was on                           
                 # 'base_estimator__learning_rate_init': [1e-2], # default=1e-3. Only used when solver='sgd' or 'adam'.      # was on          
                # # # 'estimator__max_iter': [200,250], # default=200 # No need to use - the higher the better
                # 'base_estimator__tol': [1e-2], # default=1e-4   # was on
                # # 'estimator__warm_start': [True], # default=False
                # 'base_estimator__early_stopping': [True], # default=False. Only effective when solver='sgd' or 'adam'. Adjust validation_fraction and n_iter_no_change parameters as well # was on
                # 'base_estimator__validation_fraction': [0.08], # default=0.1. Must be between 0 and 1. Only used if early_stopping is True. The lower: the longer time (shorter than the baseline), the higher accuracy 
                # 'base_estimator__beta_1': [0.6], # default=0.9. Should be in [0, 1). Only used when solver='adam' # was on
                  # 'base_estimator__beta_2': [0.8], # default=0.999. Should be in [0, 1). Only used when solver='adam'     # was on            
                # 'base_estimator__beta_1': numpy.arange(0.2,0.8,0.2), # default=0.9. Should be in [0, 1). Only used when solver='adam'
                # 'base_estimator__beta_2': numpy.arange(0.2,0.8,0.2), # default=0.999. Should be in [0, 1). Only used when solver='adam' 
                 # 'base_estimator__epsilon': [1e-4], # default=1e-8. Only used when solver='adam' # was on
                # 'base_estimator__n_iter_no_change': [20] # default=10. Only effective when solver='sgd' or 'adam'. Correct (MLPClassifier on scikit.learn is explaining this better)->I guess that this means the maximum number of iterations allowed without any change. Therefore, the smaller the faster # was on
                }  
    return parameters

def RFParameters():        
    # MultiOutputClassifier - Baseline: default
    import numpy
    # parameters = {#'estimator__n_estimators': [100], # default=100 # No need to use - the higher the better
    #                   'estimator__bootstrap': [True,False], # default=True
    #                 # 'estimator__warm_start': [False],  # default=False. No need to use. No affect
    #                     'estimator__class_weight': ['balanced','balanced_subsample',None], # default=None (equal weight)
    #                 # 'estimator__max_features': ['auto','log2',None], # default=auto
    #                  'estimator__min_samples_split': numpy.arange(2,6,1),   # default=2 
    #                  'estimator__min_samples_leaf': numpy.arange(1,8,1),    # default=1 
    #                 }     
    # parameters = {#'estimator__n_estimators': [100], # default=100 # No need to use - the higher the better
    #                    'estimator__bootstrap': [True], # default=True
    #                 ## 'estimator__warm_start': [False],  # default=False. No need to use. No affect
    #                    'estimator__class_weight': ['balanced_subsample'], # default=None (equal weight)
    #                 ##'estimator__max_features': ['auto','log2',None], # default=auto. No need to use.
    #                 # 'estimator__min_samples_split': numpy.arange(2,6,1),   # default=2 
    #                 'estimator__min_samples_leaf': [7],    # default=1 
    #               }         
    # parameters = {#'estimator__n_estimators': [200], # default=100 # No need to use - the higher the better
                    # 'estimator__bootstrap': [False] # default=True
                    # 'estimator__warm_start': [True],  # default=False. No need to use. No affect
                    # 'estimator__class_weight': ['balanced'], # default=None (equal weight)
                    # ##'estimator__max_features': ['auto','log2',None], # default=auto. No need to use.
                    #'estimator__min_samples_split': [2],  # was on 
                    #'estimator__min_samples_leaf': [10],  # was on  
                    # 'estimator__min_samples_split': numpy.arange(2,8,2),   # default=2 
                    # 'estimator__min_samples_leaf': numpy.arange(1,10,3),    # default=1         
                   # }
    # return parameters
                    
    # ClassifierChain - Baseline: default    
    # parameters = {#'base_estimator__n_estimators': [100] # default=100 # No need to use - the higher the better
    #                   'base_estimator__bootstrap': [True,False], # default=True
    #                 # 'base_estimator__warm_start': [False],  # default=False. No need to use. No affect
    #                     'base_estimator__class_weight': ['balanced','balanced_subsample',None], # default=None (equal weight)
    #                 # 'base_estimator__max_features': ['auto','log2',None], # default=auto
    #                  'base_estimator__min_samples_split': numpy.arange(2,6,1),   # default=2 
    #                  'base_estimator__min_samples_leaf': numpy.arange(1,8,1),    # default=1 
                    # }
    parameters = {'base_estimator__n_estimators': [200], # default=100 # No need to use - the higher the better
                    'base_estimator__bootstrap': [True], # default=True - Selected
                  # 'base_estimator__warm_start': [True]  # default=False. No need to use. No affect
                    'base_estimator__class_weight': ['balanced_subsample'], # default=None (equal weight) - Selected
                  # 'base_estimator__max_features': [None] # default=auto
                    'base_estimator__min_samples_split': [10],   # default=2  - Selected
        #                  'base_estimator__min_samples_split': numpy.arange(2,6,1),   # default=2 
                   'base_estimator__min_samples_leaf': [5],    # default=1     - Selected
                          # 'base_estimator__min_samples_leaf': numpy.arange(6,9,1),    # default=1     
                  }  
    return parameters

    