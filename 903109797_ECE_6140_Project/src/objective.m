function [mat2,fp,v]=objective(mat,mat2,fault_node,fault_val,DFront,c,v,fp)
% The main job of objective function is to assign appropriate value to sensitize the fault, 
% and from there on to assign appropriate values to other inputs of gate to propagate the 
% sensitized fault to the output.
% 
% License to use and modify this code is granted freely to all interested, as long as the 
% original author is referenced and attributed as such. The original author maintains the 
% right to be solely associated with this work.
% 
% Version: 1.0, 11/25/2015
% Author:  C.V. Chaitanya Krishna
% email:   cvchaitanyak7@gmail.com

for j2=1:size(mat,1)-2
    for j1=2:4
        if strcmp(mat{j2,j1},fault_node)
            if strcmp(mat2{j2,j1},'x')
                fp=fault_node;
                v=fault_val;
                sprintf('Objective: Set node %s to %d',fp,v)
                return
            end
        end
    end
end

if strcmp(mat2{DFront(1),2},'x')
    fp=mat{DFront(1),2};
    v=~c(DFront(1));
elseif strcmp(mat2{DFront(1),3},'x')
    fp=mat{DFront(1),3};
    v=~c(DFront(1));
end

sprintf('Objective: Set node %s to %d',fp,v)

end
