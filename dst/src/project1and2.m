% %% read data
clc;
clear all;

fid = fopen('s344f_2.txt');
Tmain{:,1} = (char(fgetl(fid)));
n=2;
    p=ischar((char(Tmain)));

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

inputs=[];
for i=2:1:size(input,2)
    inputs(i-1,1)=str2num(input{1,i});
%     inputs(i-2,2)=9999;
end
outputs=[];
for i=2:1:size(output,2)
    outputs(i-1,1)=str2num(output{1,i});
%     outputs(i-2,2)=9999;
end
inputs11(1,:) = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
inputs(:,2)=inputs11(1,:);
% disp('hello');
% % A = fread(fid, '*char',[1 1]);
% % fclose(fid);
% % csvwrite('s349f_2.txt');
%% working code
% clear all;
% clc;
% [A,B,C,D]=textread('s349f_2.txt','%s %d %d %d',166);
% 
% % A2=fileread('s349f_2.txt');
% % csvwrite('s349f_2.csv',A2);
% 
% % ip=strfind(A2,'INPUT');
% % op=strfind(A2,'OUTPUT');
% % data3=char(A2(1:ip-1));
% % csvwrite('s349f_2.csv',data3);
% 
% % input3=(cellstr(char(A2(ip:op-1))));
% % output3=char(A2(op:end));
% 
% % 
% % A1=fread(fid);
% % A1=cellstr(char(A1));
% 
% inputs1(1,:) = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24];%101010101010101011111111
% outputs1(1,:) = [25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50];%10101010101010101101010101
% inputs1(2,:) = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1 1 1 1 1 1 1];%[1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1]; %UNCOMMENT FOR FIXED INPUT
% % outputs1(2,:) = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1 0 1 0 1 0 1 0 1];
% 
% 
% inputs(:,1)=inputs1(1,:);
% outputs(:,1)=outputs1(1,:);
% inputs(:,2)=inputs1(2,:); %UNCOMMENT FOR FIXED INPUT

nCount=0; %number of test vectors
O{1,1}=char(); %cell for cumulitive addition of faults
p=0; %percentage of faults detected

while nCount~=1 % MAIN LOOP (do till 90% coverage/number of test vectors)
% random number generator
% for i=1:1:size(inputs,1)
% inputs(i,2)=round(rand(1,1));
% end

% outputs(:,2)=outputs1(2,:);

% T(:,1)=A(:,1);
% T(:,2)=num2cell(B);
% T(:,3)=num2cell(C);
% T(:,4)=num2cell(D);
%% find max value of inputs and put 9999 for all unidentified inputs
maxVal = max([T{:,2:4}]);
Q(:,1)=1:1:maxVal;
Q(:,2)=9999;
Q(inputs(:,1),2)=inputs(:,2);

Q1=Q;
check = size(find(Q==9999),1);

%% overall fault array
maxVal = max([T{:,2:4}]);
netNo=1;
% Qf=cell(2*size(Q,1),3);
for i=1:2:2*maxVal
Qf(i,1)=netNo;
Qf(i+1,1)=netNo;
Qf(i,2)=0;
Qf(i+1,2)=1;
Qf(i,3)=0;
Qf(i+1,3)=0;
netNo=netNo+1;
end

% Qf(inputs(:,1),2)=inputs(:,2);



%% eliminate faults for true values

for i=1:1:size(Q,1)
    for j=1:1:size(Qf,1)
        if Qf(j,1)==Q(i,1)&&Qf(j,2)==Q(i,2)
            Qf(j,3)=999;
        end
    end
end

% F{3,1}={};
% F{1,1}=char('50 60 70');
% F{2,1}=char('123 60 70');
% 
% F{3,1}=num2str(intersect(str2num(F{1,1}),str2num(F{2,1})));
% F{3,1}=num2str(setxor(str2num(F{1,1}),str2num(F{3,1})));

% A=char(num2str(Q(1,1)),'fsdfsd');
% A=char(num2str(A),'dsadas');
% A{1,1}=('dsadas');
% A{1,2}=char(horzcat(num2str(Q(1,1)),'fsdfsd'));
for i=1:1:maxVal %initialize E
E{i,1}={};
end

