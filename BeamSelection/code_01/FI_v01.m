function FI_v01(MonteCarlo,L,K,M,PdBTxRx,Init,Iter,GTS,sigma2n,Name1,Name2,InputFolder)
tgGlobal=tic;
%AlgNameA='Linear_Joint_Init_Iter_Sel_Rate_BCC';                 % Name of the joint design algorithm
AlgNameB='ZF';                                                   % Name of the digital precoder

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
Complexity=Init*Iter*L^2*K*M;                  % Complexity of the algorithm. It is L^2 because the algorithm has the selection feature
loaders=zeros(3,1);
mc=1;                                          % Monte Carlo counter
mM=(0:M-1);
U=(1/sqrt(M))*exp(-(1i*2*pi*(mM'*mM))/M);    % DFT matrix
UoptsMxx=zeros(1,L*K);
converter=M.^(L*K-1:-1:0); 
indexvM=zeros(MonteCarlo,1);
stepiM=zeros(MonteCarlo,1);
while mc<=MonteCarlo
    H=dlmread(fi1,'\t',[loaders(1) 0 loaders(1)+K*M-1 L-1]);             % Channel variables
    sP=dlmread(fi3,'\t',[loaders(3) 0 loaders(3) L*K-1]);                % Power variables    
    loaders(1)=loaders(1)+K*M;
    loaders(3)=loaders(3)+1;
    rate_Sum_max=0; % Uncomment for iteration control
for initi=1:Init    
    Lvec=0:L-1;
    randindexes=dlmread(fi2,'\t',[loaders(2) 0 loaders(2) L*K-1]);       % Random beam index assignments
    loaders(2)=loaders(2)+1;
    for j=1:L        
        Usxx=U(:,randindexes);                                           % Randomly selected analog beamforming precoders based on random beam index assignments
        rate_Sum_maxx=0;  
        for stepi=1:Iter            
            mMUsers=repmat(mM,[K,1]);
            kcounter=M*ones(K,1);
            for l=Lvec
                for k=0:K-1
                    kx=kcounter(k+1);
                    rate_O=zeros(kx,1);
                    for m=1:kx
                        Usxx(:,l*K+k+1)=U(:,mMUsers(k+1,m)+1);
                        rate_O(m)=sum(rate_UV_ZF_v01(sP,L,K,M,H,Usxx,sigma2n));   % Evaluate rate based on ZF digital precoder
                    end
                    [~,index]=max(rate_O);                                        % Choose the beam with the highest rate result
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
                    Usxx(:,l*K+k+1)=U(:,indexx+1);
                    UoptsMxx(1,l*K+k+1)=indexx+1;
                end
            end
            rate_Sum=sum(rate_UV_ZF_v01(sP,L,K,M,H,Usxx,sigma2n));   % Evaluate final rate after all assignments are completed     
            if rate_Sum>rate_Sum_maxx                                % Choose the beam combination with the highest rate result over multiple initializations and iterations
                rate_Sum_maxx=rate_Sum;
                Usx=Usxx;
                UoptsMx=UoptsMxx;                
            end
        end
        if rate_Sum_maxx>rate_Sum_max                               % Choose the beam combination with the highest rate result over selection options                        
            rate_Sum_max=rate_Sum_maxx;
            Us=Usx;
            UoptsM=UoptsMx;
            stepi_opt=stepi;
        end
        Lvec=circshift(Lvec,-1);
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