function c=controlling_vals(mat2,c)
% controlling_vals function is used to calculate the contolling inputs of the gates in any
% given circuit
% 
% License to use and modify this code is granted freely to all interested, as long as the 
% original author is referenced and attributed as such. The original author maintains the 
% right to be solely associated with this work.
% 
% Version: 1.0, 11/25/2015
% Author:  C.V. Chaitanya Krishna
% email:   cvchaitanyak7@gmail.com

for j1=1:size(mat2,1)-2
    if strcmp(mat2{j1,1},'AND')||strcmp(mat2{j1,1},'NAND')
        c(j1)=0;
    elseif strcmp(mat2{j1,1},'OR')||strcmp(mat2{j1,1},'NOR')
        c(j1)=1;
    end
end
end