function [fname,datar,selected,cverSubFile_a,cverSubFile_b,AISubFile_a,AISubFile_b,AlgName]=FileNames_v01(version)
fname=dir('*NetworkList*.xlsx');               % List of networks to be tested
datar=readmatrix(fname.name,'Range','A2:N50');
selected=find(datar(:,end)==version);

%%%
% Start (Manual entry required)
% Beam selection algorithm in Matlab. See the updated list in NetworkList_v01.xlsx-AlgorithmsList_v01 sheet
%cverSubFile_a='AI';   % Linear_Joint_Init_Iter_Rate_NoBCC
%cverSubFile_a='BI';   % Linear_Disjoint_DL_BCC
%cverSubFile_a='CI';   % Linear_Joint_Init_Iter_DL_BCC
cverSubFile_a='DI';   % Linear_Joint_Init_Iter_Rate_BCC
%cverSubFile_a='EI';   % Semilinear_Joint_Init_Iter_Rate_BCC
%cverSubFile_a='FI';   % Linear_Joint_Init_Iter_Sel_Rate_BCC
cverSubFile_b='v01';

% AI algorithm in Python. See the updated list in NetworkList_v01.xlsx-AlgorithmsList_v01 sheet
% AISubFile_a='AI'; % LSVM
% AISubFile_a='BI'; % GSVM
% AISubFile_a='CI'; % MLP
AISubFile_a='DI'; % RF
AISubFile_b='v01';
AlgNameB='ZF';                      % Digital filter type
% End (Manual entry required)
%%%

%%%
% Retrieve beam selection algorithm name from the file name
[~,FileName,~]=xlsread(fname.name,'AlgorithmsList_v01','C1:C30');
[~,AlgNames,~]=xlsread(fname.name,'AlgorithmsList_v01','D1:D30');
AlgNameAx=AlgNames(strcmp([cverSubFile_a '_' cverSubFile_b],FileName));
AlgNameA=AlgNameAx{1};
AlgName=[AlgNameA '_' AlgNameB];                    
%%%

% AI_v01.py	 LSVM
% BI_v01.py	 GSVM
% CI_v01.py	 MLP
% AI_v01.py	 RF