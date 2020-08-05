function Generator_CIIId_v02
rng('shuffle') 
tgGlobal=tic;

%dTxRx=100; % Distance (m) between transmitter and receiver
c=3e8;      % Speed of light
%P=1;     % Total number of paths. This parameter can be inserted in NetworkList.xlsx or runme.xlsx depending on how you will do the test runs
         % You need to create a subfolder for P
Mean=0;                        % Mean of the channel
SqrtVarpD=sqrt(.5);            % Variance of the channel per dimension

a=dir('*runme*');
fiditemp=fopen('code_0X.log','r');
sheetname=fscanf(fiditemp,'%s');     
fclose(fiditemp); delete('*.log');
C=xlsread(a.name,sheetname,'A1:A25');
CCell = num2cell(C);
%[MonteCarlo, L, K, M,PdBTxRx,~,~,sigma2n,lns,ple,fc]=CCell{:};
%[MonteCarlo, L, K, M,~,~,~,sigma2n,lns,ple,fc]=CCell{:};
[MonteCarlo, L, K, M,Pt_dBm_m,~,~,~,sigma2n,lns,ple,fc,P,extra,dTxRx,d0,BW_m]=CCell{:};

%Pt_dBm_m=43-10*log10(M); % Total MmWave transmit power. Array gain is removed. You already removed this gain in your digital precoder design. Not in use       
%Pt_dBm_m=43; % Total MmWave transmit power. High SNR        
%Pt_dBm_m=25; % Total MmWave transmit power. Low SNR ~ 0 dB        
Pt_avg_m=(10^((Pt_dBm_m-30)/10))/K; % MmWave transmit power per user in watts
Pt_dBm_m=10*log10(Pt_avg_m)+30;

%d0=5; % Reference distance
%BW_m=850e6; % MmWave bandwidth
pl_m=(4*pi*d0*fc/c)^2*(dTxRx/d0)^ple;
N0_dBm_m=-173.8+10*log10(BW_m); % MmWave Noise power in dBm
%N0=10^((N0_dBm_m-30)/10);

Name=sprintf('L%dK%dM%d',L,K,M); 
filename1=[Name '_H.log'];  % S-R channel file
filename2a=[Name '_Us.log'];  % Codeword initializations
filename2b=[Name '_UsBCC.log'];  % Codeword initializations
filename3=[Name '_FV.mat'];  % Feature vectors
filename4=[Name '_sP.log'];  % Average received power 
filename5=[Name '_SNR.log'];  % Average received SNR per transmitter 
fido5 = fopen(filename5,'w');

H=zeros(K*M,L);
mM=(0:M-1)';
c1=sqrt(M/P); % constant #1
c2=1/sqrt(M); % constant #2

