from os import listdir, system
from pathlib import Path
def FileNamesMore(datar,x,mfilenameAlg,mfilenameVer,results,BSelecAlg,BSelecAlgVer,BSelecAlgName):         
    TtTR=3                              # Training data to test data ratio
    MonteCarlo=datar['MC'][x]           # Training data
    MonteCarloTest=int(MonteCarlo/TtTR) # Test data
    #MonteCarloTest=10000              # Number of test data is fixed to a number
    L=datar['L'][x]; K=datar['K'][x]; M=datar['M'][x]; TxdBm=datar['Tx dBm'][x]; 
    Init=datar['Init'][x]; Iter=datar['Iter'][x]; GTS=datar['GTS'][x];        
    Name2='T'+str(TxdBm)+'_In'+str(Init)+'_I'+str(Iter)+'_G'+str(GTS)  
    #breakpoint()
    filezip='L'+str(L)+'K'+str(K)+'M'+str(M)+'_'+Name2+'_'+BSelecAlgName+'_'+BSelecAlg+'_'+BSelecAlgVer+'.zip'     
    # breakpoint()
    #FileName='Output_v07.xlsx'
    FileNamex = [x for x in listdir() if x.endswith(".xlsx")]
    FileName=FileNamex[0]
    while len(FileNamex)>1:
            print('Please, close the',FileName,'file and then press ENTER \n')      
            system('pause')
            FileNamex = [x for x in listdir() if x.endswith(".xlsx")]
    SheetName='MC'+str(MonteCarlo)+'_'+'MC'+str(MonteCarloTest)
    ResultsFolder='.\\Results'+'\\'+SheetName+'\\'+mfilenameAlg+'\\'+mfilenameVer+'\\' +str(results)
    # os.mkdir(ResultsFolder, exist_ok=True)
    Path(ResultsFolder).mkdir(parents=True,exist_ok=True)
    NetworkParameters=datar[['L','K','M','Tx dBm','Init','Iter','GTS']][x:x+1]       
    NetworkParameters.insert(3,'Network','L'+str(L)+'-'+'K'+str(K)+'-'+'M'+str(M))    
    return MonteCarlo,MonteCarloTest,L,K,M,Name2,filezip,FileName,SheetName,ResultsFolder,NetworkParameters