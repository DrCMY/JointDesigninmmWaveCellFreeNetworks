import numpy,os,pandas,re
def FileNames(mfilename,FilterName):
    # breakpoint()    
    ## Start
    # Splitting current file name
    [mfilenameAlg,mfilenameVer]=mfilename.split("_")
    [mfilenameVer,_]=mfilenameVer.split(".")
    ## End
    ## Start (Manual entry may be required)
    # Assigning name to the algorithm numeration.    
    if  bool(re.match(re.compile("BIId"), mfilename)):    
        AlgName='LSVM' # Algorithm name
    elif bool(re.match(re.compile("BIIc"), mfilename)):          
        AlgName='GSVM' 
    elif bool(re.match(re.compile("CIIa"), mfilename)):          
        AlgName='MLP'         
    elif bool(re.match(re.compile("AI"), mfilename)):          
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
    # BSelecAlg='BIcV' # Beamforming selection algorithm used for AI training&test
    # BSelecAlgVer='v03b' # Beamforming selection algorithm version        
    # BSelecAlg='BIaII' # Beamforming selection algorithm used for AI training&test
    # BSelecAlgVer='v08at4d' # Beamforming selection algorithm version        
    BSelecAlg='BIaIII' # Beamforming selection algorithm used for AI training&test
    BSelecAlgVer='v10at04' # Beamforming selection algorithm version        
    # PLEASE change the directory here:
    #InputFolderx='B:\Matlab\BeamSelection\code_01\Results' # Beamforming selection algorithm's results
    InputFolderx='B:\Matlab\Shared\BeamSelection\Phase02\code_01\Results' # Beamforming selection algorithm's results    
    ## End

    ## Start
    # Network architectures to be tested
    #fname='B:\\Matlab\\Generator\\BeamSelection\\NetworkList_v06.xlsx'    
    # PLEASE change the directory here:
    #InputFoldery='B:\\Matlab\\Generator\\BeamSelection\\'
    InputFoldery='B:\\Matlab\\Shared\\BeamSelection\\Phase02\\Generator\\'
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
    #breakpoint()
    if len(selected)==0:
        print('There is no Runner_X.m call in the NetworkList.xlsx file: X')
    ## End
    return mfilenameAlg,mfilenameVer,AlgName,LocalFolder,LocalFolderFilesTemp,BSelecAlg,BSelecAlgVer,BSelecAlgName,InputFolderx,datar,selected