for i=1:1:size(Qf,1)
    if Qf(i,3)==0
        E{Qf(i,1),1}=char(horzcat(num2str(E{Qf(i,1),1}),num2str(Qf(i,1)),num2str(Qf(i,2)),' '));
    end
end
%% main code for logic simulation only
while check~=0
for n=1:1:size(T,1)
if strcmp(T(n,1),'INV')==1 && Q(T{n,2},2)~=9999
    if Q(T{n,2},2)==0
        Q(T{n,3},2)=1;
        H{1,1}=char(horzcat(num2str(Q(T{n,3},1)),num2str(Q(T{n,3},2))));
        K{1,1}=num2str(intersect(str2num(E{T{n,3},1}),str2num(H{1,1})));
        E{T{n,3},1}=char(num2str(setxor(str2num(E{T{n,3},1}),str2num(K{1,1}))));
    else
        Q(T{n,3},2)=0;
        H{1,1}=char(horzcat(' ',num2str(Q(T{n,3},1)),num2str(Q(T{n,3},2))));
        K{1,1}=num2str(intersect(str2num(E{T{n,3},1}),str2num(H{1,1})));
        E{T{n,3},1}=char(num2str(setxor(str2num(E{T{n,3},1}),str2num(K{1,1}))));    
    end
    % fault
   E{T{n,3},1}=char(horzcat(num2str(E{T{n,3},1}),' ',num2str(E{T{n,2},1}),' '));
end
end
for n=1:1:size(T,1)
    if strcmp(T(n,1),'BUF')==1 && Q(T{n,2},2)~=9999
        Q(T{n,3},2)=Q(T{n,2},2);
        H{1,1}=char(horzcat(num2str(Q(T{n,3},1)),num2str(Q(T{n,3},2))));
        K{1,1}=num2str(intersect(str2num(E{T{n,3},1}),str2num(H{1,1})));
        E{T{n,3},1}=char(num2str(setxor(str2num(E{T{n,3},1}),str2num(K{1,1}))));
    % fault
        E{T{n,3},1}=char(horzcat(num2str(E{T{n,3},1}),' ',num2str(E{T{n,2},1}),' '));
    end
end
for n=1:1:size(T,1)
    if strcmp(T(n,1),'AND')==1 && Q(T{n,2},2)~=9999 && Q(T{n,3},2)~=9999
        Q(T{n,4},2)=Q(T{n,2},2).*Q(T{n,3},2);
        
        H{1,1}=char(horzcat(num2str(Q(T{n,4},1)),num2str(Q(T{n,4},2))));
        K{1,1}=num2str(intersect(str2num(E{T{n,4},1}),str2num(H{1,1})));
        E{T{n,4},1}=char(num2str(setxor(str2num(E{T{n,4},1}),str2num(K{1,1}))));
    % fault
    if Q(T{n,2},2)==0 && Q(T{n,3},2)==0
        E{T{n,4},1}=char(horzcat(num2str(E{T{n,4},1}),' ',(num2str(intersect(str2num(E{T{n,3},1}),str2num(E{T{n,2},1})))),' '));
    end
    if Q(T{n,2},2)==1 && Q(T{n,3},2)==1
        E{T{n,4},1}=char(horzcat(num2str(E{T{n,4},1}),' ',num2str(E{T{n,3},1}),' ',num2str(E{T{n,2},1}),' '));
    end
    if Q(T{n,2},2)==0 && Q(T{n,3},2)==1
        G{1,1}=num2str(intersect(str2num(E{T{n,3},1}),str2num(E{T{n,2},1})));
        E{T{n,4},1}=char(horzcat(num2str(E{T{n,4},1}),' ',(num2str(setxor(str2num(G{1,1}),str2num(E{T{n,2},1})))),' '));    
    end
    if  Q(T{n,2},2)==1 && Q(T{n,3},2)==0
        G{1,1}=num2str(intersect(str2num(E{T{n,3},1}),str2num(E{T{n,2},1})));
        E{T{n,4},1}=char(horzcat(num2str(E{T{n,4},1}),' ',(num2str(setxor(str2num(G{1,1}),str2num(E{T{n,3},1})))),' '));      
    end
    end
