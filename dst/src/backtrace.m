function[J,V,Q,T,J1,OP]=backtrace(K,V,Q,T,J1,J,OP)

% Icheck=1;
K1=K;
V1=V;
% while Icheck==1

while isempty(find(OP==K, 1))==0
    h=find(OP==K);
    disp('while1');
    if strcmp(T(h,1),'INV')||strcmp(T(h,1),'NAND')||strcmp(T(h,1),'NOR')
        I=1; %inversion parity
    else
        I=0;
    end
    
    % choose one input of gate with op k
    if strcmp(T(h,1),'INV')||strcmp(T(h,1),'BUF')
        if Q(T{h,2},2)==9999%check if value is undefined
            J=T{h,2};
        end
    else %strcmp(T(h,1),'OR')||strcmp(T(h,1),'AND')||strcmp(T(h,1),'NOR')||strcmp(T(h,1),'NAND')
        if (Q(T{h,2},2)==9999) && (Q(T{h,2},2)==9999)
            J=randsample([T{h,2} T{h,3}],1);
        elseif (Q(T{h,2},2)==9999) && (Q(T{h,3},2)~=9999)
            J=T{h,2};
        elseif (Q(T{h,3},2)==9999) && (Q(T{h,2},2)~=9999)
            J=T{h,3};
        end
    end % choosing ends
    
    V=xor(V,I);
    if J==K
        break;
    else
        K=J;
    end
    disp(J);
end

%     if isempty(J1)==1
%         J1(1)=K;
%         Icheck=0; %input is not repeated as previously
%     else
%         if isempty(find(J1==K,1))==1
%             J1(end+1)=K;
%             Icheck=0; %input is not repeated as previously
%         else
%             Icheck=1; %input is repeated so find a new input
%             K=K1; %retain old value of K
%             V=V1; %retain old value of V
%         end
%     end
% end %for the first while loop
backtrace(1,1)=K;
backtrace(1,2)=V;
J=backtrace(1,1);%setting [j,v] for imply
V=backtrace(1,2);
end