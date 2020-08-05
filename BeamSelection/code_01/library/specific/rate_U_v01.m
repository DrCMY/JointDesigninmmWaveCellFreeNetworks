function rate_U=rate_U_v01(sP,L,K,M,H,Us,sigma2n)
rate_U=zeros(K,1);               % Sum of user rates
for k=0:K-1
    num=0;
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
                num=num+sP(l*K+k+1)*H(k*M+1:k*M+M,l+1)'*Us(:,l*K+k+1);
            end
            num=abs(num)^2;
        end
    end
    rate_U(k+1)=log2(1+num/(den+sigma2n));
end