end
for n=1:1:size(T,1)
if strcmp(T(n,1),'OR')==1 && Q(T{n,2},2)~=9999 && Q(T{n,3},2)~=9999
        Q(T{n,4},2)=Q(T{n,2},2)+Q(T{n,3},2);
        if Q(T{n,4},2)==2
            Q(T{n,4},2)=1;
        end
        H{1,1}=char(horzcat(num2str(Q(T{n,4},1)),num2str(Q(T{n,4},2))));
        K{1,1}=num2str(intersect(str2num(E{T{n,4},1}),str2num(H{1,1})));
        E{T{n,4},1}=char(num2str(setxor(str2num(E{T{n,4},1}),str2num(K{1,1}))));
    % fault
    if Q(T{n,2},2)==1 && Q(T{n,3},2)==1
        E{T{n,4},1}=char(horzcat(num2str(E{T{n,4},1}),' ',(num2str(intersect(str2num(E{T{n,3},1}),str2num(E{T{n,2},1})))),' '));
    end
    if Q(T{n,2},2)==0 && Q(T{n,3},2)==0
        E{T{n,4},1}=char(horzcat(num2str(E{T{n,4},1}),' ',num2str(E{T{n,3},1}),' ',num2str(E{T{n,2},1}),' '));
    end
    if Q(T{n,2},2)==1 && Q(T{n,3},2)==0
        G{1,1}=num2str(intersect(str2num(E{T{n,3},1}),str2num(E{T{n,2},1})));
        E{T{n,4},1}=char(horzcat(num2str(E{T{n,4},1}),' ',(num2str(setxor(str2num(G{1,1}),str2num(E{T{n,2},1})))),' '));    
    end
    if  Q(T{n,2},2)==0 && Q(T{n,3},2)==1
        G{1,1}=num2str(intersect(str2num(E{T{n,3},1}),str2num(E{T{n,2},1})));
        E{T{n,4},1}=char(horzcat(num2str(E{T{n,4},1}),' ',(num2str(setxor(str2num(G{1,1}),str2num(E{T{n,3},1})))),' '));      
    end
end
end
for n=1:1:size(T,1)
if strcmp(T(n,1),'NAND')==1 && Q(T{n,2},2)~=9999 && Q(T{n,3},2)~=9999
    Q(T{n,4},2)=Q(T{n,2},2).*Q(T{n,3},2);
    if Q(T{n,4},2)==0
        Q(T{n,4},2)=1;
    else
        Q(T{n,4},2)=0;
    end
    H{1,1}=char(horzcat(num2str(Q(T{n,4},1)),num2str(Q(T{n,4},2))));
    K{1,1}=num2str(intersect(str2num(E{T{n,4},1}),str2num(H{1,1})));
    E{T{n,4},1}=char(num2str(setxor(str2num(E{T{n,4},1}),str2num(K{1,1}))));
%     fault
    if Q(T{n,2},2)==0 && Q(T{n,3},2)==0
        E{T{n,4},1}=char(horzcat(num2str(E{T{n,4},1}),' ',(num2str(intersect(str2num(E{T{n,3},1}),str2num(E{T{n,2},1})))),' '));
    end
    if Q(T{n,2},2)==1 && Q(T{n,3},2)==1
        E{T{n,4},1}=char(horzcat(num2str(E{T{n,4},1}),' ',num2str(E{T{n,3},1}),' ',num2str(E{T{n,2},1}),' '));
    end
    if Q(T{n,2},2)==0 && Q(T{n,3},2)==1
        G{1,1}=num2str(intersect(str2num(E{T{n,3},1}),str2num(E{T{n,2},1})));
        E{T{n,4},1}=char(horzcat(num2str(E{T{n,4},1}),' ',(num2str(setxor(str2num(G{1,1}),str2num(E{T{n,2},1})))),' '));    
    end
    if  Q(T{n,2},2)==1 && Q(T{n,3},2)==0
        G{1,1}=num2str(intersect(str2num(E{T{n,3},1}),str2num(E{T{n,2},1})));
        E{T{n,4},1}=char(horzcat(num2str(E{T{n,4},1}),' ',(num2str(setxor(str2num(G{1,1}),str2num(E{T{n,3},1})))),' '));      
    end
