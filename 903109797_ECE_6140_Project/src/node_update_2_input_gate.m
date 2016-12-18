function mat2=node_update_2_input_gate(mat,mat2,m)


for j2=1:size(mat,1)-2
    for j1=2:3
        if strcmp(mat(m,4),mat(j2,j1))==1
            mat2{j2,j1}= (mat2{m,4});
        end
    end
end

end