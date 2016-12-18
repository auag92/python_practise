function mat2=node_update_2_input_gate_imply(mat,mat2,m,fault_val,fault_node)


for j2=1:size(mat,1)-2
    for j1=2:3
        if strcmp(mat(m,4),mat(j2,j1))==1
            mat2{j2,j1}= (mat2{m,4});
        end
    end
end

mat2=gate_eval(mat,mat2,fault_val,fault_node);

end