function BIaIII_v10at04(MonteCarlo,L,K,M,PdBTxRx,Init,Iter,GTS,sigma2n,Name1,Name2,InputFolder)
tgGlobal=tic;
%AlgNameA='Multi_J_Init_Iter_BCC';                 % Name of the algorithm
AlgNameB='MMSE';                 % Name of the algorithm

[cverSubFile_a,cverSubFile_b]=CodeVersion_v01(mfilename);             % Calling subfunction to detect the version of the current code
[CodeFolder,~,~,AlgNameA]=CodeFolder_SheetName_DataFolder_AlgName_v02(mfilename);  % Locations of the code and data folders. Sheet name of the runme.xlsx file
AlgName=[AlgNameA '_' AlgNameB];
cd(CodeFolder)
disp(['Now ' AlgName ' is being executed'])

rate_MC=zeros(K,1);              % sum of individual user rates over Monte Carlo runs
rn_MC=zeros(1,L);
cn_MC=zeros(1,L);

[fi1,fi2,fi3,fido1,Name]=IOFiles_v02(Name1,Name2,cverSubFile_b);
fi2=replace(fi2,'_Us.log','_UsBCC.log');
Name=[Name '_' AlgName];
Complexity=Init*Iter*L*K*M;
%loaders=zeros(2,1);
loaders=zeros(3,1);
mc=1;               % Monte Carlo counter
mM=(0:M-1);
U=(1/sqrt(M))*exp(-(1i*2*pi*(mM'*mM))/M);    % DFT matrix. Normalized so that ||U_l||_F^2=1 per AP
UoptsMx=zeros(1,L*K);
%converter=M.^(L*K-1:-1:0); % Uncomment for AI training&testing
%indexvM=zeros(MonteCarlo,1);
indexvM=zeros(MonteCarlo,L*K);
stepiM=zeros(MonteCarlo,1); % Uncomment for iteration control
%Init=3; % Number of initializations
counter=0;
while mc<=MonteCarlo
    H=dlmread(fi1,'\t',[loaders(1) 0 loaders(1)+K*M-1 L-1]);
    %    randindexes=dlmread(fi2,'\t',[loaders(2) 0 loaders(2) L*K-1]);
%    sP=dlmread(fi3,'\t',[loaders(2) 0 loaders(2) L*K-1]);
    sP=dlmread(fi3,'\t',[loaders(3) 0 loaders(3) L*K-1]);
    %    Usx=U(:,randindexes);         % Randomly selected beamforming vectors
    loaders(1)=loaders(1)+K*M;
    %    loaders(2)=loaders(2)+1;
    loaders(3)=loaders(3)+1;
    rate_Sum_max=0; % Uncomment for iteration control
    for initi=1:Init
        randindexes=dlmread(fi2,'\t',[loaders(2) 0 loaders(2) L*K-1]);
        Usx=U(:,randindexes);         % Randomly selected beamforming vectors
        loaders(2)=loaders(2)+1;
        for stepi=1:Iter
            mMUsers=repmat(mM,[K,1]);
            kcounter=M*ones(K,1);
            for l=0:L-1
                for k=0:K-1
                    kx=kcounter(k+1);
                    rate_O=zeros(kx,1);
                    for m=1:kx
                        Usx(:,l*K+k+1)=U(:,mMUsers(k+1,m)+1);
                        %%%
                        % Uncomment for iteration control
                        %if strcmp(AlgNameB,'Multi-BCC')                      
                            %rate_O(m)=sum(rate_U_MultiIa_v03(sP,L,K,M,H,Usx,sigma2n));          % Multi-BCC
                        %elseif strcmp(AlgNameB,'ZF')                                           
                            %rate_O(m)=sum(rate_U_MultiwFilter_v02dt1b(sP,L,K,M,H,Usx,sigma2n));  % Multi-J-BCC-ZF                                                                            
                        %elseif strcmp(AlgNameB,'MMSE')                                         
                            rate_O(m)=sum(rate_U_MultiwFilter_v02dt2c(sP,L,K,M,H,Usx,sigma2n)); % Multi-J-BCC-MMSE                                                                        
                        %elseif strcmp(AlgNameB,'Selection')                                                                                                      
                            %rate_O(m)=sum(rate_U_MultiwFilter_v03(sP,L,K,M,H,Usx,sigma2n));     % Selection 
                        %end
                        %%%
                    end
                    [~,index]=max(rate_O);
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
                    Usx(:,l*K+k+1)=U(:,indexx+1);
                    UoptsMx(1,l*K+k+1)=indexx+1;
                end
            end
            %%%
            % Uncomment for iteration control
            %if strcmp(AlgNameB,'ZF')    
                %rate_Sum=sum(rate_U_MultiwFilter_v02dt1b(sP,L,K,M,H,Usx,sigma2n));      % ZF
            %elseif strcmp(AlgNameB,'MMSE')    
                rate_Sum=sum(rate_U_MultiwFilter_v02dt2c(sP,L,K,M,H,Usx,sigma2n));     % MMSE
            %end
            %%%
            if rate_Sum>rate_Sum_max
                rate_Sum_max=rate_Sum;
                Us=Usx;
                UoptsM=UoptsMx;
                stepi_opt=stepi;
                %             else
                %                 break
            end
            %%%
        end
    end
    stepiM(mc)=stepi_opt; % Uncomment for iteration control
    %indexvM(mc)=converter*(UoptsM-1)'; % No more decimal conversion due to large network sizes. 
    indexvM(mc,:)=UoptsM-1;
    %%%
    %if strcmp(AlgNameB,'ZF')
        %[rate_U,rn,cn]=rate_U_MultiwFilter_v02dt1b(sP,L,K,M,H,Us,sigma2n); % Calling the rate_U_Multi function. ZF
    %elseif strcmp(AlgNameB,'MMSE')
        [rate_U,rn,cn]=rate_U_MultiwFilter_v02dt2c(sP,L,K,M,H,Us,sigma2n); % Calling the rate_U_Multi function. MMSE
        if isnan(sum(rate_U))  % Needed for multi-path channel
            display(mc,'Monte Carlo number for the NaN case')
            counter=counter+1; 
        else        
            [rate_MC,rn_MC,cn_MC]=rate_rn_cn_v01(rate_MC,rate_U,rn_MC,rn,cn_MC,cn);
        end        
    %elseif strcmp(AlgNameB,'NoFilter')
    %    [rate_U,rn,cn]=rate_U_MultiII_v01(sP,L,K,M,H,Us,sigma2n);          % Calling the rate_U_Multi function. No filter
    %end
    %%%
    mc=mc+1;
%     sum(rate_U)
end
Outputs_Multi_v11(MonteCarlo,L,K,M,PdBTxRx,Init,mean(stepiM),GTS,fido1,AlgName,Name,Name1,cverSubFile_a,cverSubFile_b,tgGlobal,Complexity,InputFolder,rate_MC,indexvM,rn_MC,cn_MC)