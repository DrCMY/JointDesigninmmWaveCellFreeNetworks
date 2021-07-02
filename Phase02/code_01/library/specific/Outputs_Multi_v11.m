function Outputs_Multi_v11(MonteCarlo,L,K,M,PdBTxRx,Init,Iter,GTS,fido1,AlgName,Name,Name1,cverSubFile_a,cverSubFile_b,tgGlobal,Complexity,InputFolder,rate_MC,indexvM,rn_MC,cn_MC)
% P = 3; % Manual entry for number of paths
rn_MC=sum(rn_MC)/(L*MonteCarlo);
%cn_MC=sum(cn_MC)/(L*K*M*MonteCarlo);
cn_MC=sum(cn_MC)/(L*MonteCarlo);
rate_MC=rate_MC/MonteCarlo;
sum_rate_MC=sum(rate_MC);
fprintf(fido1,'Rate per user= '); fprintf(fido1,'%2.4f\t',rate_MC); fprintf(fido1,'\n');
fprintf(fido1,'Sum rate= '); fprintf(fido1,'%2.4f\t',sum_rate_MC); fprintf(fido1,'\n');
[t1,t2]=secs2hms_v04(toc(tgGlobal));
fprintf(fido1,'Total Run Time= %s',t1);fprintf(fido1,'\n');
[~,computername] = system('hostname');     % Computer name
computername=strtrim(computername);
fprintf(fido1,'Computer name is %s\n',computername);

Outputfilename=[Name '.zip'];
Outputfolder=['\Results\MC' num2str(MonteCarlo) '\' cverSubFile_a '\' cverSubFile_b];
Currentfolder=pwd;
Outputfile=[Currentfolder Outputfolder '\' Outputfilename];
fclose('all');
versionx=dir('*Runners*.m');
version=textscan(versionx.name, '%s %s %d', 'delimiter','__');
version=version{3};

%closexlsxfiles  % Closing all excel files

%%%%
% Writing the header row in the excel file
[excelfile1,excelfile2]=OutputExcelFiles_v02;
Sheet=['MC' num2str(MonteCarlo)];
Row1={'L','K', 'M', 'Network','Tx dBm','Init','Av. Iter','GTS','Alg. Name','Sum-Rate','Av. Rank','Av. Cond. N.','Total Time-1','Total Time-2','Complexity',['Data Input' newline 'Location'],['Data Output' newline 'Location'],'Date'};
%%% Write the first row if the first row is empty
[~,B] = xlsfinfo(excelfile1); % Comment 2020/04/14 11:50
if isempty(find(ismember(B, Sheet),1))    
    xlswrite(excelfile1,Row1,Sheet,'A1');
end


%%%%
% Writing the output data in the excel file
data=xlsread(excelfile1,Sheet,'A2:A200');  
lcolumn=length(data)+1; 
Network=['L' num2str(L) '-K' num2str(K) '-M' num2str(M)];
xlswrite(excelfile1,{L,K,M,Network,PdBTxRx,Init,Iter,GTS,AlgName,sum_rate_MC,rn_MC,cn_MC,t1,t2,Complexity,InputFolder,Outputfile,datestr(datetime)},Sheet,['A' num2str(lcolumn+1)]),
% 
% %%%%
load([Name1 '_FV.mat']) % Load feature vector without results
featurev=[featurev, indexvM];
save([Name1 '_FVD.mat'],'featurev') % Save feature vector with results

%%%%
% Create X and Y (training&test)
X=featurev(:,1:3*L*K+K); 


%%%
% No more decimal conversion due to large network sizes. For instance, BIaIII_v10at03.m has no decimal conversion
% Y=indexvM; % For readability
% save([Name1 '_Y_Decimal.mat'], 'Y'); 
% if sum(featurev(:,end)>1e15)>0 || M>36            % dec2base accepts 2<=M<=36. Similarly, featurev has a limit value for dec2base
%     Y=0;                                         % Create M-ary Y matrix. Due to the flintmax limit of dec2base, ... read the rest in Outputs_Multi_v06.txt
% else
%     %Y=dec2base(featurev(:,end),M);         % Create M-ary Y matrix    
%     Y=dec2base(indexvM,M);         % Create M-ary Y matrix. This one is better!
% end

Y=indexvM;
%Y=array2table(Y);Y=table2cell(Y);Y=str2double(Y); % Since dec2base generates char array, conversions are needed
save([Name1 '_Y_Binary.mat'], 'Y'); 
save([Name1 '_X.mat'], 'X'), 
%%%%

mkdir('.\Results\ExcelFiles')
copyfile(excelfile1,['.\Results\ExcelFiles\' excelfile2])
copyfile('../Generator/*.m',Currentfolder)  % Needs to be modified for GitLab upload
copyfile('../Generator/*.xlsx',Currentfolder) % Needs to be modified for GitLab upload
zip(Outputfilename,{'*.mat','*.log',[cverSubFile_a '*.m'],'Runners*.m','Main*.m','*.xlsx','./library/*.*'});
if version~=1
    %OutputfolderExtra=strrep(Outputfile, ['code_0' num2str(version)], 'code_01');
    zipfile=dir('*.zip');
    zipfile=zipfile.name;
    OutputfolderExtra=[Currentfolder Outputfolder '\'];
    OutputfolderExtra=strrep(OutputfolderExtra, ['code_0' num2str(version)], 'code_01');   
    mkdir(OutputfolderExtra)
    copyfile(zipfile,OutputfolderExtra);   
end
movefile('*.zip',['.' Outputfolder])
delete('*.mat','*.log','*.tex','*.bak')
delete('Gene*.m','Netw*.xlsx','Runme*.xlsx')
close all
fprintf('Total simulation time is %s\n',t1);
fprintf('Sum-rate is %2.4f\n',sum_rate_MC);
fprintf('\n');