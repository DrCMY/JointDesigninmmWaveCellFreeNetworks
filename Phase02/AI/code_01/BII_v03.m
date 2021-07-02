function [ErrorPercentage_Original,ErrorPercentage_New,sum_rate_AI,sum_rate_Original,sum_rate_OriginalM,counter,BCCEP]=BII_v03(Name1,MonteCarloTest,L,K,M,~)
epsilon=1e-6;
load('Decision.mat')
decision=double(decision);
load([Name1 '_FVD.mat']) % You can use Ytrain/Ytest here

[~,b]=size(decision);
load('Ytest.mat');   
ErrorPercentage_Original=(MonteCarloTest*b-length(find(decision==Y)))/(MonteCarloTest*b)*100;

errorsM=BCC_v03(decision,L,K);
BCCEP=(length(errorsM)/MonteCarloTest)*100;

sigma2n=1; % Noise

fi1=sprintf([Name1 '_H.log']);     % Pre-saved S-R channels
fi2=sprintf([Name1 '_sP.log']);     % Pre-saved S-R channels
loaders=zeros(2,1);
mM=(0:M-1);
U=(1/sqrt(M))*exp(-(1i*2*pi*(mM'*mM))/M);    % DFT matrix. Normalized so that ||U_l||_F^2=1 per AP
UsAI=zeros(M,L*K);
rate_MCAI=0;
Us=zeros(M,L*K); % Uncomment to evaluate the original sum-rate
rate_MC=0; % Uncomment to evaluate the original sum-rate
rate_MCNew=0;
mcSMaxSize=round(MonteCarloTest/5)+1;
mcS=zeros(mcSMaxSize,1);
mc=1;
counter=1;
while mc<=MonteCarloTest
    H=dlmread(fi1,'\t',[loaders(1) 0 loaders(1)+K*M-1 L-1]);        % Channels between the transmitters and receivers. See \mathbf{J}_{ki} in (2)
    sP=dlmread(fi2,'\t',[loaders(2) 0 loaders(2) L*K-1]);   
    loaders(1)=loaders(1)+K*M;
    loaders(2)=loaders(2)+1;
    indexesAI=decision(mc,:);   
    indexes=Y(mc,:);   % Uncomment to evaluate the original sum-rate
    for l=0:L-1
        UsAI(:,l*K+1:l*K+K)=U(:,indexesAI(l*K+1:l*K+K)+1);
        Us(:,l*K+1:l*K+K)=U(:,indexes(l*K+1:l*K+K)+1); % Uncomment to evaluate the original sum-rate
    end
    %[rate_UAI,~,~]=rate_U_MultiwFilter_v02dt1b(sP,L,K,M,H,UsAI,sigma2n); % Calling the rate_U_Multi function. ZF    
    [rate_UAI,~,~]=rate_U_MultiwFilter_v02dt2c(sP,L,K,M,H,UsAI,sigma2n); % Calling the rate_U_Multi function. MMSE
    

    %[rate_U,~,~]=rate_U_MultiwFilter_v02dt1b(sP,L,K,M,H,Us,sigma2n); % Calling the rate_U_Multi function. ZF
    [rate_U,~,~]=rate_U_MultiwFilter_v02dt2c(sP,L,K,M,H,Us,sigma2n); % Calling the rate_U_Multi function. MMSE
    
          
    if sum(isnan(rate_UAI))~=0 || (sum(rate_UAI)>sum(rate_U) && sum(find(mc==errorsM))~=0) || (abs(sum(rate_UAI)-sum(rate_U))<=epsilon && sum(find(mc==errorsM))~=0)           % Uncomment for BCC          % Uncomment for BCC
        mcS(counter)=mc;           % Uncomment for BCC
        counter=counter+1;           % Uncomment for BCC
    else                             % Uncomment for BCC
        rate_MCAI=rate_MCAI+rate_UAI;
        rate_MCNew=rate_MCNew+rate_U; 
    end                             % Uncomment for BCC
    rate_MC=rate_MC+rate_U; % Uncomment to evaluate the original sum-rate
    mc=mc+1;
end
mcS(counter:end)=[];
counter=counter-1; 
MonteCarloTestNew=MonteCarloTest-counter;
sum_rate_AI=sum(rate_MCAI/MonteCarloTestNew);
sum_rate_Original=sum(rate_MC/MonteCarloTest); % Uncomment to evaluate the original sum-rate
sum_rate_OriginalM=sum(rate_MCNew/MonteCarloTestNew); % Uncomment to evaluate the original sum-rate
Y(mcS,:)=[];                       % Uncomment for BCC
decision(mcS,:)=[];                % Uncomment for BCC

ErrorPercentage_New=(MonteCarloTestNew*b-length(find(decision==Y)))/(MonteCarloTestNew*b)*100;

