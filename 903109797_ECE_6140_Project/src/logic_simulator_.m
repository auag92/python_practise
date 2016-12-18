clear
clc
tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen('s27.txt','rt'); %for 1st circuit
% fid = fopen('s298f_2.txt','rt'); %for 2nd circuit
% fid = fopen('s344f_2.txt','rt'); %for 3rd circuit
% % fid = fopen('s349f_2.txt','rt'); %for 4th circuit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C = textscan(fid,'%s');
fclose(fid);
clear fid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%Calculating length of output row of total list File%%%%%%%%%%%%%%

len = size(C{1},1);
save = len;
while 1
    if strcmp(C{1}{save},'OUTPUT')
        break;
    else
        save = save-1;
    end
end 

out_length =  len - save + 1;

%%%%%%%%%%Calculating length of INPUT row of total list File%%%%%%%%%%%%%%
len = save;
while 1
    if strcmp(C{1}{save},'INPUT')
        break;
    else
        save = save -1;
    end
end

in_row_length_ = len - save;
cols=max(out_length,in_row_length_);%%%maximum number of columns in netlist file

format = repmat('%s',1,cols);
% fid = fopen('TESTCKT.txt','rt'); %for 4th circuit
fid = fopen('s27.txt','rt'); %for 1st circuit
% fid = fopen('s298f_2.txt','rt'); %for 2nd circuit
% fid = fopen('s344f_2.txt','rt'); %for 3rd circuit
% fid = fopen('s349f_2.txt','rt'); %for 4th circuit
C = textscan(fid,format);
fclose(fid);

%%%%%%%%%%CONVERTING INPUT FILE TO MATRIX%%%%%%%%%

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

format = repmat('%s',1,cols);
fid = fopen('S27TV.txt','rt'); %%test vector file for 1st circuit
% fid = fopen('S298F_2TV.txt','rt'); %%test vector file for 2nd circuit
% fid = fopen('S344F_2TV.txt','rt'); %%test vector file for 3rd circuit
% fid = fopen('S349F_2TV.txt','rt'); %%test vector file for 4th circuit
TV = textscan(fid,format);
fclose(fid);

%%%calculating length of input test vectors%%%
for j1=2:length(TV)%length(b12)+1
    if strcmp(TV{j1}{1},'')
        break
    end
end
tv_length=j1-1;%%%length of input test vectors
%%%%%%%%%CONVERTING TEST VECTORS FILE TO MATRIX%%%%%%%%%

rows=length(TV{1});
%%%%Instatiate cell array of the max size.
mat1 = cell(rows, tv_length);
%%%%stuff each column in.
for k1=1:tv_length
    mat1(1:length(TV{k1}), k1) = TV{k1};
end
mat1;

%%%%%%%%%%%DEFINING OUTPUT MATRIX%%%%%%%%%%%%%%%%%%%%

num_out=out_length-2;
num_ins=size(mat1,1);
OUT=-1.*ones(num_ins,num_out);

%%%%%%%%CONVERTING NODE NUMBERS INTO DEC IN MAT2%%%%%

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

    k=1;
    for j1=2:length(mat1)+1%length(b12)+1//FOR SINGLE TV//
        mat2{size(mat2,1)-1,j1}=mat1{x1,k};
        k=k+1;
    end
    
    %%%%%%%%%%%READING TEST VECTORS TO INPUT NODES%%%%%%%%%%%%
    
    for i1=2:4        
        for i2=1:size(mat,1)-2   
            for j1=2:cols
                if (str2double(mat{i2,i1})==str2double(mat{size(mat,1)-1,j1}));
                    mat2{i2,i1}= str2double(mat2{size(mat2,1)-1,j1});
                end
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%GATE EVALUATION%%%%%%%%%%%%%%%%%%%%%%%
    
    count=0; 
    while count~=size(mat,1)-2
        for m=1:size(mat,1)-2
            if ((mat2{m,2})==0 || (mat2{m,2})==1)
                if (strcmp(mat2(m,1),'AND')==1)
                    if ((mat2{m,3})==0 || (mat2{m,3})==1)
                        if ((mat2{m,4})~=0 && (mat2{m,4})~=1)
                            mat2{m,4}=and((mat2{m,2}),(mat2{m,3}));
                            count=count+1;
                            
                            mat2=node_update_2_input_gate(mat,mat2,m);
                            
                        end
                    end
                elseif (strcmp(mat2(m,1),'OR')==1)
                    if ((mat2{m,3})==0 || (mat2{m,3})==1)
                        if ((mat2{m,4})~=0 && (mat2{m,4})~=1)
                            mat2{m,4}=or((mat2{m,2}),(mat2{m,3}));
                            count=count+1;
                            
                            mat2=node_update_2_input_gate(mat,mat2,m);
                            
                        end
                    end
                elseif (strcmp(mat2(m,1),'INV')==1)
                    if ((mat2{m,3})~=0 && (mat2{m,3})~=1)
                        mat2{m,3}=~((mat2{m,2})) ;
                        count=count+1;
                        
                        mat2=node_update_1_input_gate(mat,mat2,m);
                        
                    end
                elseif (strcmp(mat2(m,1),'NAND')==1)
                    if ((mat2{m,3})==0 || (mat2{m,3})==1)
                        if ((mat2{m,4})~=0 && (mat2{m,4})~=1)
                            mat2{m,4}=~(and((mat2{m,2}),(mat2{m,3})));
                            count=count+1;
                            
                            mat2=node_update_2_input_gate(mat,mat2,m);
                            
                        end
                    end
                elseif (strcmp(mat2(m,1),'NOR')==1)
                    if ((mat2{m,3})==0 || (mat2{m,3})==1)
                        if ((mat2{m,4})~=0 && (mat2{m,4})~=1)
                            mat2{m,4}=~(or((mat2{m,2}),(mat2{m,3})));
                            count=count+1;
                            
                            mat2=node_update_2_input_gate(mat,mat2,m);
                            
                        end
                    end
                elseif (strcmp(mat2(m,1),'BUF'))
                    if ((mat2{m,3})~=0 && (mat2{m,3})~=1)
                        mat2{m,3}=(mat2{m,2});
                        count=count+1;
                        
                         mat2=node_update_1_input_gate(mat,mat2,m);
                        
                    end
                end
            end
        end
    end
    
    %%%%%%%%%%%DISPLAYING PRIMARY OUTPUTS IN MAT2%%%%%%%%%%%%%%%%%%%%%%%%
    
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
    
    for n=1:num_out
        OUT(x1,n)=mat2{size(mat2,1),n+1};
    end
end
disp(OUT)
toc


