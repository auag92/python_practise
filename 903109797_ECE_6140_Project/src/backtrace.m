function [mat2,count,fp,v]=backtrace(mat,mat2,fp,v,output_nodes,in,pis,fault_node,fault_val,count)
% backtrace function is essntially used to assign values to the primary inputs of the circuit
% under test to justify the objective set before calling backtrace function.
% 
% License to use and modify this code is granted freely to all interested, as long as the 
% original author is referenced and attributed as such. The original author maintains the 
% right to be solely associated with this work.
% 
% Version: 1.0, 11/26/2015
% Author:  C.V. Chaitanya Krishna
% email:   cvchaitanyak7@gmail.com


%%%%%%%%setting PIs as d or d_bar if the fault is at PIs%%%%%%%
if strcmp(fp,fault_node)
    if any(str2num(fp)==pis)
        for j2=1:size(mat,1)-2
            for j1=2:3
                if strcmp(mat{j2,j1},(fault_node))
                    count=count+1;
                    if fault_val==1
                        mat2{j2,j1}='d';
                        sprintf('Backtrace: Set node %s to %d',mat{j2,j1},1)
                    elseif fault_val==0
                        mat2{j2,j1}='d_bar';
                        sprintf('Backtrace: Set node %s to %d',mat{j2,j1},0)
                    end
                end
            end
        end
        return
    end
end

%%%%%%%%setting PIs as d or d_bar if the fault is not at PIs%%%%%%%
while any(str2num(fp)==output_nodes)
    for j2=1:size(mat,1)-2
        if strcmp(mat{j2,1},'INV')||strcmp(mat{j2,1},'BUF')
            if strcmp(mat{j2,3},(fp))
                in(j2);
                v=xor(in(j2),v);
                fp=mat{j2,2};
            end
        else
            if strcmp(mat{j2,4},(fp))
                v=xor(in(j2),v);
                if strcmp(mat2{j2,2},'x')
                    fp=mat{j2,2};
                else
                    fp=mat{j2,3};
                end
                
            end
        end
    end
end
sprintf('Backtrace: Set node %s to %d',fp,v)

%%%%%node update%%%%%
for j2=1:size(mat,1)-2
    for j1=2:3
        if strcmp(mat{j2,j1},(fp))
            mat2{j2,j1}=num2str(v);
        end
    end
end

end