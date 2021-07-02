function Generator_CIIIg_v03a4
rng('shuffle') 
tgGlobal=tic;

%dTxRx=100; % Distance (m) between transmitter and receiver
c=3e8;      % Speed of light

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
%[MonteCarlo, L, K, M,Pt_dBm_m,~,~,~,sigma2n,lns,ple,fc,P,extra,dTxRx,d0,BW_m]=CCell{:};
%[MonteCarlo, L, K, M,Pt_dBm_m,~,~,~,sigma2n,~,~,fc,P,~,dTxRx,d0,BW_m]=CCell{:};
[MonteCarlo, L, K, M,Pt_dBm_m,~,~,~,sigma2n,~,~,fc,P,~,~,d0,BW_m]=CCell{:};
extra=1; % For multiple random initializations. For this version, multiple random initializations is not considered.

     
Pt_avg_m=(10^((Pt_dBm_m-30)/10))/K; % MmWave transmit power per user in watts
Pt_dBm_m=10*log10(Pt_avg_m)+30;

%d0=5; % Reference distance
%BW_m=850e6; % MmWave bandwidth
LK=L*K;
%dTxRxRange= dTxRx*(1+rand(LK,1));   % Uniform distribution between (1 and 2)*dTxRx
dTxRxL=95; dTxRxU=105;
%dTxRxRange= (dTxRxU-dTxRxL).*rand(LK,1)+dTxRxL;   % Uniform distribution between (1 and 2)*dTxRx
lnsL=4; lnsU=4;
lnsRange= (lnsU-lnsL).*rand(LK,1)+lnsL;   % Uniform distribution between lnsL and lnsU
%lnsRange= (lnsU-lnsL).*rand(LK,P)+lnsL;   % Uniform distribution between lnsL and lnsU. Multi-path
pleL=2; pleU=2;
%pleRange=(pleU-pleL).*rand(LK,1)+pleL;   % Uniform distribution between pleL and pleU
%pleRange=(pleU-pleL).*rand(LK,P)+pleL;   % Uniform distribution between pleL and pleU. Multi-path
pl_m=zeros(LK,P);
for p = 1 : P
    dTxRxRange= (dTxRxU-dTxRxL).*rand(LK,1)+dTxRxL;   % Uniform distribution between (1 and 2)*dTxRx
    pleRange=(pleU-pleL).*rand(LK,1)+pleL;   % Uniform distribution between pleL and pleU
    pl_m(:,p) = (4*pi*d0*fc/c).^2*(dTxRxRange/d0).^pleRange;
end
pl=zeros(LK,P);
%pl_m=(4*pi*d0*fc/c).^2*(dTxRxRange/d0).^ple;
%pl_m=(4*pi*d0*fc/c)^2*(dTxRx/d0).^pleRange;
%pl_m=(4*pi*d0*fc/c)^2*(dTxRx/d0)^ple;
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
filename6=[Name '_Time.log'];  % Average received SNR per transmitter 
fido6 = fopen(filename6,'w');

H=zeros(K*M,L);
mM=(0:M-1)';
c1=sqrt(M/P); % constant #1
c2=1/sqrt(M); % constant #2
Kfac = 10;    % K-factor in dB
KfacLin = 10^(Kfac/10); % K-factor linear

%LK=L*K;
%sPM=zeros(MonteCarlo,LK);
betaM=zeros(MonteCarlo,LK);
sqrtplM=zeros(MonteCarlo,LK);
thetaM=zeros(MonteCarlo,LK);
HgainM=zeros(MonteCarlo,LK);
HrealMR=zeros(MonteCarlo,M*LK);
HrealMI=zeros(MonteCarlo,M*LK);
U=(1/sqrt(M))*ones(M,LK);
rate_U=zeros(MonteCarlo,K);
rate_UTr=zeros(MonteCarlo,LK);
% Total=2*LKP+2*LK+2*MLK+K
%PLinTxRxM=zeros(L*K,P);
PLinTxRxM=zeros(L*K,1);