LK=L*K;
sPM=zeros(MonteCarlo,LK);
sqrtplM=zeros(MonteCarlo,LK);
thetaM=zeros(MonteCarlo,LK);
HgainM=zeros(MonteCarlo,LK);
HrealMR=zeros(MonteCarlo,M*LK);
HrealMI=zeros(MonteCarlo,M*LK);
U=(1/sqrt(M))*ones(M,LK);
rate_U=zeros(MonteCarlo,K);
rate_UTr=zeros(MonteCarlo,LK);
% Total=4*LK+2*MLK+K
PLinTxRxM=zeros(L*K,1);
%extra=5; % Extra numbers of Us and UsBCC generation
for mc=1:MonteCarlo    
    %pl=mean(10*log10(pl_m)+normrnd(0,lns,LK,P),2); % This is not working
    pl=mean(10*log10(pl_m)+lognrnd(0,lns,LK,P),2);  % This is working
    %pl=10*log10(pl_m)*ones(LK,1);                  % No shadowing. For P=1 only
    sqrtpl=sqrt(pl);
    Pr_avg_dBm_m=Pt_dBm_m-pl;       % Average received power MmWave
    SNR_dB_m=Pr_avg_dBm_m-N0_dBm_m; % MmWave SNR in dB    
    PLinTxRx=10.^(SNR_dB_m/10);      % MmWave SNR in linear scale
    PLinTxRxM=PLinTxRxM+PLinTxRx;
    sP=sqrt(PLinTxRx);            % Equal power allocation to all users
    sPM(mc,:)=sP';
    dlmwrite(filename4,sP','-append','delimiter','\t','precision','%3.6f');   
    
    sqrtplM(mc,:)=sqrtpl';
    beta=normrnd(Mean,SqrtVarpD,LK,P)+1i*normrnd(Mean,SqrtVarpD,LK,P);
    theta=-1 + 2*rand(LK,P);   % Uniform distribution between -1 and 1
    thetaM(mc,:)=mean(theta,2)';
    for i=0:L-1
        for k=0:K-1           
            a=zeros(M,1);            
            for p=1:P
                a=a+c2*beta(i*K+k+1,p)*exp(1i*pi*theta(i*K+k+1,p)*mM);
            end
            %H(k*M+1:k*M+M,i+1)=sqrtpl(i*K+k+1)*c1*a;
            H(k*M+1:k*M+M,i+1)=c1*a;
        end
    end
    dlmwrite(filename1,H,'-append','delimiter','\t','precision','%3.6f');   
    
    for i=0:L-1
        for k=1:K
            rangekM=(k-1)*M;
            rangeikM=i*M*K+(k-1)*M;
            Hx=H(rangekM+1:rangekM+M,i+1);
            HgainM(mc,i*K+k)=norm(Hx);
            HrealMR(mc,rangeikM+1:rangeikM+M)=real(Hx)';
            HrealMI(mc,rangeikM+1:rangeikM+M)=imag(Hx)';
        end
    end
    
    rate_U(mc,:)=rate_U_MultiIa_v03(sP,L,K,M,H,U,sigma2n)';  
    rate_UTr(mc,:)=reshape(rate_U_MultiTr_v03(sP,L,K,M,H,U,sigma2n)',[1,LK]); 
%% Test
%     sPx=1;
%     rate_U(mc,:)=rate_U_Multi_v03(sPx,L,K,M,H,U,sigma2n)';  
%     rate_UTr(mc,:)=reshape(rate_U_MultiTr_v02(sPx,L,K,M,H,U,sigma2n)',[1,LK]);     
    
    % Random initial codeword generation w/o BCC
    randindexes=randi([1,M],extra,LK);    % Random indexes. Always generates LK of them
    dlmwrite(filename2a,randindexes,'-append','delimiter','\t','precision','%i');   
    
    % Random initial codeword generation w/ BCC
    if M>=LK
        imax=factorial(M)/factorial(M-LK);
        i=randi(imax,extra,1);
        randindexesx=npermutek((1:M),LK);    
        randindexes=randindexesx(i,:);    
    else
        imax=factorial(M);
        i=randi(imax,extra,1);
        randindexesx=npermutek((1:M),M);    
        randindexes(:,1:M)=randindexesx(i,:);    
        for x=1:(LK-M)
            locat=rem((M+x),K);
            if locat==0
                locat=K;
            end
            randindexes(:,M+x)=randindexes(:,locat);
        end
    end
    dlmwrite(filename2b,randindexes,'-append','delimiter','\t','precision','%i');       
    
    % The following approach takes A LOT of time
%     checker=1;
%     while checker~=0
%         randindexes=randi([1,M],1,LK);    % Random indexes. Always generates LK of them
%         checker=sum(BCC_v02(randindexes,L,K));
%     end
    
    
    
    
end
MCLK=MonteCarlo*LK;
PLinTxRxMNew=zeros(L,1);
for l=0:L-1
    PLinTxRxMNew(l+1,1)=sum(PLinTxRxM(l*K+1:l*K+K));
end
%PLinTxRxM=10*log10(sum(PLinTxRxM)/MCLK); % Average received SNR per Tx-Rx pair in dB
%fprintf(fido5,'%2.4f\t',PLinTxRxM);
fprintf(fido5,'%2.4f\t',10*log10(sum(PLinTxRxMNew)/(MonteCarlo*L)));
%%%
% Normalization v01
% sqrtplMNorm=(sqrtplM-(sum(sum(sqrtplM))/MCLK))/(max(max(sqrtplM))-min(min(sqrtplM))); % KL - selected
% thetaMNorm=(thetaM-(sum(sum(thetaM))/MCLK))/(max(max(thetaM))-min(min(thetaM)));      % KL - selected
%%%

%%%
% Normalization v02
% sqrtplMa=abs(sqrtplM);
% thetaMa=abs(thetaM);
% sqrtplMNorm=(sqrtplM-(sum(sum(sqrtplMa))/MCLK))/(max(max(sqrtplMa))-min(min(sqrtplMa))); % KL - selected
% thetaMNorm=(thetaM-(sum(sum(thetaMa))/MCLK))/(max(max(thetaMa))-min(min(thetaMa)));      % KL - selected
%%%

%%%
% Normalization v03
% sqrtplMa=abs(sqrtplM);
% thetaMa=abs(thetaM);
% sqrtplMNorm=(sqrtplM-(sum(sqrtplMa,1)/MonteCarlo))./(max(sqrtplMa,[],1)-min(sqrtplMa,[],1)); % KL - selected
% thetaMNorm=(thetaM-(sum(thetaMa,1)/MonteCarlo))./(max(thetaMa,[],1)-min(thetaMa,[],1));      % KL - selected
%%%

%%%
% Normalization v04
sqrtplMNorm=(sqrtplM-(sum(sqrtplM,1)/MonteCarlo))./(max(sqrtplM,[],1)-min(sqrtplM,[],1)); % KL - selected
thetaMNorm=(thetaM-(sum(thetaM,1)/MonteCarlo))./(max(thetaM,[],1)-min(thetaM,[],1));      % KL - selected

HgainMNorm=(HgainM-(sum(sum(HgainM))/MCLK))/(max(max(HgainM))-min(min(HgainM)));      % KL
HrealMRNorm=(HrealMR-(sum(sum(HrealMR))/(MCLK*M)))/(max(max(HrealMR))-min(min(HrealMR))); % MLK
HrealMINorm=(HrealMI-(sum(sum(HrealMI))/(MCLK*M)))/(max(max(HrealMI))-min(min(HrealMI))); % MLK
rate_UNorm=(rate_U-(sum(sum(rate_U))/(MonteCarlo*K)))/(max(max(rate_U))-min(min(rate_U))); % K - selected
rate_UTrNorm=(rate_UTr-(sum(sum(rate_UTr))/MCLK))/(max(max(rate_UTr))-min(min(rate_UTr))); % KL
featurev=[sqrtplMNorm,thetaMNorm,HgainMNorm,HrealMRNorm,HrealMINorm,rate_UNorm,rate_UTrNorm];
save(filename3,'featurev')
fclose('all');
[totaltime,~]=secs2hms_v04(toc(tgGlobal));
fprintf('Total time to generate the input files is %s.\n',totaltime)
destination=['./Inputs/MC' num2str(MonteCarlo) '/L' num2str(L) '/K' num2str(K)];
zip(Name,{'*.mat', '*.log'});
delete('*.mat', '*.log')
movefile('*.zip', destination), 