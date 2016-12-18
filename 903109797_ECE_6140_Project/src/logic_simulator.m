% Logic Simulator calculates the output of any given circuit consisting of 
% two input logic gates with any given input vectors.
%
% Working:
%     The logic simulator first reads the input netlist file and estimates the maximum
%     number of columns required for the matrix to store the netlist file.
%     Then it reads the input vector file containing all the input vectors to be tested   
%     in a similar way
%
%     NOTE: For correct operation select the matching/appropriate input files to be read.      
%
%     After computing output of an gate, that node vaule is matched to all the same node
%     numbers using functions "node_update_2_input_gate" and "node_update_1_input_gate"
%     depending on the gate being evaluated.
%
%     When all the gates are evaluated, the output is displayed in OUT matrix.
%
% License to use and modify this code is granted freely to all interested, as long as the 
% original author is referenced and attributed as such. The original author maintains the 
% right to be solely associated with this work.
% 
% Version: 1.0, 09/25/2015
% Author:  C.V. Chaitanya Krishna
% email:   cvchaitanyak7@gmail.com
    
clc
tic
%%%%%%%%%%SCANNING INPUT FILE%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen('s27.txt','rt'); %for 1st circuit
% fid = fopen('s298f_2.txt','rt'); %for 2nd circuit
% fid = fopen('s344f_2.txt','rt'); %for 3rd circuit
% % fid = fopen('s349f_2.txt','rt'); %for 4th circuit
C = textscan(fid,'%s');
fclose(fid);
%calculating length of output row of netlist file

for j1=1:size(C{:},1)
    if strcmp(C{1}{j1},'OUTPUT')
        j2=j1;
        for i1=j1:size(C{:},1)
            if strcmp(C{1}{i1},'-1')
                break;
            end
        end
    end
end

out_length=i1-j2+1;
%calculating length of input row of netlist file
for j1=1:size(C{:},1)
    if strcmp(C{1}{j1},'INPUT')
        j2=j1;
        for i1=j1:size(C{:},1)
            if strcmp(C{1}{i1},'OUTPUT')
                break;
            end
        end
    end
end

in_row_length=i1-j2;
cols=max(out_length,in_row_length);%%%maximum number of columns in netlist file

format = repmat('%s',1,cols);
% fid = fopen('TESTCKT.txt','rt'); %for 4th circuit
fid = fopen('s27.txt','rt'); %for 1st circuit
% fid = fopen('s298f_2.txt','rt'); %for 2nd circuit
% fid = fopen('s344f_2.txt','rt'); %for 3rd circuit
% fid = fopen('s349f_2.txt','rt'); %for 4th circuit
C = textscan(fid,format);
fclose(fid);

%%%%%%%%%%CONVERTING INPUT FILE TO MATRIX%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rows=length(C{1});
% Instatiate cell array of the max size.
mat = cell(rows, cols);
% stuff each column in.
for k1=1:cols
    mat(1:length(C{k1}), k1) = C{k1};
end 
mat2=mat;%%%%duplicating NETLIST file for mapping of nodes wrt mat2
for n=1:cols
    if strcmp(mat2{size(mat2,1),n},'-1')
        break
    end
end

%%%%%%%%%SCANNING TEST VECTORS FILE%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
format = repmat('%s',1,cols);
fid = fopen('S27TV.txt','rt'); %%test vector file for 1st circuit
% fid = fopen('S298F_2TV.txt','rt'); %%test vector file for 2nd circuit
% fid = fopen('S344F_2TV.txt','rt'); %%test vector file for 3rd circuit
% fid = fopen('S349F_2TV.txt','rt'); %%test vector file for 4th circuit
TV = textscan(fid,format);
fclose(fid);
%%%calculating length of input test vectors
for j1=2:length(TV)%length(b12)+1
    if strcmp(TV{j1}{1},'')
        break
    end
end
tv_length=j1-1;%%%length of input test vectors
%%%%%%%%%CONVERTING TEST VECTORS FILE TO MATRIX%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rows=length(TV{1});
%%%%Instatiate cell array of the max size.
mat1 = cell(rows, tv_length);
%%%%stuff each column in.
for k1=1:tv_length
    mat1(1:length(TV{k1}), k1) = TV{k1};
end
mat1;

%%%%%%%%%%%DEFINING OUTPUT MATRIX%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_out=out_length-2;
num_ins=size(mat1,1);
OUT=-1.*ones(num_ins,num_out);

%%%%%%%%CONVERTING NODE NUMBERS INTO DEC IN MAT2%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i2=1:size(mat,1)-2%
    for i1=2:4
        mat2{i2,i1}=str2double(mat2{i2,i1});
    end
end
mat3=mat2;%%duplicating mat2 so that it can beused to reset mat2 
          %%% to evaluate each test vector in next for loop.
          
