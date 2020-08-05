from functools import partial
from mat4py import loadmat
import numpy

array32 = partial(numpy.array, dtype=numpy.float32)

def LoadMatrices():
    # Loading training data set    
    Xtr = loadmat('Xtrain.mat')
    Ytr = loadmat('Ytrain.mat')
    Xtrain=array32(Xtr['X'])
    Ytrain=array32(Ytr['Y'])
    del Xtr, Ytr
    # Loading test data set
    Xte = loadmat('Xtest.mat')
    Yte = loadmat('Ytest.mat')
    Xtest=array32(Xte['X'])
    Ytest=array32(Yte['Y'])    
    del Xte, Yte    
    return Xtrain,Ytrain,Xtest,Ytest