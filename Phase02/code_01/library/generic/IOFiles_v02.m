function [fi1,fi2,fi3,fido1,Name]=IOFiles_v02(Name1,Name2,cverSubFile_b)
% Input files


fi1=sprintf([Name1 '_H.log']);     % Pre-saved S-R channels
fi2=sprintf([Name1 '_Us.log']);     % Pre-saved codeword initializations
fi3=sprintf([Name1 '_sP.log']);     % Pre-saved codeword initializations
Name=[Name1 '_' Name2 ];


fo1=sprintf([Name '_Rate_' cverSubFile_b '.log']);      % Logging some details for each Monte Carlo run
fido1 = fopen(fo1,'w');


