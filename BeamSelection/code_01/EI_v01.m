function EI_v01(MonteCarlo,L,K,M,PdBTxRx,Init,Iter,GTS,sigma2n,Name1,Name2,InputFolder)
tgGlobal=tic;
%AlgNameA='Semilinear_Joint_Init_Iter_Rate_BCC';                % Name of the joint design algorithm
AlgNameB='ZF';                                                  % Name of the digital precoder

[cverSubFile_a,cverSubFile_b]=CodeVersion_v01(mfilename);                          % Detection of the current code version 
[CodeFolder,~,~,AlgNameA]=CodeFolder_SheetName_DataFolder_AlgName_v01(mfilename);  % Location of the code folder. Beam selection algorithm name retrieved from the file name
AlgName=[AlgNameA '_' AlgNameB];
cd(CodeFolder)
disp(['Now ' AlgName ' is being executed'])

rate_MC=zeros(K,1);               % Sum of user rates over Monte Carlo runs  
rn_MC=zeros(1,L);                 % Rank results
cn_MC=zeros(1,L);                 % Condition number results 

[fi1,fi2,fi3,fido1,Name]=IOFiles_v01(Name1,Name2,cverSubFile_b);
fi2=replace(fi2,'_Us.log','_UsBCC.log');
Name=[Name '_' AlgName];
Complexity=Init*Iter*L*(M^K);     % Maximum complexity of the algorithm
loaders=zeros(3,1);
mc=1;                             % Monte Carlo counter
mM=(0:M-1);
U=(1/sqrt(M))*exp(-(1i*2*pi*(mM'*mM))/M);    % DFT matrix
UoptsMx=zeros(1,L*K);
converter=M.^(L*K-1:-1:0);
indexvM=zeros(MonteCarlo,1);
stepiM=zeros(MonteCarlo,1); % Uncomment for iteration control
while mc<=MonteCarlo
    H=dlmread(fi1,'\t',[loaders(1) 0 loaders(1)+K*M-1 L-1]);        % Channel variables
    sP=dlmread(fi3,'\t',[loaders(3) 0 loaders(3) L*K-1]);           % Power variables   
    loaders(1)=loaders(1)+K*M; 
    loaders(3)=loaders(3)+1;
    indexes=permn(1:M,K);
    errorsM=BCC_v01(indexes,1,K);
    indexes(errorsM',:)=[];
    [lindexes,~]=size(indexes);
    rate_Sum_max=0; 
    for initi=1:Init
        randindexes=dlmread(fi2,'\t',[loaders(2) 0 loaders(2) L*K-1]);      % Random beam index assignments
        Usx=U(:,randindexes);                                               % Randomly selected analog beamforming precoders based on random beam index assignments
        loaders(2)=loaders(2)+1;
        for stepi=1:Iter
            for l=0:L-1
                lvec=l*K+1:l*K+K;
                rate_O=zeros(1,lindexes);
                for lx=1:lindexes
                    Usx(:,lvec)=U(:,indexes(lx,:));         % Randomly selected beamforming vectors
                    rate_O(lx)=sum(rate_UV_ZF_v01(sP,L,K,M,H,Usx,sigma2n)); % ZF                                            
                end
                [~,lopt]=max(rate_O);
                index=indexes(lopt,:);
                Usx(:,lvec)=U(:,index);         
                UoptsMx(1,lvec)=index;
                %%%
                % BCC
                for k=1:K
                    for j=1:K
                        if j~=k
                            temp=find(index(j)==indexes(:,k));
                            indexes(temp,:)=[];
                        end
                    end
                end
                %%%
                [lindexes,~]=size(indexes);
            end
            rate_Sum=sum(rate_UV_ZF_v01(sP,L,K,M,H,Usx,sigma2n));           % Evaluate final rate after all assignments are completed
            if rate_Sum>rate_Sum_max                                        % Choose the beam combination with the highest rate result over multiple initializations and iterations
                rate_Sum_max=rate_Sum;
                Us=Usx;
                UoptsM=UoptsMx;
                stepi_opt=stepi;
            end
            %%%
        end
    end
    stepiM(mc)=stepi_opt; 
    indexvM(mc)=converter*(UoptsM-1)';
    [rate_U,rn,cn]=rate_UV_ZF_v01(sP,L,K,M,H,Us,sigma2n); 
    rate_MC=rate_MC+rate_U;
    rn_MC=rn_MC+rn;
    cn_MC=cn_MC+cn;
    mc=mc+1;
end
Outputs_v01(MonteCarlo,L,K,M,PdBTxRx,Init,mean(stepiM),GTS,fido1,AlgName,Name,Name1,cverSubFile_a,cverSubFile_b,tgGlobal,Complexity,InputFolder,rate_MC,indexvM,rn_MC,cn_MC)