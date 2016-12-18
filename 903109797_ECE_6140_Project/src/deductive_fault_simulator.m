% The Deductive Fault Simulator calculates the list of faults of any given circuit 
% consisting of two input logic gates with any given input vectors or random test vector.
% It also shows plot of fault coverage vs number of random tests applied.
% 
% Working:
%     The fault simulator first reads the input netlist file and estimates the maximum
%     number of columns required for the matrix to store the netlist file.
%     Then it reads the input test vector or a matrix of random test vectors from the user.
% 
%     NOTE: For correct operation select the matching/appropriate input files to be read.      
% 
%     During computing output of an gate, that list of faults that can be detected at that
%     node will be updated and propagated to next stage.
% 
%     When all the gates are evaluated, the output is displayed in mat2 matrix. And the fault 
%     list and fault coverage are saved in a text file named "exp.txt"
% 
%     In this fuction we use sort_nat function created by Douglas M. Schwarz to sort the strings
%     in the final fault list generated. It has nothing to do with the operating function of the
%     fault simulator
%     
% License to use and modify this code is granted freely to all interested, as long as the 
% original author is referenced and attributed as such. The original author maintains the 
% right to be solely associated with this work.
% 
% Version: 1.0, 10/28/2015
% Author:  C.V. Chaitanya Krishna
% email:   cvchaitanyak7@gmail.com

clc
tic

%%%%%%%%%%SCANNING INPUT FILE%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fid = fopen('TESTCKT.txt','rt'); %for 4th circuit
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
% fid = fopen('TESTCKT.txt','rt'); %for 4th circuit
fid = fopen('s27.txt','rt'); %for 1st circuit
% fid = fopen('s298f_2.txt','rt'); %for 2nd circuit
% fid = fopen('s344f_2.txt','rt'); %for 3rd circuit
% fid = fopen('s349f_2.txt','rt'); %for 4th circuit
C = textscan(fid,format);
fclose(fid);
tv_length=in_row_length-2;
%%%%%%%%%%GENERATING RANDOM TEST VECTORS%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n1=inputdlg('Enter number of random test vectors','Input number of random test vectors',1);
n1=str2double(n1{1}); 
Q=cell(n1,tv_length);
for i=1:n1
    Q{i}=randi([0 1],1,tv_length);
end
TV=zeros([n1,tv_length]);
for i=1:n1
    for j=1:tv_length
        TV(i,j)=Q{i,1}(j);
    end
end
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
nodes=max([mat4{:}]);

%%%%%%%%%IMPORTING TARGET FAULTS FROM FILE%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%CALCULATING UNIVERSE OF FAULTS%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
UF=[];
for i=1:nodes
    i1=num2str(i);
    UF=union(UF,{strcat(i1,' stuck at 0') strcat(i1,' stuck at 1')});
end
%%%converting input row in netlist file to numbers%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=1;
for j1=1:tv_length
        mat2{size(mat2,1)-1,j1+1}=str2double(mat2{size(mat2,1)-1,j1+1});
        k=k+1;
end
mat4=mat2;%%%%duplicating mat2 so that list can be referenced to wrt mat4
list=cell(1,nodes);%%%creating cell array for lists at all nodes

%%%%%SELECTING THE COMPUTATION METHOD%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prompt = {'Random test vectors=1 ; Single input test vector=0:'};
dlg_title = 'Computation Method';
num_lines = 1;
answer = inputdlg(prompt,dlg_title,num_lines);
if strcmp(answer,'1')
elseif strcmp(answer,'0')
    TV1=inputdlg('Enter test vector','Input test vector',1);%%ENTER TV WITH SPACE BETWEEN TWO VALUES
                                                            %%ex:10001=>1 0 0 0 1
    TV=zeros(1,tv_length);
    temp=strsplit(TV1{1});
    for i=1:tv_length
        TV(1,i)=str2double(temp{1,i});
    end
end

fileID = fopen('exp.txt','w');%%%%file for saving detected faults

