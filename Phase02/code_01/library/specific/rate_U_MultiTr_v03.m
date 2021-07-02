function rate_U=rate_U_MultiTr_v03(sP,L,K,M,H,Us,sigma2n)
rate_U=zeros(K,L);               % sum of individual user rates per channel use
for k=0:K-1    
    den=0;
    for j=0:K-1
        denx=0;
        if j~=k
            for l=0:L-1
                denx=denx+sP(l*K+j+1)*H(k*M+1:k*M+M,l+1)'*Us(:,l*K+j+1);
            end
            den=den+abs(denx)^2;
        else
            for l=0:L-1
                rate_U(k+1,l+1)=abs(sP(l*K+k+1)*H(k*M+1:k*M+M,l+1)'*Us(:,l*K+k+1))^2;
            end            
        end
    end
    rate_U(k+1,:)=log2(1+rate_U(k+1,:)/(den+sigma2n));
end