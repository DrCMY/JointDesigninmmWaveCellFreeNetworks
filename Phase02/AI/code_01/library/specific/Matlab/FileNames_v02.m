function [fname,datar,selected,cverSubFile_a,cverSubFile_b,AISubFile_a,AISubFile_b,AlgName]=FileNames_v02(version)
fname=dir('*NetworkList*.xlsx');
datar=readmatrix(fname.name,'Range','A2:N50');
selected=find(datar(:,end)==version);

%%%
% Start (Manual entry required)
% cverSubFile_a='BIcII'; % Beam selection algorithm in Matlab
% cverSubFile_b='v04a';
% cverSubFile_a='BIaII'; % Beam selection algorithm in Matlab
% cverSubFile_b='v08at4d';
cverSubFile_a='BIaIII'; % Beam selection algorithm in Matlab
cverSubFile_b='v10at04';
% cverSubFile_a='BIcV'; % Beam selection algorithm in Matlab
% cverSubFile_b='v03b';
% AISubFile_a='BIId'; % AI algorithm in Python. See the updated list in NetworkList_v04.xlsx-AI_Algorithms_List_01 sheet
% AISubFile_b='v09';
% AISubFile_a='BIIc'; % AI algorithm in Python. See the updated list in NetworkList_v04.xlsx-AI_Algorithms_List_01 sheet
% AISubFile_b='v08';
% AISubFile_a='CIIa'; % AI algorithm in Python. See the updated list in NetworkList_v04.xlsx-AI_Algorithms_List_01 sheet
% AISubFile_b='v07';
AISubFile_a='AI'; % AI algorithm in Python. See the updated list in NetworkList_v04.xlsx-AI_Algorithms_List_01 sheet
AISubFile_b='v10';
AlgNameB='MMSE';                 % Name of the algorithm. Do not choose ZF
% End (Manual entry required)
%%%

x=xlsread(fname.name,'AlgorithmsList_v01','C1:C25');
[~,FileName,~]=xlsread(fname.name,'AlgorithmsList_v01',['C1:C2' num2str(length(x))]);
x=xlsread(fname.name,'AlgorithmsList_v01','D1:C25');
[~,AlgNames,~]=xlsread(fname.name,'AlgorithmsList_v01',['D1:D2' num2str(length(x))]);
AlgNameAx=AlgNames(strcmp([cverSubFile_a '_' cverSubFile_b],FileName));
AlgNameA=AlgNameAx{1};
AlgName=[AlgNameA '_' AlgNameB];



% BIId_v09.py	LSVM
% BIIc_v08.py	GSVM
% CIIa_v07.py	MLP
% AI_v10.py	    RF