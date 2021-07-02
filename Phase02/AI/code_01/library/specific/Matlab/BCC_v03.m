function errorsM=BCC_v03(decision,L,K)
%L=4; K=4;
[MonteCarlo,~]=size(decision);
errorsM=zeros(1,MonteCarlo);
counter=1;
for mc=1:MonteCarlo
    decisionx=reshape(decision(mc,:),[K,L])';
    k=1;
    j=1;
    while k<=K
        while j<=K
            if j~=k
                x=intersect(decisionx(:,k),decisionx(:,j));
                if ~isempty(x)
                    errorsM(counter)=mc;
                    k=K+1;
                    counter=counter+1;
                    break
                end
            end
            j=j+1;
        end
        k=k+1;
    end
end
errorsM(counter:end)=[];