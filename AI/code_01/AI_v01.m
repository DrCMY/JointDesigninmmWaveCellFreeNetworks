function [ErrorPercentage_Original,ErrorPercentage_New,sum_rate_AI,sum_rate_Original,sum_rate_OriginalM,counter,BCCEP]=AI_v01(Name1,MonteCarloTest,L,K,M,~)
epsilon=1e-6;
load('Decision.mat')
decision=double(decision);
load([Name1 '_FVD.mat'])   

[~,b]=size(decision);
load('Ytest.mat');   
ErrorPercentage_Original=(MonteCarloTest*b-length(find(decision==Y)))/(MonteCarloTest*b)*100;

errorsM=BCC_v01(decision,L,K);
BCCEP=(length(errorsM)/MonteCarloTest)*100;   % Evaluation of beam conflict control error rate

sigma2n=1;                                    % Noise

fi1=sprintf([Name1 '_H.log']);                % Channel file
fi2=sprintf([Name1 '_sP.log']);               % Power file
loaders=zeros(2,1);
mM=(0:M-1);
U=(1/sqrt(M))*exp(-(1i*2*pi*(mM'*mM))/M);    % DFT matrix
UsAI=zeros(M,L*K);                           % Analog beam precoders from ML algorithms
rate_MCAI=0;                                 % Rate result of ML algorithms
Us=zeros(M,L*K);                             % Analog beam precoders from joint design algorithms
rate_MC=0;                                   % Rate result of joint design algorithms
rate_MCNew=0;                                % New rate result after removing bad cases
mcSMaxSize=round(MonteCarloTest/5)+1;
mcS=zeros(mcSMaxSize,1);
mc=1;
counter=1;
while mc<=MonteCarloTest
    H=dlmread(fi1,'\t',[loaders(1) 0 loaders(1)+K*M-1 L-1]);        % Channel variables 
    sP=dlmread(fi2,'\t',[loaders(2) 0 loaders(2) L*K-1]);           % Power variables 
    loaders(1)=loaders(1)+K*M;
    loaders(2)=loaders(2)+1;
    indexesAI=decision(mc,:);                                       % Beam indexes from ML algorithms
    indexes=Y(mc,:);                                                % Beam indexes from joint design algorithms
    for l=0:L-1
        UsAI(:,l*K+1:l*K+K)=U(:,indexesAI(l*K+1:l*K+K)+1);
        Us(:,l*K+1:l*K+K)=U(:,indexes(l*K+1:l*K+K)+1); 
    end
    [rate_UAI,~,~]=rate_UV_ZF_v01(sP,L,K,M,H,UsAI,sigma2n);    % ZF    % Evaluation of rate based on ML algorithms - ZF digital precoder is used
    %[rate_UAI,~,~]=rate_UV_MMSE_v01(sP,L,K,M,H,UsAI,sigma2n); % MMSE  % Evaluation of rate based on ML algorithms - MMSE digital precoder is used
    

    [rate_U,~,~]=rate_UV_ZF_v01(sP,L,K,M,H,Us,sigma2n);        % ZF    % Evaluation of rate based on joint design algorithms - ZF digital precoder is used
    %[rate_U,~,~]=rate_UV_MMSE_v01(sP,L,K,M,H,Us,sigma2n);     % MMSE  % Evaluation of rate based on joint design algorithms - MMSE digital precoder is used
              
    if sum(isnan(rate_UAI))~=0 || (sum(rate_UAI)>sum(rate_U) && sum(find(mc==errorsM))~=0) || (abs(sum(rate_UAI)-sum(rate_U))<=epsilon && sum(find(mc==errorsM))~=0)           
        % Bad cases
        mcS(counter)=mc;           
        counter=counter+1;         
    else           
        % Good cases
        rate_MCAI=rate_MCAI+rate_UAI;
        rate_MCNew=rate_MCNew+rate_U;  
    end                            
    rate_MC=rate_MC+rate_U; 
    mc=mc+1;
end
mcS(counter:end)=[];
counter=counter-1; 
MonteCarloTestNew=MonteCarloTest-counter;
sum_rate_AI=sum(rate_MCAI/MonteCarloTestNew);
sum_rate_Original=sum(rate_MC/MonteCarloTest); 
sum_rate_OriginalM=sum(rate_MCNew/MonteCarloTestNew); 
Y(mcS,:)=[];                       
decision(mcS,:)=[];                

ErrorPercentage_New=(MonteCarloTestNew*b-length(find(decision==Y)))/(MonteCarloTestNew*b)*100;

