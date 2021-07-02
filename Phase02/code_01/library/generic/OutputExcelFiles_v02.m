function [excelfile1,excelfile2]=OutputExcelFiles_v02
excelfile1xOr=dir('*Output*.xlsx');
excelfile1x=char(excelfile1xOr.name);
excelfile1=strtrim(excelfile1x(1,:));
if length(excelfile1xOr)>1
    fprintf('You were warned to close the %s file. Now closing all open xlsx files!\n', excelfile1)
    closexlsxfiles
end
ef=textscan(excelfile1, '%s %s', 'delimiter','.');  
t=char(datetime('now','Format','yyMMdd''_''HHmm'));
excelfile2=[char(ef{1}) '_' t '.xlsx'];