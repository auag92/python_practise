function in=inversion_parity(mat2,in)
% inversion_parity function is used to calculate the inversion parity of all the gates in
% any given logic circuit.
% 
% License to use and modify this code is granted freely to all interested, as long as the 
% original author is referenced and attributed as such. The original author maintains the 
% right to be solely associated with this work.
% 
% Version: 1.0, 11/25/2015
% Author:  C.V. Chaitanya Krishna
% email:   cvchaitanyak7@gmail.com


for j1=1:size(mat2,1)-2
    if strcmp(mat2{j1,1},'AND')||strcmp(mat2{j1,1},'OR')||strcmp(mat2{j1,1},'BUF')
        in(j1)=0;
    elseif strcmp(mat2{j1,1},'NAND')||strcmp(mat2{j1,1},'NOR')||strcmp(mat2{j1,1},'INV')
        in(j1)=1;
    end
end
end


