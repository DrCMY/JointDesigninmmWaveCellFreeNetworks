function OutputsExcel_v01(ErrorPercentage_Original,ErrorPercentage_New,sum_rate_AI,sum_rate_Original,sum_rate_OriginalM,counter,Inputfilename,Inputfolder,tgLocal,iter,MonteCarlo,MonteCarloTest,BCCEP)
[t1,t2]=secs2hms_v01(toc(tgLocal));
Inputfilename=Inputfilename(1:end-4);
Outputfilename=[Inputfilename '_Matlab.log'];
fo1=sprintf(Outputfilename);      
fido1 = fopen(fo1,'w');

fprintf(fido1,'The number of neglected runs= '); fprintf(fido1,'%d\t',counter); fprintf(fido1,'\n');
fprintf(fido1,'Error percentage original= '); fprintf(fido1,'%2.4f\t',ErrorPercentage_Original); fprintf(fido1,'\n');
fprintf(fido1,'Error percentage new= '); fprintf(fido1,'%2.4f\t',ErrorPercentage_New); fprintf(fido1,'\n');
fprintf(fido1,'Sum-rate AI= '); fprintf(fido1,'%2.4f\t',sum_rate_AI); fprintf(fido1,'\n');
fprintf(fido1,'Sum-rate original= '); fprintf(fido1,'%2.4f\t',sum_rate_Original); fprintf(fido1,'\n');
fprintf(fido1,'Sum-rate original modified= '); fprintf(fido1,'%2.4f\t',sum_rate_OriginalM); fprintf(fido1,'\n');
fprintf(fido1,'BCC error percentage= '); fprintf(fido1,'%2.4f\t',BCCEP); fprintf(fido1,'\n');
fprintf(fido1,'Run time-1= '); fprintf(fido1,'%s',t1); fprintf(fido1,'\n');
fprintf(fido1,'Run time-2= '); fprintf(fido1,'%s',t2); fprintf(fido1,'\n');
fclose('all');
InputfolderTemp=[Inputfolder '\Temp'];
mkdir(InputfolderTemp)
copyfile(Outputfilename,InputfolderTemp)
[excelfile1,excelfile2]=OutputExcelFiles_v01;
CurrentFolder=pwd;
Sheetname=['MC' num2str(MonteCarlo) '_MC' num2str(MonteCarloTest)];
xlswrite(excelfile1,{(100-ErrorPercentage_New),sum_rate_AI,sum_rate_Original,sum_rate_OriginalM,counter,BCCEP,t2},Sheetname,['K' num2str(iter+1)]), 
cd(Inputfolder)
Inputfilename=[Inputfilename '.zip'];
movefile(Inputfilename,'.\Temp')
cd('Temp')
unzip(Inputfilename)
cd(CurrentFolder)
copyfile(excelfile1,InputfolderTemp)
cd(InputfolderTemp)
delete(Inputfilename)
zip(Inputfilename,'*.*')
movefile(Inputfilename,'..\')
cd('..\')
rmdir('Temp','s')
cd(CurrentFolder)
mkdir('.\Results\ExcelFiles')
copyfile(excelfile1,['.\Results\ExcelFiles\' excelfile2])
delete('*.mat','*.log')
fprintf('Simulation time is %s\n\n',secs2hms_v01(toc(tgLocal)));



