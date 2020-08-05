import glob,os,shutil,zipfile
def CopyFiles(MonteCarlo,MonteCarloTest,L,K,M,InputFolderx,BSelecAlg,BSelecAlgVer,BSelecAlgName,Name2,LocalFolder,LocalFolderFilesTemp):        
    # Copying training data set
    Name1='L'+str(L)+'K'+str(K)+'M'+str(M)
    InputFolder=InputFolderx+'\MC'+str(MonteCarlo)+'\\'+str(BSelecAlg)+'\\'+str(BSelecAlgVer)
    InputFileNameTr=InputFolder+'\\'+Name1+'_'+Name2+'_'+BSelecAlgName+'.zip'
    zip = zipfile.ZipFile(InputFileNameTr)
    os.mkdir(LocalFolderFilesTemp)
    zip.extractall(LocalFolderFilesTemp)    
    for file in glob.iglob(LocalFolderFilesTemp+'\\'+'*_X.mat', recursive=True):
        shutil.copy(file, LocalFolder+'\\'+'Xtrain.mat')
    for file in glob.iglob(LocalFolderFilesTemp+'\\'+'*_Y_Binary.mat', recursive=True):
        shutil.copy(file, LocalFolder+'\\'+'Ytrain.mat')    
    shutil.rmtree(LocalFolderFilesTemp) 
    
    # Copying test data set
    InputFolder=InputFolderx+'\MC'+str(MonteCarloTest)+'\\'+str(BSelecAlg)+'\\'+str(BSelecAlgVer)
    InputFileNameTe=InputFolder+'\\'+Name1+'_'+Name2+'_'+BSelecAlgName+'.zip'
    zip = zipfile.ZipFile(InputFileNameTe)
    os.mkdir(LocalFolderFilesTemp)
    zip.extractall(LocalFolderFilesTemp)
    
    for file in glob.iglob(LocalFolderFilesTemp+'\\'+'*_X.mat', recursive=True):
        shutil.copy(file, LocalFolder+'\\'+'Xtest.mat')
    for file in glob.iglob(LocalFolderFilesTemp+'\\'+'*_Y_Binary.mat', recursive=True):
        shutil.copy(file, LocalFolder+'\\'+'Ytest.mat')    
    shutil.rmtree(LocalFolderFilesTemp)        
    
    return InputFileNameTr,InputFileNameTe      