%%%%%%%%%%ASSIGNING TEST VECTORS TO PRIMARY INPUTS%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DF1=[];%%%cumulative detected fault list
FC=zeros(size(TV,1),1);%%%%fault coverage matrix
for r=1:size(TV,1)
k=1;
mat2=mat3;
for j1=1:tv_length
        mat2{size(mat2,1)-1,j1+1}=str2double(num2str(TV(r,k))); %%assigining TV to Input nodes of netlist file
        i=num2str(mat4{size(mat4,1)-1,j1+1}); %%converting node number to string
        j=num2str(~str2double(num2str(TV(r,k)))); %%converting NOT of TV bit to string
        list{mat4{size(mat4,1)-1,j1+1}}={strcat(i,horzcat(' stuck at ',j))}; %%generating list at primary input node
        k=k+1;
end

%%%%%%%%%%%READING TEST VECTORS TO INPUT NODES%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i1=2:4        %%%1 to max coloumns of MAT
    for i2=1:size(mat,1)-2    %%%1 to max rows of MAT
        for j1=2:cols
            if (str2double(mat{i2,i1})==str2double(mat{size(mat,1)-1,j1}))%%%strcmp(mat(i2,i1),mat(size(mat,1)-1,j1))==1
                mat2{i2,i1}= (mat2{size(mat2,1)-1,j1});
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
                            %%%NODE UPDATE%%%
                            mat2=node_update_2_input_gate(mat,mat2,m);
                            %%%LIST GENERATION%%%
                            if (mat2{m,2}==0 && mat2{m,3}==0)
                                list{mat4{m,4}}=union((intersect(list{mat4{m,2}},list{mat4{m,3}})),strcat(mat{m,4},' stuck at 1'));
                            elseif (mat2{m,2}==0 && mat2{m,3}==1)
                                list{mat4{m,4}}=union((setdiff(list{mat4{m,2}},list{mat4{m,3}})),strcat(mat{m,4},' stuck at 1'));
                            elseif (mat2{m,2}==1 && mat2{m,3}==0)
                                list{mat4{m,4}}=union((setdiff(list{mat4{m,3}},list{mat4{m,2}})),strcat(mat{m,4},' stuck at 1'));
                            elseif (mat2{m,2}==1 && mat2{m,3}==1)
                                list{mat4{m,4}}=union((union(list{mat4{m,2}},list{mat4{m,3}})),strcat(mat{m,4},' stuck at 0'));
                            end
                            %%%
                        end%%%end of if statement to check output
                    end%%%end of if condition to check 2nd input to gate
                elseif (strcmp(mat2(m,1),'OR')==1)%%%checking OR gate
                    if ((mat2{m,3})==0 || (mat2{m,3})==1)%%%checking if 2ND INPUT is ASSIGNED
                        if ((mat2{m,4})~=0 && (mat2{m,4})~=1)%%%checking if OUTPUT is EVALUATED
                            mat2{m,4}=or((mat2{m,2}),(mat2{m,3}));%%%EVALUATING OUTPUT
                            count=count+1;
                            %%%%NODE UPDATE%%%
                            mat2=node_update_2_input_gate(mat,mat2,m);
                            %%%%LIST GENERATION%%%
                            if (mat2{m,2}==0 && mat2{m,3}==0)
                                list{mat4{m,4}}=union((union(list{mat4{m,2}},list{mat4{m,3}})),strcat(mat{m,4},' stuck at 1'));
                            elseif (mat2{m,2}==0 && mat2{m,3}==1)
                                list{mat4{m,4}}=union((setdiff(list{mat4{m,3}},list{mat4{m,2}})),strcat(mat{m,4},' stuck at 0'));
                            elseif (mat2{m,2}==1 && mat2{m,3}==0)
                                list{mat4{m,4}}=union((setdiff(list{mat4{m,2}},list{mat4{m,3}})),strcat(mat{m,4},' stuck at 0'));
                            elseif (mat2{m,2}==1 && mat2{m,3}==1)
                                list{mat4{m,4}}=union((intersect(list{mat4{m,2}},list{mat4{m,3}})),strcat(mat{m,4},' stuck at 0'));
                            end
                            %%%
                        end%%%end of if statement to check output
                    end%%%end of if condition to check 2nd input to gate
                elseif (strcmp(mat2(m,1),'INV')==1)%%%checking NOT gate
                    if ((mat2{m,3})~=0 && (mat2{m,3})~=1)%%%checking if OUTPUT is EVALUATED
                        mat2{m,3}=~((mat2{m,2})) ;%%%EVALUATING OUTPUT
                        count=count+1;
                        %%%%NODE UPDATE%%%%
                        mat2=node_update_1_input_gate(mat,mat2,m);
                        %%%%LIST GENERATION%%%%
                        if (mat2{m,2}==0)
                            list{mat4{m,3}}=union(list{mat4{m,2}},strcat(mat{m,3},' stuck at 0'));
                        elseif (mat2{m,2}==1)
                            list{mat4{m,3}}=union(list{mat4{m,2}},strcat(mat{m,3},' stuck at 1'));
                        end
                        %%%%
                    end%%%end of if statement to check output
                elseif (strcmp(mat2(m,1),'NAND')==1)%%%checking NAND gate
                    if ((mat2{m,3})==0 || (mat2{m,3})==1)%%%checking if 2ND INPUT is ASSIGNED
                        if ((mat2{m,4})~=0 && (mat2{m,4})~=1)%%%checking if OUTPUT is ALREADY EVALUATED
                            mat2{m,4}=~(and((mat2{m,2}),(mat2{m,3})));%%%EVALUATING OUTPUT
                            count=count+1;
                            %%%%NODE UPDATE%%%%
                            mat2=node_update_2_input_gate(mat,mat2,m);
                            %%%%LIST GENERATION%%%%
                            if (mat2{m,2}==0 && mat2{m,3}==0)
                                list{mat4{m,4}}=union((intersect(list{mat4{m,2}},list{mat4{m,3}})),strcat(mat{m,4},' stuck at 0'));
                            elseif (mat2{m,2}==0 && mat2{m,3}==1)
                                list{mat4{m,4}}=union((setdiff(list{mat4{m,2}},list{mat4{m,3}})),strcat(mat{m,4},' stuck at 0'));
                            elseif (mat2{m,2}==1 && mat2{m,3}==0)
                                list{mat4{m,4}}=union((setdiff(list{mat4{m,3}},list{mat4{m,2}})),strcat(mat{m,4},' stuck at 0'));
                            elseif (mat2{m,2}==1 && mat2{m,3}==1)
                                list{mat4{m,4}}=union((union(list{mat4{m,2}},list{mat4{m,3}})),strcat(mat{m,4},' stuck at 1'));
                            end
                            %%%
                        end%%%end of if statement to check output
                    end%%%end of if condition to check 2nd input to gate
                elseif (strcmp(mat2(m,1),'NOR')==1)%%%checking NOR gate
                    if ((mat2{m,3})==0 || (mat2{m,3})==1)%%%checking if 2ND INPUT is ASSIGNED
                        if ((mat2{m,4})~=0 && (mat2{m,4})~=1)%%%checking if OUTPUT is EVALUATED
                            mat2{m,4}=~(or((mat2{m,2}),(mat2{m,3})));%%%EVALUATING OUTPUT
                            count=count+1;
                            %%%%NODE UPDATE%%%%
                            mat2=node_update_2_input_gate(mat,mat2,m);
                            %%%%LIST GENERATION%%%%
                            if (mat2{m,2}==0 && mat2{m,3}==0)
                                list{mat4{m,4}}=union((union(list{mat4{m,2}},list{mat4{m,3}})),strcat(mat{m,4},' stuck at 0'));
                            elseif (mat2{m,2}==0 && mat2{m,3}==1)
                                list{mat4{m,4}}=union((setdiff(list{mat4{m,3}},list{mat4{m,2}})),strcat(mat{m,4},' stuck at 1'));
                            elseif (mat2{m,2}==1 && mat2{m,3}==0)
                                list{mat4{m,4}}=union((setdiff(list{mat4{m,2}},list{mat4{m,3}})),strcat(mat{m,4},' stuck at 1'));
                            elseif (mat2{m,2}==1 && mat2{m,3}==1)
                                list{mat4{m,4}}=union((intersect(list{mat4{m,2}},list{mat4{m,3}})),strcat(mat{m,4},' stuck at 1'));
                            end
                            %%%
                        end%%%end of if statement to check output
                    end%%%end of if condition to check 2nd input to gate
                else (strcmp(mat2(m,1),'BUF'));%%%checking BUFFER
                    if ((mat2{m,3})~=0 && (mat2{m,3})~=1)%%%checking if OUTPUT is ALREADY EVALUATED
                        mat2{m,3}=(mat2{m,2});%%%EVALUATING OUTPUT
                        count=count+1;
                        %%%%NODE UPDATE%%%%
                        mat2=node_update_1_input_gate(mat,mat2,m);
                        %%%%LIST GENERATION
                        if (mat2{m,2}==0)
                            list{mat4{m,3}}=union(list{mat4{m,2}},strcat(mat{m,3},' stuck at 1'));
                        elseif (mat2{m,2}==1)
                            list{mat4{m,3}}=union(list{mat4{m,2}},strcat(mat{m,3},' stuck at 0'));
                        end 
                        %%%%
                    end%%%end of if statement to check output
                end%%%end of if-else coditions to check gates
            end%%%end of if condition to check 1st input to gate
        end%%%end of for loop for row increment
    end%%%end of while loop to check all gate evaluations are successfull
    
