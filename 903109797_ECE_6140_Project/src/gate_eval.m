function mat2=gate_eval(mat,mat2,fault_val,fault_node)
% gate_eval function is called within the imply function to perform the five valued gate 
% evaluations (i.e. the gate inputs/outputs can be any of the x,d,d_bar,0 or 1) after the
% previous backtrace operation. 
% 
% It uses functions node_update_1_input_gate_imply and node_update_1_input_gate_imply functions
% only if output of gate is computed to evaluate the gates with same input node elsewhere.
% 
% % License to use and modify this code is granted freely to all interested, as long as the 
% original author is referenced and attributed as such. The original author maintains the 
% right to be solely associated with this work.
% 
% Version: 1.0, 11/27/2015
% Author:  C.V. Chaitanya Krishna
% email:   cvchaitanyak7@gmail.com


for m=1:size(mat,1)-2%%%for loop for incrementing row index
    if (strcmp(mat2(m,1),'AND')==1)%%%checking AND gate
        if strcmp(mat2{m,4},'x')%%%%checking if output of gate is not evaluated
            if strcmp(mat2{m,2},'0')%%%checking if 1st input is controlling input
                mat2{m,4}='0';
                if strcmp(mat{m,4},(fault_node))%%%checking if output node is fault site
                    if fault_val==0
                        mat2{m,4}='d_bar';
                    end
                end
            elseif strcmp(mat2{m,2},'1')%%%checking if 1st input is non-controlling input
                if strcmp(mat2{m,3},'d')
                    mat2{m,4}='d';
                elseif strcmp(mat2{m,3},'d_bar')
                    mat2{m,4}='d_bar';
                elseif strcmp(mat2{m,3},'1')
                    mat2{m,4}='1';
                elseif strcmp(mat2{m,3},'0')
                    mat2{m,4}='0';
                end
            elseif strcmp(mat2{m,3},'0')%%%checking if 2nd input is controlling input
                mat2{m,4}='0';
                if strcmp(mat{m,4},(fault_node))%%%checking if output node is fault site
                    if fault_val==0
                        mat2{m,4}='d_bar';
                    end
                end
            elseif strcmp(mat2{m,3},'1')%%%checking if 2nd input is non-controlling input
                if strcmp(mat2{m,2},'d')
                    mat2{m,4}='d';
                elseif strcmp(mat2{m,2},'d_bar')
                    mat2{m,4}='d_bar';
                elseif strcmp(mat2{m,2},'1')
                    mat2{m,4}='1';
                elseif strcmp(mat2{m,2},'0')
                    mat2{m,4}='0';
                end
            elseif strcmp(mat2{m,2},'d')%%%1st input has fault value
                if strcmp(mat2{m,3},'d')%%%2nd input has fault value
                    mat2{m,4}='d';
                elseif strcmp(mat2{m,3},'d_bar')%%%2nd input has fault value
                    mat2{m,4}='0';
                end
            elseif strcmp(mat2{m,3},'d')%%%2nd input has fault value
                if strcmp(mat2{m,2},'d')%%%1st input has fault value
                    mat2{m,4}='d';
                elseif strcmp(mat2{m,2},'d_bar')%%%1st input has fault value
                    mat2{m,4}='0';
                end
            elseif strcmp(mat2{m,2},'d_bar')%%%1st input has fault value
                if strcmp(mat2{m,3},'d_bar')%%%2nd input has fault value
                    mat2{m,4}='d_bar';
                elseif strcmp(mat2{m,3},'d')%%%2nd input has fault value
                    mat2{m,4}='0';
                end
            elseif strcmp(mat2{m,3},'d_bar')%%%2nd input has fault value
                if strcmp(mat2{m,2},'d_bar')%%%1st input has fault value
                    mat2{m,4}='d_bar';
                elseif strcmp(mat2{m,2},'d')%%%1st input has fault value
                    mat2{m,4}='0';
                end
            end
            if strcmp(mat{m,4},(fault_node))%%%output node is fault node
                if strcmp(mat2{m,2},'1') && strcmp(mat2{m,3},'1')%%%inputs are already assigned
                    if fault_val==1
                        mat2{m,4}='d';
                    end
                end
            end
            %%%%NODE UPDATE%%%%
            if strcmp(mat2{m,4},'x')==0
                mat2=node_update_2_input_gate_imply(mat,mat2,m,fault_val,fault_node);
            end
        end
    elseif (strcmp(mat2(m,1),'OR')==1)%%%checking OR gate
        if strcmp(mat2{m,4},'x')%%%%checking if output of gate is not evaluated
            if strcmp(mat2{m,2},'1')%%%checking if 1st input is controlling input
                mat2{m,4}='1';
                if strcmp(mat{m,4},(fault_node))%%%checking if output node is fault site
                    if fault_val==1
                        mat2{m,4}='d';
                    end
                end
            elseif strcmp(mat2{m,2},'0')%%%checking if 1st input is non-controlling input
                if strcmp(mat2{m,3},'d')
                    mat2{m,4}='d';
                elseif strcmp(mat2{m,3},'d_bar')
                    mat2{m,4}='d_bar';
                elseif strcmp(mat2{m,3},'1')
                    mat2{m,4}='1';
                elseif strcmp(mat2{m,3},'0')
                    mat2{m,4}='0';
                end
            elseif strcmp(mat2{m,3},'1')%%%checking if 2nd input is controlling input
                mat2{m,4}='1';
                if strcmp(mat{m,4},(fault_node))%%%checking if output node is fault site
                    if fault_val==1
                        mat2{m,4}='d';
                    end
                end
            elseif strcmp(mat2{m,3},'0')%%%checking if 2nd input is non-controlling input
                if strcmp(mat2{m,2},'d')
                    mat2{m,4}='d';
                elseif strcmp(mat2{m,2},'d_bar')
                    mat2{m,4}='d_bar';
                elseif strcmp(mat2{m,2},'1')
                    mat2{m,4}='1';
                elseif strcmp(mat2{m,2},'0')
                    mat2{m,4}='0';
                end
            elseif strcmp(mat2{m,2},'d')%%%1st input has fault value
                if strcmp(mat2{m,3},'d')%%%2nd input has fault value
                    mat2{m,4}='d';
                elseif strcmp(mat2{m,3},'d_bar')%%%2nd input has fault value
                    mat2{m,4}='1';
                end
            elseif strcmp(mat2{m,3},'d')%%%2nd input has fault value
                if strcmp(mat2{m,2},'d')%%%1st input has fault value
                    mat2{m,4}='d';
                elseif strcmp(mat2{m,2},'d_bar')%%%1st input has fault value
                    mat2{m,4}='1';
                end
            elseif strcmp(mat2{m,2},'d_bar')%%%1st input has fault value
                if strcmp(mat2{m,3},'d_bar')%%%2nd input has fault value
                    mat2{m,4}='d_bar';
                elseif strcmp(mat2{m,3},'d')%%%2nd input has fault value
                    mat2{m,4}='1';
                end
            elseif strcmp(mat2{m,3},'d_bar')%%%2nd input has fault value
                if strcmp(mat2{m,2},'d_bar')%%%1st input has fault value
                    mat2{m,4}='d_bar';
                elseif strcmp(mat2{m,2},'d')%%%1st input has fault value
                    mat2{m,4}='1';
                end
            end
            if strcmp(mat{m,4},(fault_node))%%%output node is fault node
                if strcmp(mat2{m,2},'0') && strcmp(mat2{m,3},'0')%%%inputs are already assigned
                    if fault_val==0
                        mat2{m,4}='d_bar';
                    end
                end
            end
            %%%%NODE UPDATE%%%%
            if strcmp(mat2{m,4},'x')==0
                mat2=node_update_2_input_gate_imply(mat,mat2,m,fault_val,fault_node);
            end
        end
    elseif (strcmp(mat2(m,1),'INV')==1)%%%checking NOT gate
        if strcmp(mat2{m,3},'x')%%%checking if output is already evaluated
            if strcmp(mat{m,3},(fault_node))
                if strcmp(mat2{m,2},'x')~=1
                    if fault_val==1
                        mat2{m,3}='d';
                    elseif fault_val==0
                        mat2{m,3}='d_bar';
                    end
                end
            elseif strcmp(mat2{m,2},'0')
                mat2{m,3}='1';
            elseif strcmp(mat2{m,2},'1')
                mat2{m,3}='0';
            elseif strcmp(mat2{m,2},'d')
                mat2{m,3}='d_bar';
            elseif strcmp(mat2{m,2},'d_bar')
                mat2{m,3}='d';
            end
            %%%%NODE UPDATE%%%%
            if strcmp(mat2{m,3},'x')==0
                mat2=node_update_1_input_gate_imply(mat,mat2,m,fault_val,fault_node);
            end
            %%%%
        end%%%end of if statement to check output
    elseif (strcmp(mat2(m,1),'NAND')==1)%%%checking NAND gate
        if strcmp(mat2{m,4},'x')%%%%checking if output of gate is not evaluated
            if strcmp(mat2{m,2},'0')%%%checking if 1st input is controlling input
                mat2{m,4}='1';
                if strcmp(mat{m,4},(fault_node))%%%checking if output node is fault site
                    if fault_val==1
                        mat2{m,4}='d';
                    end
                end
            elseif strcmp(mat2{m,2},'1')%%%checking if 1st input is non-controlling input
                if strcmp(mat2{m,3},'d')
                    mat2{m,4}='d_bar';
                elseif strcmp(mat2{m,3},'d_bar')
                    mat2{m,4}='d';
                elseif strcmp(mat2{m,3},'1')
                    mat2{m,4}='0';
                elseif strcmp(mat2{m,3},'0')
                    mat2{m,4}='1';
                end
            elseif strcmp(mat2{m,3},'0')%%%checking if 2nd input is controlling input
                mat2{m,4}='1';
                if strcmp(mat{m,4},(fault_node))%%%checking if output node is fault site
                    if fault_val==1
                        mat2{m,4}='d';
                    end
                end
            elseif strcmp(mat2{m,3},'1')%%%checking if 2nd input is non-controlling input
                if strcmp(mat2{m,2},'d')
                    mat2{m,4}='d_bar';
                elseif strcmp(mat2{m,2},'d_bar')
                    mat2{m,4}='d';
                elseif strcmp(mat2{m,2},'1')
                    mat2{m,4}='0';
                elseif strcmp(mat2{m,2},'0')
                    mat2{m,4}='1';
                end
            elseif strcmp(mat2{m,2},'d')%%%1st input has fault value
                if strcmp(mat2{m,3},'d')%%%2nd input has fault value
                    mat2{m,4}='d_bar';
                elseif strcmp(mat2{m,3},'d_bar')%%%2nd input has fault value
                    mat2{m,4}='1';
                end
            elseif strcmp(mat2{m,3},'d')%%%2nd input has fault value
                if strcmp(mat2{m,2},'d')%%%1st input has fault value
                    mat2{m,4}='d_bar';
                elseif strcmp(mat2{m,2},'d_bar')%%%1st input has fault value
                    mat2{m,4}='1';
                end
            elseif strcmp(mat2{m,2},'d_bar')%%%1st input has fault value
                if strcmp(mat2{m,3},'d_bar')%%%2nd input has fault value
                    mat2{m,4}='d';
                elseif strcmp(mat2{m,3},'d')%%%2nd input has fault value
                    mat2{m,4}='1';
                end
            elseif strcmp(mat2{m,3},'d_bar')%%%2nd input has fault value
                if strcmp(mat2{m,2},'d_bar')%%%1st input has fault value
                    mat2{m,4}='d';
                elseif strcmp(mat2{m,2},'d')%%%1st input has fault value
                    mat2{m,4}='1';
                end
            end
            if strcmp(mat{m,4},(fault_node))%%%output node is fault node
                if strcmp(mat2{m,2},'1') && strcmp(mat2{m,3},'1')%%%inputs are already assigned
                    if fault_val==0
                        mat2{m,4}='d_bar';
                    end
                end
            end
            %%%%NODE UPDATE%%%%
            if strcmp(mat2{m,4},'x')==0
                mat2=node_update_2_input_gate_imply(mat,mat2,m,fault_val,fault_node);
            end
        end
    elseif (strcmp(mat2(m,1),'NOR')==1)%%%checking NOR gate
        if strcmp(mat2{m,4},'x')%%%%checking if output of gate is not evaluated
            if strcmp(mat2{m,2},'1')%%%checking if 1st input is controlling input
                mat2{m,4}='0';
                if strcmp(mat{m,4},(fault_node))%%%checking if output node is fault site
                    if fault_val==0
                        mat2{m,4}='d_bar';
                    end
                end
            elseif strcmp(mat2{m,2},'0')%%%checking if 1st input is non-controlling input
                if strcmp(mat2{m,3},'d')
                    mat2{m,4}='d_bar';
                elseif strcmp(mat2{m,3},'d_bar')
                    mat2{m,4}='d';
                elseif strcmp(mat2{m,3},'1')
                    mat2{m,4}='0';
                elseif strcmp(mat2{m,3},'0')
                    mat2{m,4}='1';
                end
            elseif strcmp(mat2{m,3},'1')%%%checking if 2nd input is controlling input
                mat2{m,4}='0';
                if strcmp(mat{m,4},(fault_node))%%%checking if output node is fault site
                    if fault_val==0
                        mat2{m,4}='d_bar';
                    end
                end
            elseif strcmp(mat2{m,3},'0')%%%checking if 2nd input is non-controlling input
                if strcmp(mat2{m,2},'d')
                    mat2{m,4}='d_bar';
                elseif strcmp(mat2{m,2},'d_bar')
                    mat2{m,4}='d';
                elseif strcmp(mat2{m,2},'1')
                    mat2{m,4}='0';
                elseif strcmp(mat2{m,2},'0')
                    mat2{m,4}='1';
                end
            elseif strcmp(mat2{m,2},'d')%%%1st input has fault value
                if strcmp(mat2{m,3},'d')%%%2nd input has fault value
                    mat2{m,4}='d_bar';
                elseif strcmp(mat2{m,3},'d_bar')%%%2nd input has fault value
                    mat2{m,4}='0';
                end
            elseif strcmp(mat2{m,3},'d')%%%2nd input has fault value
                if strcmp(mat2{m,2},'d')%%%1st input has fault value
                    mat2{m,4}='d_bar';
                elseif strcmp(mat2{m,2},'d_bar')%%%1st input has fault value
                    mat2{m,4}='0';
                end
            elseif strcmp(mat2{m,2},'d_bar')%%%1st input has fault value
                if strcmp(mat2{m,3},'d_bar')%%%2nd input has fault value
                    mat2{m,4}='d';
                elseif strcmp(mat2{m,3},'d')%%%2nd input has fault value
                    mat2{m,4}='0';
                end
            elseif strcmp(mat2{m,3},'d_bar')%%%2nd input has fault value
                if strcmp(mat2{m,2},'d_bar')%%%1st input has fault value
                    mat2{m,4}='d';
                elseif strcmp(mat2{m,2},'d')%%%1st input has fault value
                    mat2{m,4}='0';
                end
            end
            if strcmp(mat{m,4},(fault_node))%%%output node is fault node
                if strcmp(mat2{m,2},'0') && strcmp(mat2{m,3},'0')%%%%%%%strcmp(mat2{m,2},'x')~=1 && strcmp(mat2{m,3},'x')~=1%%%inputs are already assigned
                    if fault_val==1
                        mat2{m,4}='d';
                    end
                end
            end
            %%%%NODE UPDATE%%%%
            if strcmp(mat2{m,4},'x')==0
                mat2=node_update_2_input_gate_imply(mat,mat2,m,fault_val,fault_node);
            end
        end
    elseif (strcmp(mat2(m,1),'BUF')==1)%%%checking BUFFER
        if strcmp(mat2{m,3},'x')%%%checking if output is already evaluated
            if strcmp(mat{m,3},(fault_node))%%%checking if output is fault site
                if strcmp(mat2{m,2},'x')~=1%%%input is already evaluated
                    if fault_val==1
                        mat2{m,3}='d';
                    elseif fault_val==0
                        mat2{m,3}='d_bar';
                    end
                end
            elseif strcmp(mat2{m,3},'x')%%%checking if output is already evaluated
                mat2{m,3}=(mat2{m,2});%%%evaluating output
            end
            %%%%NODE UPDATE%%%%
            if strcmp(mat2{m,3},'x')==0
                mat2=node_update_1_input_gate_imply(mat,mat2,m,fault_val,fault_node);
            end
            
        end
    end
end

end