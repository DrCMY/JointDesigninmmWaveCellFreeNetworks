clc; clear; close all; fclose('all'); dbstop if error; % dbclear if error;
% closeoutputxlsxfile - function
closeoutputxlsxfile      % Close Output_v0X.xlsx excel file
delete('*.log','*.mat')
warning('off','all');    % Turn off warnings
tgGlobal=tic;
% CodeFolder_SheetName_DataFolder_AlgName_v01 - function
[CodeFolder,~,DataFolder,~]=CodeFolder_SheetName_DataFolder_AlgName_v01;  % Locations of the code and data folders 

version=textscan(mfilename, '%s %s %d', 'delimiter','__');
% FileNames_v01 - function (Manual entry required)
[fname,datar,selected,cverSubFile_a,cverSubFile_b,AISubFile_a,AISubFile_b,AlgName]=FileNames_v01(version{3});
lselected=length(selected);
if isempty(selected)
    disp('There is no Runner_v0X_Y.m call in the NetworkList.xlsx file') % Runner_v0X_Y.m, there is no Y in the NetworkList_v0Z.xlsx file
end    
for iter=1:lselected
    tgLocal=tic;
    fprintf('Current date and time: %s\n',char(datetime('now')));
    fprintf('Testing set of networks: %d out of %d\n',iter,lselected);
    % FileNamesMore_v01 - function
    [MonteCarlo,MonteCarloTest,L,K,M,PdBTxRx,Init,Iter,GTS,Name1,Name2]=FileNamesMore_v01(datar,selected,iter);
    % CopyFiles_v01 - function
    [Inputfilename,Inputfolder]=CopyFiles_v01(L,K,M,MonteCarlo,MonteCarloTest,Name2,cverSubFile_a,cverSubFile_b,AISubFile_a,AISubFile_b,AlgName,CodeFolder,version{3});
    cd(CodeFolder)
    % AI_v01 - function
    [ErrorPercentage_Original,ErrorPercentage_New,sum_rate_AI,sum_rate_Original,sum_rate_OriginalM,counter,BCCER]=AI_v01(Name1,MonteCarloTest,L,K,M,PdBTxRx);
    % OutputsExcel_v01 - function
    OutputsExcel_v01(ErrorPercentage_Original,ErrorPercentage_New,sum_rate_AI,sum_rate_Original,sum_rate_OriginalM,counter,Inputfilename,Inputfolder,tgLocal,iter,MonteCarlo,MonteCarloTest,BCCER)                    
end
fprintf('Total simulation time is %s\n\n',secs2hms_v01(toc(tgGlobal)));
fprintf('\n');
fig = uifigure;
uialert(fig,[mfilename ' is completed'],'Success','Icon','success');     % Simulation completed notification box