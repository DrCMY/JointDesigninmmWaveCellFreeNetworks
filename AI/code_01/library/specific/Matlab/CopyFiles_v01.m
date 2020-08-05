function [Inputfilename,Inputfolderb]=CopyFiles_v01(L,K,M,MonteCarlo,MonteCarloTest,Name2,cverSubFile_a,cverSubFile_b,AISubFile_a,AISubFile_b,AlgName,CodeFolder,version)
Name1=sprintf('L%dK%dM%d',L,K,M);
Name=[Name1 '_' Name2 ];
Inputfilename=[Name '_' AlgName '.zip'];
Inputfoldera=['B:\Matlab\Shared\BeamSelection\code_01\Results\MC' num2str(MonteCarloTest) '\' cverSubFile_a '\' cverSubFile_b];   % Location of joint design results 

Inputfolderb=[CodeFolder 'Results\MC' num2str(MonteCarlo) '_MC' num2str(MonteCarloTest) '\' AISubFile_a '\' AISubFile_b '\0'];
Inputfolderc=['B:\Matlab\Shared\AI\code_01' '\Results\MC' num2str(MonteCarlo) '_MC' num2str(MonteCarloTest) '\' AISubFile_a '\' AISubFile_b '\0']; % Location of ML algorithm results

cd(Inputfoldera)
mkdir('Temp')
copyfile(Inputfilename,'.\Temp')
cd('.\Temp')
unzip(Inputfilename);
copyfile('*_FVD.mat',CodeFolder)
copyfile('*_Y_Binary.mat',CodeFolder)
copyfile('*_H.log',CodeFolder)
copyfile('*_sP.log',CodeFolder)
cd('..\')
rmdir('Temp','s')

Inputfilename=[Name '_' AlgName '_' cverSubFile_a '_' cverSubFile_b '.zip'];
if version~=1
    mkdir(Inputfolderb)
    cd(Inputfolderc)
    copyfile(Inputfilename,Inputfolderb)
end

cd(CodeFolder)
OldFileName=dir('*_Y_Binary.mat');
movefile(OldFileName.name,'Ytest.mat')
cd(Inputfolderb)
mkdir('Temp')
copyfile(Inputfilename,'.\Temp')
cd('.\Temp')
unzip(Inputfilename);
copyfile('*.mat',CodeFolder)
cd('..\')
rmdir('Temp','s')