end
end
for n=1:1:size(T,1)
if strcmp(T(n,1),'NOR')==1 && Q(T{n,2},2)~=9999 && Q(T{n,3},2)~=9999
    Q(T{n,4},2)=Q(T{n,2},2)+Q(T{n,3},2);
    if Q(T{n,4},2)==2
        Q(T{n,4},2)=1;
    end
    if Q(T{n,4},2)==0
        Q(T{n,4},2)=1;
    else
        Q(T{n,4},2)=0;
    end
    H{1,1}=char(horzcat(num2str(Q(T{n,4},1)),num2str(Q(T{n,4},2))));
    K{1,1}=num2str(intersect(str2num(E{T{n,4},1}),str2num(H{1,1})));
    E{T{n,4},1}=char(num2str(setxor(str2num(E{T{n,4},1}),str2num(K{1,1}))));
    % fault
    if Q(T{n,2},2)==1 && Q(T{n,3},2)==1
        E{T{n,4},1}=char(horzcat(num2str(E{T{n,4},1}),' ',(num2str(intersect(str2num(E{T{n,3},1}),str2num(E{T{n,2},1})))),' '));
    end
    if Q(T{n,2},2)==0 && Q(T{n,3},2)==0
        E{T{n,4},1}=char(horzcat(num2str(E{T{n,4},1}),' ',num2str(E{T{n,3},1}),' ',num2str(E{T{n,2},1}),' '));
    end
    if Q(T{n,2},2)==1 && Q(T{n,3},2)==0
        G{1,1}=num2str(intersect(str2num(E{T{n,3},1}),str2num(E{T{n,2},1})));
        E{T{n,4},1}=char(horzcat(num2str(E{T{n,4},1}),' ',(num2str(setxor(str2num(G{1,1}),str2num(E{T{n,2},1})))),' '));    
    end
    if  Q(T{n,2},2)==0 && Q(T{n,3},2)==1
        G{1,1}=num2str(intersect(str2num(E{T{n,3},1}),str2num(E{T{n,2},1})));
        E{T{n,4},1}=char(horzcat(num2str(E{T{n,4},1}),' ',(num2str(setxor(str2num(G{1,1}),str2num(E{T{n,3},1})))),' '));      
    end
end
end
check = size(find(Q==9999),1);
end

% check if outputs are correct
% outputs(:,3)=Q(outputs(:,1),2);
%% remove repeating nodes

% L{1,1}=[4 4 4 4 4 5 6 7 8 8 8];
% L{1,1}=unique(L{1,1},'first');

for i=1:1:size(E,1) %initialize M
M{i,1}={};
end

for i=1:1:size(E,1)
    M{i,1}=num2str(unique(str2num(E{i,1}),'first'));
end

% count number of faults
for i=1:1:size(outputs,1) %initialize N
N{i,1}={};
end

for i=1:1:size(outputs,1)
    N{i,1}=M{outputs(i,1),1};
end

for i=1:1:size(N,1)-1
    N{1,1}=num2str(horzcat(str2num(N{1,1}),str2num(N{i+1,1})));
end

for i=1:1:size(outputs,1)
    N{i,1}=num2str(unique(str2num(N{i,1}),'first'));
end
nCount=nCount+1; %number of test vectors

O{2,1}=(N{1,1});
O{1,1}=num2str(horzcat(str2num(O{1,1}),str2num(O{2,1})));

O{1,1}=num2str(unique(str2num(O{1,1}),'first'));


count=length(str2num(O{1,1}));

p=count/size(Qf,1)*100;

pArray(nCount,1)=count;
pArray(nCount,2)=p;
end %END OF MAIN LOOP

x=1:1:size(pArray,1);
y=pArray(x,2);
plot(x,y,'LineWidth',1,'MarkerSize',5,'Marker','o', 'MarkerFaceColor','g');grid on;
xlabel('Number of Test Vectors');
ylabel('Coverage (%)');
% 
% x = -pi:.1:pi;
% y = sin(x);
% plot(x,y);
% count=0;
% for i =1:1:size(outputs,1)
%     count=count+length(str2num(M{outputs(i,1),1}));
% end