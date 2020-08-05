# MLP
import time
global_start_time = time.time()

import os,sys
os.chdir("B:\Matlab\Shared\AI\code_01")
sys.path.append('./library/generic/Python')
sys.path.append('./library/specific/Python')

# from DaskDistributed_v01 import DaskDistributed as DaskDistributed
# # DaskDistributed - function  
# DaskDistributed('a',2) #a: automated, m: manual, #: number of coreslogical processors

mfilename=os.path.basename(__file__)

from FileNames_v01 import FileNames as FileNames
# FileNames - function (Manual entry required)
FilterName='ZF'
[mfilenameAlg,mfilenameVer,AIAlgName,LocalFolder,LocalFolderFilesTemp,BSelecAlg,BSelecAlgVer,BSelecAlgName,InputFolderx,datar,selected]= (
    FileNames(mfilename,FilterName)) 

from FileNamesMore_v01 import FileNamesMore as FileNamesMore
from CopyFiles_v01 import CopyFiles as CopyFiles
from LoadMatrices_AI_v01 import LoadMatrices as LoadMatrices
from AIAlgorithms_AI_v01 import MultiLabel_MLP as MultiLabel_MLP
from OutputsLoop_v01 import OutputsLoop as OutputsLoop
from TimeDuration_v01 import TimeDuration as TimeDuration
from RemoveFiles_v01 import RemoveFiles as RemoveFiles

results=00
for iter in range(0,len(selected)):
    start_time = time.time()
    import datetime
    now = datetime.datetime.now()
    print ("Current date and time: ",now.strftime("%Y-%m-%d %H:%M:%S"))
    print('Testing set of networks:',iter+1,'out of',len(selected))
    # FileNamesMore - function        
    [MonteCarlo,MonteCarloTest,L,K,M,Name2,filezip,FileName,SheetName,ResultsFolder,NetworkParameters]=(
        FileNamesMore(datar,selected[iter],mfilenameAlg,mfilenameVer,results,BSelecAlg,BSelecAlgVer,BSelecAlgName))   
    # CopyFiles - function        
    [InputFileNameTr,InputFileNameTe]=(
        CopyFiles(MonteCarlo,MonteCarloTest,L,K,M,InputFolderx,BSelecAlg,BSelecAlgVer,BSelecAlgName,Name2,LocalFolder,LocalFolderFilesTemp))            
    # LoadMatrices - function            
    [Xtrain,Ytrain,Xtest,Ytest]=LoadMatrices()     
    # MultiLabel_MLP - function            
    decision=MultiLabel_MLP(Xtrain,Ytrain,Xtest)                     
    # OutputsLoop - function
    writer=OutputsLoop(Ytest,decision,mfilename,start_time,filezip,FileName,SheetName,ResultsFolder,mfilenameAlg,mfilenameVer,NetworkParameters,BSelecAlgName,AIAlgName,LocalFolder,InputFileNameTr,InputFileNameTe)            
    writer.close()      

extensions = ('*.log','*.mat','*.zip')        
RemoveFiles(extensions)   

timeduration=TimeDuration(global_start_time)
o3=["The total simulation duration is ", timeduration]    
print(o3)