function closeoutputxlsxfile
outputexcelfile=dir('*Output*.xlsx');
outputexcelfileOr=outputexcelfile.name;
while length(outputexcelfile)>1        
    fprintf('Please, close the %s file and then press ENTER\n', outputexcelfileOr)
    pause
    outputexcelfile=dir('*Output*.xlsx');
end