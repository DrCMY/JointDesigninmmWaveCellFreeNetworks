function AI_v01(MonteCarlo,L,K,M,PdBTxRx,Init,Iter,GTS,sigma2n,Name1,Name2,InputFolder)
tgGlobal=tic;
%AlgNameA='Linear_Joint_Init_Iter_Rate_NoBCC';     % Name of the joint design algorithm
AlgNameB='MMSE';                                   % Name of the digital precoder. Do not choose ZF since there is no BCC

[cverSubFile_a,cverSubFile_b]=CodeVersion_v01(mfilename);                           % Detection of the current code version 
[CodeFolder,~,~,AlgNameA]=CodeFolder_SheetName_DataFolder_AlgName_v01(mfilename);   % Location of the code folder. Beam selection algorithm name retrieved from the file name
AlgName=[AlgNameA '_' AlgNameB];
cd(CodeFolder)
disp(['Now ' AlgName ' is being executed'])

rate_MC=zeros(K,1);           % Sum of user rates over Monte Carlo runs    
rate_O=zeros(M,1);              
rn_MC=zeros(1,L);             % Rank results
cn_MC=zeros(1,L);             % Condition number results 

[fi1,fi2,fi3,fido1,Name]=IOFiles_v01(Name1,Name2,cverSubFile_b);
Name=[Name '_' AlgName];
Complexity=Init*Iter*L*K*M;                  % Complexity of the algorithm
loaders=zeros(3,1);
mc=1;                                        % Monte Carlo counter
mM=(0:M-1);
U=(1/sqrt(M))*exp(-(1i*2*pi*(mM'*mM))/M);    % DFT matrix
UoptsMx=zeros(1,L*K);
converter=M.^(L*K-1:-1:0);
indexvM=zeros(MonteCarlo,1);
stepiM=zeros(MonteCarlo,1); 
while mc<=MonteCarlo
    H=dlmread(fi1,'\t',[loaders(1) 0 loaders(1)+K*M-1 L-1]);        % Channel variables
    sP=dlmread(fi3,'\t',[loaders(3) 0 loaders(3) L*K-1]);           % Power variables    
    loaders(1)=loaders(1)+K*M;
    loaders(3)=loaders(3)+1;
    rate_Sum_max=0; 
    for initi=1:Init
        randindexes=dlmread(fi2,'\t',[loaders(2) 0 loaders(2) L*K-1]);      % Random beam index assignments
        Usx=U(:,randindexes);                                               % Randomly selected analog beamforming precoders based on random beam index assignments
        loaders(2)=loaders(2)+1;
        for stepi=1:Iter
            for l=0:L-1
                for k=0:K-1
                    for m=1:M
                        Usx(:,l*K+k+1)=U(:,m);
                        rate_O(m)=sum(rate_UV_MMSE_v01(sP,L,K,M,H,Usx,sigma2n));    % Evaluate rate based on MMSE digital precoder
                    end
                    [~,index]=max(rate_O);                                          % Choose the beam with the highest rate result
                    Usx(:,l*K+k+1)=U(:,index);
                    UoptsMx(1,l*K+k+1)=index;
                end
            end
            rate_Sum=sum(rate_UV_MMSE_v01(sP,L,K,M,H,Usx,sigma2n));                 % Evaluate final rate after all assignments are completed
            if rate_Sum>rate_Sum_max                                                % Choose the beam combination with the highest rate result over multiple initializations and iterations
                rate_Sum_max=rate_Sum;
                Us=Usx;
                UoptsM=UoptsMx;
                stepi_opt=stepi;
            end
        end
    end
    stepiM(mc)=stepi_opt; 
    indexvM(mc)=converter*(UoptsM-1)'; 
    [rate_U,rn,cn]=rate_UV_MMSE_v01(sP,L,K,M,H,Us,sigma2n); 
    rate_MC=rate_MC+rate_U;
    rn_MC=rn_MC+rn;
    cn_MC=cn_MC+cn;
    mc=mc+1;
end
Outputs_v01(MonteCarlo,L,K,M,PdBTxRx,Init,mean(stepiM),GTS,fido1,AlgName,Name,Name1,cverSubFile_a,cverSubFile_b,tgGlobal,Complexity,InputFolder,rate_MC,indexvM,rn_MC,cn_MC)