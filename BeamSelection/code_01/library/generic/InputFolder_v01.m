function InputFolder=InputFolder_v01(MonteCarlo,L,K,Name1,DataFolder)
InputFolderx=['MC' num2str(MonteCarlo) '\L' num2str(L) '\K' num2str(K) '\'];
InputFolder=[DataFolder 'Inputs\' InputFolderx Name1 '.zip'];