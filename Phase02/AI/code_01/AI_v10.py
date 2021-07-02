# RF
import time
global_start_time = time.time()

import os,sys
# Please change your directory, e.g.:
# os.chdir("B:\Matlab\AI\code_01")
# Also change the directory in FileNames_v04.py
os.chdir("B:\Matlab\Shared\BeamSelection\Phase02\AI\code_01")
sys.path.append('./library/generic/Python')
sys.path.append('./library/specific/Python')

# from DaskDistributed_v01 import DaskDistributed as DaskDistributed
# # DaskDistributed - function  
# DaskDistributed('a',2) #a: automated, m: manual, #: number of coreslogical processors

mfilename=os.path.basename(__file__)
from FileNames_v04 import FileNames as FileNames
# FileNames - function (Manual entry required)
FilterName='MMSE'
[mfilenameAlg,mfilenameVer,AIAlgName,LocalFolder,LocalFolderFilesTemp,BSelecAlg,BSelecAlgVer,BSelecAlgName,InputFolderx,datar,selected]= (
    FileNames(mfilename,FilterName)) 

from FileNamesMore_v06 import FileNamesMore as FileNamesMore
from CopyFiles_v04 import CopyFiles as CopyFiles
from LoadMatrices_AI_v01 import LoadMatrices as LoadMatrices
from AIAlgorithms_AIII_v01 import MultiLabel_RF as MultiLabel_RF
from OutputsLoop_v08 import OutputsLoop as OutputsLoop
from TimeDuration_v02 import TimeDuration as TimeDuration
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
    # MultiLabel_RF - function  
    decision=MultiLabel_RF(Xtrain,Ytrain,Xtest)                        
    # OutputsLoop - function
    writer=OutputsLoop(Ytest,decision,mfilename,start_time,filezip,FileName,SheetName,ResultsFolder,mfilenameAlg,mfilenameVer,NetworkParameters,BSelecAlgName,AIAlgName,LocalFolder,InputFileNameTr,InputFileNameTe)    
    writer.close()      

extensions = ('*.log','*.mat','*.zip')        
# RemoveFiles - function
RemoveFiles(extensions)   
# TimeDuration - function
timeduration=TimeDuration(global_start_time)
o3=["The total simulation duration is ", timeduration]    
print(o3)