close all; fclose('all'); delete('*.log','*.bak'); 
warning('off','all');   %warning
[CodeFolder,SheetName,DataFolder,~]=CodeFolder_SheetName_DataFolder_AlgName_v01;  % Locations of the code and data folders. Sheet name of the Runme.xlsx file
fname=dir('*Runme*.xlsx');
x=xlsread(fname.name,SheetName,'A1:A200');
C=xlsread(fname.name,SheetName,['A1:A2' num2str(length(x))]);
CCell = num2cell(C);

[MonteCarlo, L, K, M, PdBTxRx, Init, Iter, GTS, sigma2n]=CCell{:};

% File name extensions
Name1=sprintf('L%dK%dM%d',L,K,M); 
Name1x=sprintf('_MC%d',MonteCarlo);
Name1x=[Name1 Name1x];
Name2=['T' mat2str(PdBTxRx) '_In' mat2str(Init) '_I' mat2str(Iter) '_G' mat2str(GTS)]; 

% Checking the input files
InputFolder=InputFolder_v01(MonteCarlo,L,K,Name1,DataFolder);
[status,list]=system(InputFolder); 
if status==1
    disp('The input files are missing. They are now being generated. Please wait.')
    TempFolder=[DataFolder 'Temp\' Name1x '\' ]; 
    mkdir(TempFolder)
    copyfile(fname.name,TempFolder);
    [~,list]=system('dir G*.m /b');          % Finding the Generator.m file to generate random variables
    runner=textscan(list, '%s %s', 'delimiter','.');    
    copyfile([char(runner{1}) '.m'],TempFolder);
    cd(TempFolder)
    fidotemp = fopen('code_0X.log','w');
    fprintf(fidotemp,SheetName); fclose(fidotemp);
    run(char(runner{1}))                    % Executing the Generator.m file to generate random variables
    copyfile('Inputs',[DataFolder 'Inputs\'])
    cd ..
    rmdir(Name1x,'s')  
end
cd(CodeFolder)

% The random channel and beamforming vector input files are copied to the current directory 
copyfile(InputFolder,pwd);
unzip(InputFolder);
delete('*.zip');

%%%
% Choose one of the joint design algorithms below
%AI_v01(MonteCarlo,L,K,M,PdBTxRx,Init,Iter,GTS,sigma2n,Name1,Name2,InputFolder)    % Multi-J-Init-Iter            (Linear_Joint_Init_Iter_Rate_NoBCC)
%BI_v01(MonteCarlo,L,K,M,PdBTxRx,Init,Iter,GTS,sigma2n,Name1,Name2,InputFolder)    % Multi-SDL-BCC                (Linear_Disjoint_DL_BCC) 
%CI_v01(MonteCarlo,L,K,M,PdBTxRx,Init,Iter,GTS,sigma2n,Name1,Name2,InputFolder)    % Multi-TSDL-J-Init-Iter-BCC   (Linear_Joint_Init_Iter_DL_BCC) (!You need to update the equation (8) in the paper and write explanation in the Matlab files)
%DI_v01(MonteCarlo,L,K,M,PdBTxRx,Init,Iter,GTS,sigma2n,Name1,Name2,InputFolder)    % Multi-J-Init-Iter-BCC        (Linear_Joint_Init_Iter_Rate_BCC) 
%EI_v01(MonteCarlo,L,K,M,PdBTxRx,Init,Iter,GTS,sigma2n,Name1,Name2,InputFolder)    % Multi-EXD2II-J-Init-Iter-BCC (Semilinear_Joint_Init_Iter_Rate_BCC) 
FI_v01(MonteCarlo,L,K,M,PdBTxRx,Init,Iter,GTS,sigma2n,Name1,Name2,InputFolder)     % Multi-J-Init-Iter-SEL-BCC    (Linear_Joint_Init_Iter_Sel_Rate_BCC)
