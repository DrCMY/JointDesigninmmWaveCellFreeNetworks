% !!!!ATTENTION!!!! THIS RUNNER CAN OVERWRITE DATA IN THE OUTPUT_VXX.XLSX FILE. BE CAREFUL!
% You need to rename the tab in the excel file to avoid overwriting!!
% Also, for the ZIP FILES, you need to distinguish manually among the beam selection algorithms
% Please add the AI\code_01\library\generic\Matlab and AI\code_01\library\specific\Matlab folders to Matlab's path
clc; clear; close all; fclose('all'); dbstop if error; % dbclear if error;
% closeoutputxlsxfile - function
closeoutputxlsxfile
delete('*.log','*.mat')
warning('off','all'); %warning
tgGlobal=tic;
% CodeFolder_SheetName_DataFolder_v01 - function
%[CodeFolder,~,DataFolder]=CodeFolder_SheetName_DataFolder_v01;  % Locations of the code and data folders. Sheet name of the runme.xlsx file
[CodeFolder,~,DataFolder,~]=CodeFolder_SheetName_DataFolder_AlgName_v02x;  % Locations of the code and data folders. Sheet name of the runme.xlsx file

version=textscan(mfilename, '%s %s %d', 'delimiter','__');
% FileNames_v02 - function (Manual entry required)
[fname,datar,selected,cverSubFile_a,cverSubFile_b,AISubFile_a,AISubFile_b,AlgName]=FileNames_v02(version{3});
lselected=length(selected);
if isempty(selected)
    disp('There is no Runner_X.m call in the NetworkList.xlsx file')
end    
for iter=1:lselected
    tgLocal=tic;
    fprintf('Current date and time: %s\n',char(datetime('now')));
    fprintf('Testing set of networks: %d out of %d\n',iter,lselected);
    % FileNamesMore_v02 - function
    [MonteCarlo,MonteCarloTest,L,K,M,PdBTxRx,Init,Iter,GTS,Name1,Name2]=FileNamesMore_v02(datar,selected,iter);
    % CopyFiles_v04 - function
    % PLEASE change the folder location in CopyFiles_v04.m
    [Inputfilename,Inputfolder]=CopyFiles_v04(L,K,M,MonteCarlo,MonteCarloTest,Name2,cverSubFile_a,cverSubFile_b,AISubFile_a,AISubFile_b,AlgName,CodeFolder,version{3});
    cd(CodeFolder)
    % BII_v03 - function
    [ErrorPercentage_Original,ErrorPercentage_New,sum_rate_AI,sum_rate_Original,sum_rate_OriginalM,counter,BCCER]=BII_v03(Name1,MonteCarloTest,L,K,M,PdBTxRx);
    % OutputsExcel_v08 - function
    OutputsExcel_v08(ErrorPercentage_Original,ErrorPercentage_New,sum_rate_AI,sum_rate_Original,sum_rate_OriginalM,counter,Inputfilename,Inputfolder,tgLocal,iter,MonteCarlo,MonteCarloTest,BCCER)                    
end
fprintf('Total simulation time is %s\n\n',secs2hms_v04(toc(tgGlobal)));
fprintf('\n');
fig = uifigure;
uialert(fig,[mfilename ' is completed'],'Success','Icon','success');