% Random initial codeword generation w/ BCC
if M>=LK
    randindexesx=nextperm(M, LK);
else
    randindexesx=nextperm(M, M);
end

%dbstop at 101
for mc=1:MonteCarlo    
    for p = 1 : P
        pl(:,p)=10*log10(pl_m(:,p))+lognrnd(0,lnsRange,LK,1);  % Shadowing
    end
    
    %pl=10*log10(pl_m)*ones(LK,1);                  % No shadowing. For P=1 only
    
    %sqrtpl=sqrt(pl);
    %Pr_avg_dBm_m=Pt_dBm_m-pl;       % Average received power MmWave
    Pr_avg_dBm_m=Pt_dBm_m-pl;       % Average received power MmWave
    SNR_dB_m=Pr_avg_dBm_m-N0_dBm_m; % MmWave SNR in dB    
    PLinTxRx=10.^(SNR_dB_m/10);      % MmWave SNR in linear scale
    PLinTxRx = PLinTxRxfunc(PLinTxRx,LK,P,KfacLin);
    PLinTxRx=sum(PLinTxRx,2);      % MmWave SNR in linear scale
      
    PLinTxRxM=PLinTxRxM+PLinTxRx;
    sP=sqrt(PLinTxRx);            % Equal power allocation to all users
    %sP=sum(sqrt(PLinTxRx),2);            % Equal power allocation to all users
    %sP=sqrt(sum(PLinTxRx,2));            % Equal power allocation to all users
    %sP=mean(sqrt(PLinTxRx),2);            % Equal power allocation to all users
