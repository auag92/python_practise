%PODEM

clc;
clear all;

global Q T Dfront inputs outputs OP fault;
% global orderTables ttor ttand ttinv ttNor ttNand;  
T={};
%% enter inputs

fid = fopen('abc.txt');
Tmain{:,1} = (char(fgetl(fid)));
n=2;
    p=ischar((char(Tmain)));

%insert fault
fault(:,1)=10;
fault(:,2)=0;
% divide into columns for each line
while p~=0
%     p=ischar((char(tline)));
    %     disp(tline)
    Tmain{n,1} = (fgetl(fid));

%     p=ischar((char(tline)));
    if Tmain{n,1}==-1
        p=0;
    end
        n=n+1;
end

% divide for input and output in separate cells
sizeFile=size(Tmain,1);
Tinput{:,1}=Tmain{sizeFile-2,1};
Toutput{:,1}=Tmain{sizeFile-1,1};
for n=1:1:sizeFile-3
T1{n,1}=Tmain{n,1};
end

% separate circuit data appropriately per block (row wise)
for n=1:1:sizeFile-3
spacesC = find(T1{n,1}==' ');
m=1;
data{n,m}=T1{n,1}(1:spacesC(m));
for m=2:1:size(spacesC,2)
    data{n,m}=T1{n,1}(spacesC(m-1):spacesC(m));
end
data{n,size(spacesC,2)+1}=T1{n,1}(spacesC(m):end);
end

% separate input data appropriately per block (row wise)
spacesI = find(Tinput{1,1}==' ');
m=1;
input{1,m}=Tinput{1,1}(1:spacesI(m));
for m=2:1:size(spacesI,2)
    input{1,m}=Tinput{1,1}(spacesI(m-1):spacesI(m));
end
if size(spacesI,2)==1
    input{1,2}=Tinput{1,1}(end);
else
    input{1,size(spacesI,2)+1}=Tinput{1,1}(spacesI(m):end);
end

% separate output data appropriately per block (row wise)
spacesO = find(Toutput{1,1}==' ');
m=1;
output{1,m}=Toutput{1,1}(1:spacesO(m));
for m=2:1:size(spacesO,2)
    output{1,m}=Toutput{1,1}(spacesO(m-1):spacesO(m));
end
if size(spacesO,2)==1
    output{1,2}=Toutput{1,1}(end);
else
    output{1,size(spacesO,2)+1}=Toutput{1,1}(spacesO(m):end);
end

for i=1:1:size(data,1)
    for j=1:1:size(data,2)
        if j==1
            data{i,j}=strtrim(data{i,j});
        else
            if isempty(data{i,j})==1
                data{i,j}=0;
            else
                data{i,j}=str2num(data{i,j});
            end
        end
    end
end
T=data;

for i=2:1:size(input,2)
    inputs(i-1,1)=str2num(input{1,i});
    inputs(i-1,2)=9999;
end
for i=2:1:size(output,2)
    outputs(i-1,1)=str2num(output{1,i});
    outputs(i-1,2)=9999;
end

%% find max value of inputs and put 9999 for all unidentified inputs
maxVal = max([T{:,2:4}]);
Q(:,1)=1:1:maxVal;
Q(:,2)=9999;

% make a list of all output nodes
for n=1:1:size(T,1)
    if strcmp(T{n,1},'INV')||strcmp(T{n,1},'BUF')
        OP(n,1)= T{n,3};
    else
        OP(n,1)=T{n,4};
    end
end
Q(inputs(:,1),2)=inputs(:,2); %fit values of inputs into Q

K=[];
V=[];
Dfront=[];
J=[];
J1=[]; %USED TO KEEP TRACK OF WHAT INPUTS HAVE ALREADY BEEN SELECED DURING BACKTRACE
flag=1;
firstCase=0;
%% begin
[status,inputs,outputs,Q]=podem1(Q,T,Dfront,outputs,inputs,J,J1,K,V,fault,OP,flag);
