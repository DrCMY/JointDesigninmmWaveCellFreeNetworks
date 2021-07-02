from functools import partial
from mat4py import loadmat
import numpy

array32 = partial(numpy.array, dtype=numpy.float32)

def LoadMatrices():  
    Xtr = loadmat('Xtrain.mat')
    Ytr = loadmat('Ytrain.mat')
    Xtrain=array32(Xtr['X'])
    Ytrain=array32(Ytr['Y'])
    del Xtr, Ytr
    # const=5000
    # Xtrain=Xtrain[:const,:]
    # Ytrain=Ytrain[:const]
    
    Xte = loadmat('Xtest.mat')
    Yte = loadmat('Ytest.mat')
    Xtest=array32(Xte['X'])
    Ytest=array32(Yte['Y'])    
    del Xte, Yte
    # Xtest=Xtest[:const,:]
    # Ytest=Ytest[:const]
    return Xtrain,Ytrain,Xtest,Ytest