function OutputsExcel_v08(ErrorPercentage_Original,ErrorPercentage_New,sum_rate_AI,sum_rate_Original,sum_rate_OriginalM,counter,Inputfilename,Inputfolder,tgLocal,iter,MonteCarlo,MonteCarloTest,BCCEP)
[t1,t2]=secs2hms_v04(toc(tgLocal));
Inputfilename=Inputfilename(1:end-4);
Outputfilename=[Inputfilename '_Matlab.log'];
fo1=sprintf(Outputfilename);      % Logging some details for each Monte Carlo run
fido1 = fopen(fo1,'w');
%disp(['The M-ary error percentage is ' num2str((MonteCarloTest*b-length(find(decision==Y)))/(MonteCarloTest*b)*100) '%'])
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
[excelfile1,excelfile2]=OutputExcelFiles_v02;
CurrentFolder=pwd;
%Outputfilename=dir('Output*.xlsx');
Sheetname=['MC' num2str(MonteCarlo) '_MC' num2str(MonteCarloTest)];
%%%
% Do not use this-This is incorrect. . Step 1) The worksheet must be empty before running the AI algorithm. Step 2) You run the sum-rate calculation right after AI for
%data=xlsread(Outputfilename.name,Sheetname,'A2:A200');  
%lcolumn=length(data); 
%xlswrite(Outputfilename.name,{(100-ErrorPercentage_New),sum_rate_AI,sum_rate_Original,sum_rate_OriginalM,counter,BCCEP,t2},Sheetname,['J' num2str(lcolumn+1)]),
%%%
xlswrite(excelfile1,{(100-ErrorPercentage_New),sum_rate_AI,sum_rate_Original,sum_rate_OriginalM,counter,BCCEP,t2},Sheetname,['K' num2str(iter+1)]), % This is correct
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
fprintf('Simulation time is %s\n\n',secs2hms_v04(toc(tgLocal)));
% fprintf('Sum-rate-original is %2.4f\n',sum_rate_Original);
% fprintf('Sum-rate-AI is %2.4f\n\n',sum_rate_AI);



