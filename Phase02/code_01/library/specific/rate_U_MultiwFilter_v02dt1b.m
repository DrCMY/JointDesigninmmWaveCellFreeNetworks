%function rate_U=rate_U_MultiwFilter_v02d(sP,L,K,M,H,Us,sigma2n)
%function [rate_U,ei]=rate_U_MultiwFilter_v02d(sP,L,K,M,H,Us,sigma2n)
function [rate_U,rn,cn]=rate_U_MultiwFilter_v02dt1b(sP,L,K,M,H,Us,sigma2n)
epsilon=1e-6;
rate_U=zeros(K,1);               % sum of individual user rates per channel use
V=zeros(K,L*K);                      % digital precoder
Heff=zeros(K);
rn=zeros(1,L);
cn=zeros(1,L);
for l=0:L-1
    Usx=Us(:,l*K+1:l*K+K);
    for k=0:K-1
        Heff(k+1,:)=H(k*M+1:k*M+M,l+1)'*Usx;
    end
    HeffH=Heff';
    %V(:,l*K+1:l*K+K)=HeffH/(HeffH*Heff);  % This is wrong
    V(:,l*K+1:l*K+K)=HeffH/(Heff*HeffH); % This is wright
    xx=eig(Heff*HeffH);
%     %test
%     if sum(xx<1e-6)~=0
%         yyy=1;
%     end
    %ei(l+1)=sum(xx);
    rn(l+1)=K-sum(find(xx<=epsilon));
    a=find(sign(xx)==-1);    % replacing - eigen values with epsilon
    xx(a)=epsilon*ones(length(a),1);        
    cn(l+1)=max(xx)/min(xx);
    
%      %   test
%     if isinf(cn(l+1))
%         yyy=1;
%     end
    
%     % With the right version above, you may not need this if check. Control it and erase if not
%     % necessary
%     if sum(sum(abs(V(:,l*K+1:l*K+K))==Inf)) || sum(sum(abs(V(:,l*K+1:l*K+K))==0))
%         for k=0:K-1
%             Heff(k+1,:)=H(k*M+1:k*M+M,l+1)'*Usx(:,k+1);
%             V(:,l*K+k+1)=Heff(k+1,:)';
%             cc=1
%         end 
%     end       
    
    for k=0:K-1
        %V(:,l*K+k+1)=V(:,l*K+k+1)/norm(V(:,l*K+k+1))*sqrt(K);   % Normalized power (equal power allocation)
        %V(:,l*K+k+1)=V(:,l*K+k+1)/norm(V(:,l*K+k+1));   % Normalized power (equal power allocation) - My approach. Although this approach gives V with higher power, sum-rate is lower. Probably, unnecessary power is causing interference
        V(:,l*K+k+1)=V(:,l*K+k+1)/norm(Usx*V(:,l*K+k+1),'fro');   % Normalized power (equal power allocation) due to beam conflict. See BeamSelection_v02.docx, BeamTrainingandAllocation...pdf
        %norm(Usx*Vx(:,l*K+1),'fro')^2       % Must be equal to 1                  
%         xx=round(norm(Usx*V(:,l*K+1),'fro')^2);    % Must be equal to 1                    
%         if xx~=1       
%             xx
%         end
    end
    %norm(Usx*Vx(:,l*K+1:l*K+K),'fro')^2 % Must be equal to K
    %yy=round(norm(Usx*V(:,l*K+1:l*K+K),'fro')^2); % Must be equal to K    
%     if yy~=K 
%         yy
%     end
end

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