for x1=1:size(mat1,1)
    mat2=mat3;%%resetting mat2
              %b12=['0' '0' '0' '1' '1' '1' '1']//FOR SINGLE TV//
              
    %%%%%%%ENTERING TEST VECTORS INTO INPUT ROW OF MAT2%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    k=1;
    for j1=2:length(mat1)+1%length(b12)+1//FOR SINGLE TV//
        mat2{size(mat2,1)-1,j1}=mat1{x1,k};
        k=k+1;
    end
    
    %%%%%%%%%%%READING TEST VECTORS TO INPUT NODES%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i1=2:4        %%%2 to max coloumns of MAT
        for i2=1:size(mat,1)-2    %%%1 to max rows of MAT-2
            for j1=2:cols
                if (str2double(mat{i2,i1})==str2double(mat{size(mat,1)-1,j1}));
                    mat2{i2,i1}= str2double(mat2{size(mat2,1)-1,j1});
                end
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%GATE EVALUATION%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    count=0; %%%%COUNT shows #gates EVALUATED
    while count~=size(mat,1)-2%%%while loop to ensure all gates are evaluated
        for m=1:size(mat,1)-2%%%for loop for incrementing row index
            if ((mat2{m,2})==0 || (mat2{m,2})==1)%%%checking if 1ST INPUT is ASSIGNED
                if (strcmp(mat2(m,1),'AND')==1)%%%checking AND gate
                    if ((mat2{m,3})==0 || (mat2{m,3})==1)%%%checking if 2ND INPUT is ASSIGNED
                        if ((mat2{m,4})~=0 && (mat2{m,4})~=1)%%%checking if OUTPUT is EVALUATED
                            mat2{m,4}=and((mat2{m,2}),(mat2{m,3}));%%%EVALUATING OUTPUT
                            count=count+1;
                            %%%
                            mat2=node_update_2_input_gate(mat,mat2,m);
                            %%%
                        end%%%end of if statement to check output
                    end%%%end of if condition to check 2nd input to gate
                elseif (strcmp(mat2(m,1),'OR')==1)%%%checking OR gate
                    if ((mat2{m,3})==0 || (mat2{m,3})==1)%%%checking if 2ND INPUT is ASSIGNED
                        if ((mat2{m,4})~=0 && (mat2{m,4})~=1)%%%checking if OUTPUT is EVALUATED
                            mat2{m,4}=or((mat2{m,2}),(mat2{m,3}));%%%EVALUATING OUTPUT
                            count=count+1;
                            %%%%
                            mat2=node_update_2_input_gate(mat,mat2,m);
                            %%%%
                        end%%%end of if statement to check output
                    end%%%end of if condition to check 2nd input to gate
                elseif (strcmp(mat2(m,1),'INV')==1)%%%checking NOT gate
                    if ((mat2{m,3})~=0 && (mat2{m,3})~=1)%%%checking if OUTPUT is EVALUATED
                        mat2{m,3}=~((mat2{m,2})) ;%%%EVALUATING OUTPUT
                        count=count+1;
                        %%%%
                        mat2=node_update_1_input_gate(mat,mat2,m);
                        %%%%
                    end%%%end of if statement to check output
                elseif (strcmp(mat2(m,1),'NAND')==1)%%%checking NAND gate
                    if ((mat2{m,3})==0 || (mat2{m,3})==1)%%%checking if 2ND INPUT is ASSIGNED
                        if ((mat2{m,4})~=0 && (mat2{m,4})~=1)%%%checking if OUTPUT is ALREADY EVALUATED
                            mat2{m,4}=~(and((mat2{m,2}),(mat2{m,3})));%%%EVALUATING OUTPUT
                            count=count+1;
                            %%%%
                            mat2=node_update_2_input_gate(mat,mat2,m);
                            %%%%
                        end%%%end of if statement to check output
                    end%%%end of if condition to check 2nd input to gate
                elseif (strcmp(mat2(m,1),'NOR')==1)%%%checking NOR gate
                    if ((mat2{m,3})==0 || (mat2{m,3})==1)%%%checking if 2ND INPUT is ASSIGNED
                        if ((mat2{m,4})~=0 && (mat2{m,4})~=1)%%%checking if OUTPUT is EVALUATED
                            mat2{m,4}=~(or((mat2{m,2}),(mat2{m,3})));%%%EVALUATING OUTPUT
                            count=count+1;
                            %%%%
                            mat2=node_update_2_input_gate(mat,mat2,m);
                            %%%%
                        end%%%end of if statement to check output
                    end%%%end of if condition to check 2nd input to gate
                elseif (strcmp(mat2(m,1),'BUF'))%%%checking BUFFER
                    if ((mat2{m,3})~=0 && (mat2{m,3})~=1)%%%checking if OUTPUT is ALREADY EVALUATED
                        mat2{m,3}=(mat2{m,2});%%%EVALUATING OUTPUT
                        count=count+1;
                        %%%%
                         mat2=node_update_1_input_gate(mat,mat2,m);
                        %%%%
                    end%%%end of if statement to check output
                end%%%end of if-else coditions to check gates
            end%%%end of if condition to check 1st input to gate
        end%%%end of for loop for row increment
    end%%%end of while loop to check all gate evaluations are successfull
    
    %%%%%%%%%%%DISPLAYING PRIMARY OUTPUTS IN MAT2%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i1=2:cols
        for j2=3:4
            for j1=1:size(mat,1)-2
                if strcmp(mat(size(mat,1),i1),mat(j1,j2))
                    mat2{size(mat,1),i1}=mat2{j1,j2};
                end
            end
        end
    end
    %%%%%%SAVING IN OUTPUT MATRIX%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for n=1:num_out
        OUT(x1,n)=mat2{size(mat2,1),n+1};
    end
end%%%end of for loop to vary input test vectors
disp(OUT)%%%Display output matrix
toc