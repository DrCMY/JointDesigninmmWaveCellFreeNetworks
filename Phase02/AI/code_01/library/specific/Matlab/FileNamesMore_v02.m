function [MonteCarlo,MonteCarloTest,L,K,M,PdBTxRx,Init,Iter,GTS,Name1,Name2]=FileNamesMore_v02(datar,selected,iter)
TtTR=3;                          % Training data to test data ratio
x=selected(iter);
MonteCarlo=datar(x,1);           % Training data
MonteCarloTest=MonteCarlo/TtTR;  % Test data
%MonteCarloTest=10000;             % Number of test data is fixed to a number
L=datar(x,2);
K=datar(x,3);
M=datar(x,4);
PdBTxRx=datar(x,5);
Init=datar(x,6);
Iter=datar(x,7);
GTS=datar(x,8);
Name1=sprintf('L%dK%dM%d',L,K,M); 
Name2=['T' mat2str(PdBTxRx) '_In' mat2str(Init) '_I' mat2str(Iter) '_G' mat2str(GTS)];

