function BI_v01(MonteCarlo,L,K,M,PdBTxRx,Init,Iter,GTS,sigma2n,Name1,Name2,InputFolder)
tgGlobal=tic;
%AlgNameA='Linear_Disjoint_DL_BCC';      % Name of the joint design algorithm
AlgNameB='ZF';                           % Name of the digital precoder. 

[cverSubFile_a,cverSubFile_b]=CodeVersion_v01(mfilename);                          % Detection of the current code version 
[CodeFolder,~,~,AlgNameA]=CodeFolder_SheetName_DataFolder_AlgName_v01(mfilename);  % Location of the code folder. Beam selection algorithm name retrieved from the file name
AlgName=[AlgNameA '_' AlgNameB];
cd(CodeFolder)
disp(['Now ' AlgName ' is being executed'])

rate_MC=zeros(K,1);                      % Sum of user rates over Monte Carlo runs
rn_MC=zeros(1,L);                        % Rank results
cn_MC=zeros(1,L);                        % Condition number results 

[fi1,~,fi3,fido1,Name]=IOFiles_v01(Name1,Name2,cverSubFile_b);
Name=[Name '_' AlgName];
loaders=zeros(2,1);
mc=1;               % Monte Carlo counter
mM=(0:M-1);
U=(1/sqrt(M))*exp(-(1i*2*pi*(mM'*mM))/M);    % DFT matrix
UoptsM=zeros(1,L*K);
Complexity=Iter*L*K*M;                       % Complexity of the algorithm
converter=M.^(L*K-1:-1:0);                  
indexvM=zeros(MonteCarlo,1);
Us=zeros(M,L*K);
while mc<=MonteCarlo 
    H=dlmread(fi1,'\t',[loaders(1) 0 loaders(1)+K*M-1 L-1]);        % Channel variables  
    sP=dlmread(fi3,'\t',[loaders(2) 0 loaders(2) L*K-1]);           % Power variables 
    loaders(1)=loaders(1)+K*M;
    loaders(2)=loaders(2)+1;
    for stepi=1:Iter
        mMUsers=repmat(mM,[K,1]);
        kcounter=M*ones(K,1);        
        for l=0:L-1
            for k=0:K-1
                kx=kcounter(k+1);
                rate_O=zeros(kx,1);                              
                for m=1:kx
                    Us(:,l*K+k+1)=U(:,mMUsers(k+1,m)+1);
                    rate_O(m)=abs(sP(l*K+k+1)*H(k*M+1:k*M+M,l+1)'*Us(:,l*K+k+1))^2;   % Evaluate direct link power
                end
                [~,index]=max(rate_O);                            % Choose the beam with the highest direct link power result
                %%%
                % BCC
                indexx=mMUsers(k+1,index);
                kNot=(0:K-1)';
                kNot(k+1)=[];
                for kk=1:K-1
                    indexxx=find(mMUsers(kNot(kk)+1,:)==indexx);
                    if ~isempty(indexxx)
                        mMUsers(kNot(kk)+1,indexxx:end)=[mMUsers(kNot(kk)+1,indexxx+1:end) 0.1];
                        kcounter(kNot(kk)+1)=kcounter(kNot(kk)+1)-1;
                    end
                end
                %%%
                Us(:,l*K+k+1)=U(:,indexx+1);
                UoptsM(1,l*K+k+1)=indexx+1;
            end
        end        
    end
    indexvM(mc)=converter*(UoptsM-1)'; 
    [rate_U,rn,cn]=rate_UV_ZF_v01(sP,L,K,M,H,Us,sigma2n); 
    rate_MC=rate_MC+rate_U;
    rn_MC=rn_MC+rn; 
    cn_MC=cn_MC+cn; 
    mc=mc+1;
end
Outputs_v01(MonteCarlo,L,K,M,PdBTxRx,Init,Iter,GTS,fido1,AlgName,Name,Name1,cverSubFile_a,cverSubFile_b,tgGlobal,Complexity,InputFolder,rate_MC,indexvM,rn_MC,cn_MC)