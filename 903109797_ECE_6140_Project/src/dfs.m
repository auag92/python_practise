function dfs(mat,test,target_fault,fault_node,fault_val,pos)
% dfs fnction is essntially The Deductive Fault Simulator which calculates the list of faults of any given circuit 
% consisting of two input logic gates with any given input vector.
% 
% Working:
%     The input netlist file of the circuit and the test vector are passed as the input arguments
%     to the dfs function
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

cols=size(mat,2);
tv_length=length(test);
mat2=mat;%%%%duplicating NETLIST file for mapping of nodes wrt mat2
out_length=length(pos)+2;

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

for i1=1:length(test)
    if strcmp(test(i1),'x')
        TV(1,i1)=randi([0 1]);
    else
        TV(1,i1)=str2double(test(i1));
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



DF1;
type exp.txt
target_fault=horzcat(fault_node,' ','stuck at ',num2str(~fault_val));

if size(setdiff(target_fault,DF1),2)==0
    cprintf('text','\n')
    cprintf('*comments','Test verified')
    cprintf('text','\n \n')
else
    cprintf('*err','Test failed')
    cprintf('text','\n \n')
end

end