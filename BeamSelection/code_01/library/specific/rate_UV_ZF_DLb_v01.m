function [rate_U,rn,cn]=rate_UV_ZF_DLb_v01(sP,L,K,M,H,Us,~)
epsilon=1e-6;
rate_U=zeros(K,1);               % Power of sum of received signals from all APs to each user
V=zeros(K,L*K);                  % Digital precoder
Heff=zeros(K);                   % Effective channels of users 
rn=zeros(1,L);
cn=zeros(1,L);
for l=0:L-1
    Usx=Us(:,l*K+1:l*K+K);
    for k=0:K-1
        Heff(k+1,:)=H(k*M+1:k*M+M,l+1)'*Usx;
    end
    HeffH=Heff';
    V(:,l*K+1:l*K+K)=HeffH/(Heff*HeffH);    % ZF filter
    xx=eig(Heff*HeffH);
    rn(l+1)=K-sum(find(xx<=epsilon));
    a=find(sign(xx)==-1);       % Replacing negative eigen values with epsilon
    xx(a)=epsilon*ones(length(a),1);        
    cn(l+1)=max(xx)/min(xx);      
    for k=0:K-1
        V(:,l*K+k+1)=V(:,l*K+k+1)/norm(Usx*V(:,l*K+k+1),'fro');   % Power normalization
    end
end

% Evaluation of selection metric
for k=0:K-1
    num=0;    
    for l=0:L-1
        Heff=H(k*M+1:k*M+M,l+1)'*Us(:,l*K+1:l*K+K);
        num=num+sP(l*K+k+1)*(Heff*V(:,l*K+k+1));
    end
    num=abs(num)^2;    
    rate_U(k+1)=num;
end

% Similar to the note in rate_UV_ZF_DLa_v01.m, as seen above between the lines 25-33, the selection
% metric on which one of the initializations should be chosen is evaluated as the sum of (power of (sum of received signals from all APs to
% user k))). Note that there are other options available as selection metrics. Again, this detail is omitted in the
% paper since this algorithm is proposed as a benchmark.