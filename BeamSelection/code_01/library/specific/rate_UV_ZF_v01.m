function [rate_U,rn,cn]=rate_UV_ZF_v01(sP,L,K,M,H,Us,sigma2n)
epsilon=1e-6;
rate_U=zeros(K,1);               % Rates of users
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
    V(:,l*K+1:l*K+K)=HeffH/(Heff*HeffH);         % ZF filter
    xx=eig(Heff*HeffH);
    rn(l+1)=K-sum(find(xx<=epsilon));
    a=find(sign(xx)==-1);        % Replacing negative eigen values with epsilon
    xx(a)=epsilon*ones(length(a),1);        
    cn(l+1)=max(xx)/min(xx);       
    for k=0:K-1
        V(:,l*K+k+1)=V(:,l*K+k+1)/norm(Usx*V(:,l*K+k+1),'fro');   % Power normalization
    end    
end

% Evaluation of rate
for k=0:K-1
    num=0;
    den=0;
    for j=0:K-1
        denx=0;
        if j~=k
            for l=0:L-1
                Heff=H(k*M+1:k*M+M,l+1)'*Us(:,l*K+1:l*K+K);
                denx=denx+sP(l*K+j+1)*(Heff*V(:,l*K+j+1));
            end
            den=den+abs(denx)^2;
        else
            for l=0:L-1
                Heff=H(k*M+1:k*M+M,l+1)'*Us(:,l*K+1:l*K+K);
                num=num+sP(l*K+k+1)*(Heff*V(:,l*K+k+1));
            end
            num=abs(num)^2;
        end
    end
    rate_U(k+1)=log2(1+num/(den+sigma2n));
end