%    sP = ones(LK,1);
%    sPM(mc,:)=sP';                % sPM is not in use
    dlmwrite(filename4,sP','-append','delimiter','\t','precision','%3.6f');   
    
    %sqrtplM(mc,:)=sqrtpl(:)';
    %PLinTxRx = PLinTxRx';
    %sqrtplM(mc,:)=PLinTxRx(:);
    sqrtplM(mc,:)=PLinTxRx';
    beta=normrnd(Mean,SqrtVarpD,LK,P)+1i*normrnd(Mean,SqrtVarpD,LK,P);
    [beta,ind] = betaTxRxfunc(beta,LK,P,KfacLin);
    for i = 1 : LK
        betaM(mc,i) = abs(beta(i,ind(i)));
    end
    %betaM(mc,:) = abs(beta(:,ind'))';
        
    theta=-1 + 2*rand(LK,P);   % Uniform distribution between -1 and 1
    for i = 1 : LK
        thetaM(mc,i) = theta(i,ind(i));
    end   
    %thetaM(mc,:) = theta(:,ind')';    
    for i=0:L-1
        for k=0:K-1           
            % Original
            a=zeros(M,1);            
            for p=1:P
                a=a+c2*beta(i*K+k+1,p)*exp(1i*pi*theta(i*K+k+1,p)*mM);
            end
            %H(k*M+1:k*M+M,i+1)=sqrtpl(i*K+k+1)*c1*a;
            H(k*M+1:k*M+M,i+1)=c1*a;
            %K-factor
%             a=zeros(M,P);            
%             for p=1:P
%                 a(:,p)=c2*beta(i*K+k+1,p)*exp(1i*pi*theta(i*K+k+1,p)*mM);
%             end            
%             %a = afunc(a,P,KfacLin);
%             a = PLinTxRxfunc(a,M,P,KfacLin);           
%            H(k*M+1:k*M+M,i+1)=c1*sum(a,2);
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
        randindexes=randindexesx(); 
    else
        randindexes(1,1:M)=randindexesx(); 
        for x=1:(LK-M)
            locat=rem((M+x),K);
            if locat==0
                locat=K;
            end
            randindexes(:,M+x)=randindexes(:,locat);
        end
    end
    dlmwrite(filename2b,randindexes,'-append','delimiter','\t','precision','%i');        
end
MCLK=MonteCarlo*LK;
PLinTxRxMNew=zeros(L,1);
for l=0:L-1
    PLinTxRxMNew(l+1,1)=sum(PLinTxRxM(l*K+1:l*K+K,:),'all');
end
fprintf(fido5,'%2.4f\t',10*log10(sum(PLinTxRxMNew)/(MonteCarlo*L)));

%%%
% Normalization v04
sqrtplMNorm=(sqrtplM-(sum(sqrtplM,1)/MonteCarlo))./(max(sqrtplM,[],1)-min(sqrtplM,[],1)); % KL - selected
thetaMNorm=(thetaM-(sum(thetaM,1)/MonteCarlo))./(max(thetaM,[],1)-min(thetaM,[],1));      % KL - selected
betaMNorm=(betaM-(sum(betaM,1)/MonteCarlo))./(max(betaM,[],1)-min(betaM,[],1));           % KL - selected
rate_UNorm=(rate_U-(sum(sum(rate_U))/(MonteCarlo*K)))/(max(max(rate_U))-min(min(rate_U))); % K - selected

HgainMNorm=(HgainM-(sum(sum(HgainM))/MCLK))/(max(max(HgainM))-min(min(HgainM)));      % KL
HrealMRNorm=(HrealMR-(sum(sum(HrealMR))/(MCLK*M)))/(max(max(HrealMR))-min(min(HrealMR))); % MLK
HrealMINorm=(HrealMI-(sum(sum(HrealMI))/(MCLK*M)))/(max(max(HrealMI))-min(min(HrealMI))); % MLK
rate_UTrNorm=(rate_UTr-(sum(sum(rate_UTr))/MCLK))/(max(max(rate_UTr))-min(min(rate_UTr))); % KL
featurev=[betaMNorm,sqrtplMNorm,thetaMNorm,rate_UNorm,HgainMNorm,HrealMRNorm,HrealMINorm,rate_UTrNorm];
%featurev=[betaMNorm,sqrtplMNorm,rate_UNorm,thetaMNorm,HgainMNorm,HrealMRNorm,HrealMINorm,rate_UTrNorm];
save(filename3,'featurev')
[totaltime,~]=secs2hms_v04(toc(tgGlobal));
fprintf('Total time to generate the input files is %s.\n',totaltime)
fprintf(fido6,'%s',totaltime);
fclose('all');
destination=['./Inputs/MC' num2str(MonteCarlo) '/L' num2str(L) '/K' num2str(K)];
zip(Name,{'*.mat', '*.log'});
delete('*.mat', '*.log')
movefile('*.zip', destination), 

function PLx = PLinTxRxfunc(PLx,LK,P,KfacLin)
    epsx = 1e-4;
    [PLxMax, ind] = max(abs(PLx),[],2);
    PLxSum = sum(abs(PLx),2) - PLxMax;
%     if sum(PLxSum < 1e-4) > 0        
%        xxx = 1;
%     end
    c3 = KfacLin ./ (PLxMax ./ PLxSum);
    for i = 1 : LK
        if PLxSum(i) > epsx 
            for p = 1 : P
                if p ~= ind(i)
                    PLx(i,p) = PLx(i,p) / c3(i);
%                     if  isnan(PLx(i,p))
%                         xxx = 1;
%                     end
                end
            end
        end
    end
                    
function [PLx,ind] = betaTxRxfunc(PLx,LK,P,KfacLin)
    epsx = 1e-4;
    [PLxMax, ind] = max(abs(PLx),[],2);
    PLxSum = sum(abs(PLx),2) - PLxMax;
%     if sum(PLxSum < 1e-4) > 0        
%        xxx = 1;
%     end
    c3 = KfacLin ./ (PLxMax ./ PLxSum);
    for i = 1 : LK
        if PLxSum(i) > epsx 
            for p = 1 : P
                if p ~= ind(i)
                    PLx(i,p) = PLx(i,p) / c3(i);
%                     if  isnan(PLx(i,p))
%                         xxx = 1;
%                     end
                end
            end
        end
    end