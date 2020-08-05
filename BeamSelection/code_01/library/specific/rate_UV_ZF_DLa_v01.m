function [rate_U,rn,cn]=rate_UV_ZF_DLa_v01(sP,l,K,M,H,Us,~)
epsilon=1e-6;
rate_U=zeros(K,1);               % Direct link powers from AP l to each user
Heff=zeros(K);                   % Effective channels of users 
Usx=Us(:,l*K+1:l*K+K);
for k=0:K-1
    Heff(k+1,:)=H(k*M+1:k*M+M,l+1)'*Usx;
end
HeffH=Heff';
V=HeffH/(Heff*HeffH);            % ZF filter
xx=eig(Heff*HeffH);
rn=K-sum(find(xx<=epsilon));
a=find(sign(xx)==-1);           % Replacing negative eigen values with epsilon
xx(a)=epsilon*ones(length(a),1);
cn=max(xx)/min(xx);
for k=0:K-1
    V(:,k+1)=V(:,k+1)/norm(Usx*V(:,k+1),'fro');   % Power normalization
end

% Evaluation of direct link powers
for k=0:K-1
    Heff=H(k*M+1:k*M+M,l+1)'*Usx;
    num=sP(l*K+k+1)*(Heff*V(:,k+1));
    num=abs(num)^2;
    rate_U(k+1)=num;
end

% Consider the algorithms Linear-Disjoint-DL-BCC (BI_v01.m) and Linear-Joint-Init-Iter-DL-BCC
% (CI_v01.m). For the former, the selection metric in (8) on the paper can be directly applied since
% the former has a disjoint design. For the latter, while there can be other options, we choose to
% use the sum of users' direct link powers, i.e., the sum(rate_U) between the lines 20-25. This detail is omitted in the
% paper since these algorithms are proposed as benchmarks.