%%%%%DISPLAYING PRIMARY OUTPUTS IN MAT2%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i1=2:cols
    for j2=3:4
        for j1=1:size(mat,1)-2
            if strcmp(mat(size(mat,1),i1),mat(j1,j2))
                mat2{size(mat,1),i1}=mat2{j1,j2};
            end
        end
    end
end

disp(mat2)

%%%%%%%CALCULATING DETECTED FAULT LIST%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DF=[];

for k=2:out_length-1
    DF=setdiff(union(DF,list{str2double(mat4{size(mat2,1),k})}),DF1);
end

DF=sort_nat(DF);%%%%%%%%USED SORT_NAT FUNCTION FOR SORTING%%%%%%
DF3=DF;%%%%duplicating DF1 to use below
DF1=sort_nat(union(DF,DF1,'sorted'));%%%%cumulative detected faults%%%%%%%%USED SORT_NAT FUNCTION FOR SORTING%%%%%%
fault_coverage=max(size(DF1))/size(UF,1)*100;%%%%fault coverage
FC(r)=fault_coverage;%%%%%fault coverage matrix

if isempty(DF3)
    DF3={'No new faults are detected'};%%%return when no new faults are detected
end

%%%%%%%%%%%%Printing Detected Faults to a file%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k22=num2str(TV(r,1:tv_length));
fileID = fopen('exp.txt','a');
fprintf(fileID,'New faults detected for TV: %s\n',k22);
fprintf(fileID,'%s\n',DF3{:});
fprintf(fileID,'\n');
fclose(fileID);

if fault_coverage==100  %%%%stop testing when coverage is 100%
    break;
end

end
FC1=zeros(r,1);
FC1(1:r,1)=FC(1:r,1);

%%%%%%%%Printing Fault Coverage to the Detected Faults file%%%%
fileID = fopen('exp.txt','a');
fprintf(fileID,'Fault coverage = %f%s',FC(r),'%');
fclose(fileID);
%%%%Fault Coverage vs Number of Applied Tests Plot%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=1:r;
plot(n,FC1)
grid on;
title ('Fault Coverage vs Number of Applied Tests Plot')
xlabel ('Number of Applied Tests')
ylabel ('Fault Coverage(%)')

DF1;
type exp.txt
toc