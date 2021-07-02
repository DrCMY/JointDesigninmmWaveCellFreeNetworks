% NL: Stands for "network list". NL indicates that the value of the variable is obtained from the NetworkList.xlsx file. Therefore, to modify the value of a variable that has "NL" next to it, please modify the excel file NetworkList.xlsx
% PLEASE, add the "library" folder and its subfolders to Matlab's path
clc; close all; fclose('all'); dbstop if error; % dbclear if error;
closeoutputxlsxfile
totaltime=tic;
folder=fileparts(which(mfilename));
cd(folder)                                      % Change Matlab directory to the "code" folder
%set(0,'DefaultFigureVisible','off');            % Comment here for the detailed figure outputs
%set(0,'DefaultFigureVisible','on');            % Uncomment here for the detailed figure outputs
%set(findobj(0,'type','figure'),'visible','on') % If the figures still do not open, run this line
%warnings
%pause(3)
%[CodeFolder,SheetName,DataFolder]=CodeFolder_SheetName_DataFolder_v01;  % Locations of the code and data folders. Sheet name of the runme.xlsx file
[CodeFolder,SheetName,DataFolder,~]=CodeFolder_SheetName_DataFolder_AlgName_v02;  % Locations of the code and data folders. Sheet name of the runme.xlsx file
fname=dir('*NetworkList*.xlsx');
datar=xlsread([DataFolder fname.name],'A2:Z200'); % Read the NetworkList.xlsx file which contains the network parameters to be tested
Alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
MC=find(Alphabet=='A');                         % Number of Monte Carlo runs - NL2
Lr=find(Alphabet=='B');                         % L: Number of access points - NL
Kr=find(Alphabet=='C');                         % K: Number of users - NL
Mr=find(Alphabet=='D');                         % N: Number of antennas at an access point - NL
TxdB=find(Alphabet=='E');                       % SNR between a transmitter and a receiver in dB - NL
Initr=find(Alphabet=='F');                      % Number of random initializations - NL
Iterr=find(Alphabet=='G');                      % Number of iterations - NL
GTSr=find(Alphabet=='H');                       % Number of AP search groups - NL
Runners=find(Alphabet=='I');
version=textscan(mfilename, '%s %s %d', 'delimiter','__');
selected=find(datar(:,Runners)==version{3});
lselected=length(selected);
if isempty(selected)
    display(version{2}, 'There is no Runner_X.m call in the NetworkList.xlsx file: X')
end    
for iter=1:lselected
    fprintf('Current date and time: %s\n',char(datetime('now')));
    fprintf('Testing set of networks: %d out of %d\n',iter,lselected);
    x=selected(iter);
    cd(DataFolder)
    fname=dir('*Runme*');    
    xlswrite(fname.name,[datar(x,MC),datar(x,Lr),datar(x,Kr),datar(x,Mr),datar(x,TxdB),datar(x,Initr),datar(x,Iterr),datar(x,GTSr)]',SheetName,'A1:A8'),    
    cd(CodeFolder)
    clearvars -except datar MC Lr Kr Mr TxdB Initr Iterr GTSr Runners selected lselected iter totaltime tic; 
    fname=dir('Main*.m');
    run(fname.name)
end
fig = uifigure;
uialert(fig,[mfilename ' is completed'],'Success','Icon','success');