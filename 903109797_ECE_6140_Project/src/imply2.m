function [mat2,DFront,XF,test]=imply2(mat2,mat,fault_val,fault_node,XF,test,pis)
% imply2 function used to calculate evaluation of all the gates due o the primary input
% assignment in the preceding backtrace operation.
% It also updates the D Frontier everytime the function is called.
% 
% License to use and modify this code is granted freely to all interested, as long as the 
% original author is referenced and attributed as such. The original author maintains the 
% right to be solely associated with this work.
% 
% Version: 1.0, 11/27/2015
% Author:  C.V. Chaitanya Krishna
% email:   cvchaitanyak7@gmail.com

DFront=zeros(1,size(mat,1)-2);
mat2=gate_eval(mat,mat2,fault_val,fault_node);%%%GATE EVALUATIONS

%DISPLAYING PRIMARY INPUTS IN MAT2%%
for i1=2:size(mat2,2)
    for j2=2:4
        for j1=1:size(mat,1)-2
            if strcmp(mat(size(mat,1)-1,i1),mat(j1,j2))
                mat2{size(mat,1)-1,i1}=mat2{j1,j2};
            end
        end
    end
end

%DISPLAYING PRIMARY OUTPUTS IN MAT2%%
for i1=2:size(mat2,2)-2
    for j2=3:4
        for j1=1:size(mat,1)-2
            if strcmp(mat(size(mat,1),i1),mat(j1,j2))
                mat2{size(mat,1),i1}=mat2{j1,j2};
                if strcmp(mat2{size(mat,1),i1},'d')||strcmp(mat2{size(mat,1),i1},'d_bar')
                    for k11=2:length(pis)+1                      
                        sss=mat2{size(mat2,1)-1,k11};
                        if strcmp(sss,'d_bar')
                            sss='0';
                        elseif strcmp(sss,'d')
                            sss='1';
                        end
                        test(k11-1)=(sss);
                    end
                end
            end
        end
    end
end

i1=1;
%%%%%%%calculating D Frontier%%%%%%%%%%%
for k1=1:size(mat2,1)-2
    if strcmp(mat2{k1,4},'x')
        if strcmp(mat2{k1,2},'x') && (strcmp(mat2{k1,3},'d')||strcmp(mat2{k1,3},'d_bar'))
            DFront(i1)=k1;
            i1=i1+1;
        elseif strcmp(mat2{k1,3},'x') && (strcmp(mat2{k1,2},'d')||strcmp(mat2{k1,2},'d_bar'))
            DFront(i1)=k1;
            i1=i1+1;
        end
    end
end

XF=DFront;

end
