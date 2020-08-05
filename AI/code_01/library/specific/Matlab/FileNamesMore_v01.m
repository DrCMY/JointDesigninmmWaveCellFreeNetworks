function [MonteCarlo,MonteCarloTest,L,K,M,PdBTxRx,Init,Iter,GTS,Name1,Name2]=FileNamesMore_v01(datar,selected,iter)
TtTR=3;                          % Training data to test data ratio
x=selected(iter);
MonteCarlo=datar(x,1);           % Training data
MonteCarloTest=MonteCarlo/TtTR;  % Test data
%MonteCarloTest=10000;           % Number of test data is fixed to a number
L=datar(x,2);                    % Number of access points
K=datar(x,3);                    % Number of users
M=datar(x,4);                    % Number of antennas at an access point
PdBTxRx=datar(x,5);              % Transmit power of AP in dBm
Init=datar(x,6);                 % Number of random initializations
Iter=datar(x,7);                 % Number of iterations
GTS=datar(x,8);                  % Number of access point search groups
Name1=sprintf('L%dK%dM%d',L,K,M); % File name extension 
Name2=['T' mat2str(PdBTxRx) '_In' mat2str(Init) '_I' mat2str(Iter) '_G' mat2str(GTS)]; % File name extension 

