import numpy,os,pandas,re
def FileNames(mfilename,FilterName):
    ## Start
    # Splitting current file name
    [mfilenameAlg,mfilenameVer]=mfilename.split("_")
    [mfilenameVer,_]=mfilenameVer.split(".")
    ## End
    ## Start (Manual entry required)
    # Assigning ML algorithm name based on the file name.    
    if  bool(re.match(re.compile("AI"), mfilename)):    
        AlgName='LSVM' # Algorithm name
    elif bool(re.match(re.compile("BI"), mfilename)):          
        AlgName='GSVM' 
    elif bool(re.match(re.compile("CI"), mfilename)):          
        AlgName='MLP'         
    elif bool(re.match(re.compile("DI"), mfilename)):          
        AlgName='RF'          
    else:
        AlgName='Unknown Alg.' 
    ## End

    ## Start
    # Location of current file
    LocalFolder = os.getcwd()
    LocalFolderFilesTemp = LocalFolder+'\\Files'+'\\Temp'
    ## End
       
    ## Start (Manual entry required)
    # Beamforming selection algorithm     
    BSelecAlg='DI' # Beamforming selection algorithm used for AI training&test DI: Linear_Joint_Init_Iter_Rate_BCC
    BSelecAlgVer='v01' # Beamforming selection algorithm version        
    InputFolderx='B:\Matlab\Shared\BeamSelection\code_01\Results' # Beamforming selection algorithm's results
    ## End

    ## Start
    # Network architectures to be tested
    InputFoldery='B:\\Matlab\\Shared\\Generator\\'
    fnamex = [x for x in os.listdir(InputFoldery) if x.endswith(".xlsx")]
    fname = fnamex[0]
    fname=InputFoldery+fname
    datar = pandas.read_excel(fname, sheet_name='Sheet1')    
    datarx = pandas.read_excel(fname, sheet_name='AlgorithmsList_v01', usecols="C,D", header=None)
    counter=0
    for x in datarx[2]:
        res= BSelecAlg+'_'+BSelecAlgVer==x
        if res:
            BSelecAlgName=datarx.iloc[counter,1]
        counter=counter+1
    BSelecAlgName=BSelecAlgName+'_'+FilterName
    selected_boolean=datar['Runners']==mfilename
    selected=numpy.where(selected_boolean)[0] # indices    
    if len(selected)==0:
        print('There is no Runner_X.m call in the NetworkList.xlsx file: X')
    ## End
    return mfilenameAlg,mfilenameVer,AlgName,LocalFolder,LocalFolderFilesTemp,BSelecAlg,BSelecAlgVer,BSelecAlgName,InputFolderx,datar,selected





