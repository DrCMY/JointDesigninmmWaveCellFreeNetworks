function [fi1,fi2,fi3,fido1,Name]=IOFiles_v01(Name1,Name2,cverSubFile_b)
% Input files
fi1=sprintf([Name1 '_H.log']);        % Channel variables   
fi2=sprintf([Name1 '_Us.log']);       % Beam index variables
fi3=sprintf([Name1 '_sP.log']);       % Power variables
Name=[Name1 '_' Name2 ];


fo1=sprintf([Name '_Rate_' cverSubFile_b '.log']);      
fido1 = fopen(fo1,'w');


