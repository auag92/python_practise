% podem_main is essntially used to initalise all the variables used in later functions and to 
% read the input circuit file and to input the stuck value and fault location.
% 
% Working:
%     The input netlist file of the circuit is reads the input netlist file and estimates the 
%     maximum number of columns required for the matrix to store the netlist file. The fault 
%     position and the fault value are taken as input from user.
%      
%     For the generation of test vector podem1 function is called which is essentially the main 
%     body of PODEM algorithm and if any test vector is generated we pass it through dfs function 
%     is a deductive fault simulator to verify the generated test vector.
%          
%     In this fuction we use cprintf function created by Yair M. Altman to print colored text in 
%     the command window. It has nothing to do with the operating function of the fault simulator
%     
% License to use and modify this code is granted freely to all interested, as long as the 
% original author is referenced and attributed as such. The original author maintains the 
% right to be solely associated with this work.
% 
% Version: 1.0, 12/01/2015
% Author:  C.V. Chaitanya Krishna
% email:   cvchaitanyak7@gmail.com

clc;
tic
%%%%%%%%%%SCANNING INPUT FILE%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fid = fopen('TESTCKT.txt','rt');
fid = fopen('s27.txt','rt'); %for 1st circuit
% fid = fopen('s298f_2.txt','rt'); %for 2nd circuit
% fid = fopen('s344f_2.txt','rt'); %for 3rd circuit
% fid = fopen('s349f_2.txt','rt'); %for 4th circuit
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
% fid = fopen('TESTCKT.txt','rt');
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
%%%%%%%%CONVERTING NODE NUMBERS INTO DEC IN MAT2%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i2=1:size(mat,1)-2%
    for i1=2:4
        mat2{i2,i1}=str2double(mat2{i2,i1});
    end
end
mat3=mat2;%%duplicating mat2 so that it can beused to reset mat2 
          %%% to evaluate each test vector in next for loop.

%%%%%%%%%CALCULATING TOTAL NUMBER OF NODES%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mat4=mat2(1:size(mat,1)-2,2:4);
nodes=max([mat4{:}]); %%total number of nodes

PIs=cell(mat(size(mat,1)-1,2:in_row_length-1));
pis=zeros(1,in_row_length-2);
for i1=1:in_row_length-2
    pis(i1)=str2num(PIs{i1}); %%all PIs
end

POs=cell(mat(size(mat,1),2:out_length-1));
pos=zeros(1,out_length-2);
for i1=1:out_length-2
    pos(i1)=str2num(POs{i1}); %%all POs
end

all_nodes=zeros(1,nodes);
for i1=1:nodes
    all_nodes(i1)=i1; %%all nodes
end

output_nodes=setdiff(all_nodes,pis); %%all nodes except PIs
input_nodes=setdiff(all_nodes,pos); %%all nodes except POs

%%%%%ASSIGINIG ALL NODES TO X%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i2=1:size(mat,1)-2%
        if strcmp(mat2{i2,1},'INV')||strcmp(mat2{i2,1},'BUF')
        mat2{i2,2}='x'; mat2{i2,3}='x';
        else
            mat2{i2,2}='x';mat2{i2,3}='x';mat2{i2,4}='x';
        end
end

%%%%%initialising all input variables to 0%%%%%%%%
DFront=zeros(1,size(mat,1)-2);
x_check=0;
count=0;
v=0;
target_fault=0;
fp=0;
XF=0;
x_len=0;
test='0';
in=zeros(size(mat,1)-2,1);
c=zeros(size(mat,1)-2,1);

in=inversion_parity(mat2,in); %%calculating inversion parity of gates 
c=controlling_vals(mat2,c);  %%calculating controlling values of gates

fault_node=num2str(input('enter fault location\n'));
fault_val=~input('enter stuck value\n');

%%%%calling main PODEM function%%%%%%%%%%%
[mat2,result,x_check,XF,DFront,fp,v,count,x_len,test]=podem1(mat,mat2,fault_node,fault_val,pis,DFront,fp,v,in,count,output_nodes,c,x_check,XF,out_length,x_len,pos,test);

%%%%%%checking if PODEM is successfull or failed%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(result,'failure')
    cprintf('*err','test not found') %%%if PODEM has failed
    cprintf('text','\n \n')
end

if strcmp(result,'success')
    dfs(mat,test,target_fault,fault_node,fault_val,pos);%%%calling deductive fault simulator if podem is successfull
    cprintf('*text','The generated test vector is: ')
    cprintf('*comments','%s',test)
    cprintf('text','\n \n')
end

toc