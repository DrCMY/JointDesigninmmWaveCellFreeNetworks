function [CodeFolder,SheetName,DataFolder,AlgNameA]=CodeFolder_SheetName_DataFolder_AlgName_v02x(cversion)
CodeFolder=[pwd '\'];
cd '..\..\Generator\'   
DataFolder=[pwd '\'];
SheetName=textscan(CodeFolder,'%s','delimiter','\');
SheetName=cellfun(@(v) v(end),SheetName);
SheetName=char(SheetName);
AlgNameA=0;
if nargin==1
    fname=dir('*NetworkList*.xlsx');
    [~,FileName,~]=xlsread(fname.name,'AlgorithmsList_v01','C1:C30');
    [~,AlgNames,~]=xlsread(fname.name,'AlgorithmsList_v01','D1:D30');
    AlgNameAx=AlgNames(strcmp(cversion,FileName));
    AlgNameA=AlgNameAx{1};
end
