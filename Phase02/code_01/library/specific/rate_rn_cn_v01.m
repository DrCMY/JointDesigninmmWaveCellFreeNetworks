function [rate_MC,rn_MC,cn_MC]=rate_rn_cn_v01(rate_MC,rate_U,rn_MC,rn,cn_MC,cn)
rate_MC=rate_MC+rate_U;
rn_MC=rn_MC+rn;
icn=isinf(cn);
if sum(icn)
    [~,loc]=find(icn==1);
    cn(loc)=0;
end
cn_MC=cn_MC+cn;