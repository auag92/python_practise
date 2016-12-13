%===============================================
%SO FAR ONLY WORKING FOR ONE PATH!! (try to make array for J to track all paths)
%(OR make a new 'undefined' and use prev algo)
% while isempty(find(outputs(:,:)==J, 1))==1 %solve till J is a PO
%     
%     %get position of J in array b
%     c=[];
%     b=find([T{:,2}]==J);
%     if strcmp([T{:,1}],'OR')||strcmp([T{:,1}],'AND')||strcmp([T{:,1}],'NOR')||strcmp([T{:,1}],'NAND')
%         c=find([T{:,3}]==J);
%     end
%     for i=1:1:size(c,1)
%         b(end+i)=c(i);
%     end
%     %get position of J END
%     
%     for h=1:1:size(b,1)
%         if strcmp(T(b(h),1),'INV')
%             J=T{b(h),3}; %assign J to output node
%             for i=1:1:5
%                 v=find(orderTables==V);
%                 V=ttinv(v);
%             end
%                 
%         elseif strcmp(T(b(h),1),'BUF')
%             J=T{b(h),3}; %assign J to output node, V remains the same
%             
%         elseif strcmp(T(b(h),1),'AND')
%             for i=1:1:5
%                 v=find(orderTables==V);
%                 if isempty(find(c)==J)==0
%                     q=find(orderTables==Q(T{b(h),2},2));%node which isnt V
%                 else
%                     q=find(orderTables==Q(T{b(h),3},2));
%                 end
%                 V=ttand(v,q);
%             end
%             J=T{b(h),4}; %assign J to output node
%             
%         elseif strcmp(T(b(h),1),'OR')           
%             for i=1:1:5
%                 v=find(orderTables==V);
%                 if isempty(find(c)==J)==0
%                     q=find(orderTables==Q(T{b(h),2},2));%node which isnt V
%                 else
%                     q=find(orderTables==Q(T{b(h),3},2));
%                 end
%                 V=ttor(v,q);
%             end
%             J=T{b(h),4}; %assign J to output node
%             
%         elseif strcmp(T(b(h),1),'NAND')
%             for i=1:1:5
%                 v=find(orderTables==V);
%                 if isempty(find(c)==J)==0
%                     q=find(orderTables==Q(T{b(h),2},2));%node which isnt V
%                 else
%                     q=find(orderTables==Q(T{b(h),3},2));
%                 end
%                 V=ttNand(v,q);
%             end
%             J=T{b(h),4}; %assign J to output node
%             
%         else strcmp(T(b(h),1),'NOR')            
%             for i=1:1:5
%                 v=find(orderTables==V);
%                 if isempty(find(c)==J)==0
%                     q=find(orderTables==Q(T{b(h),2},2));%node which isnt V
%                 else
%                     q=find(orderTables==Q(T{b(h),3},2));
%                 end
%                 V=ttNor(v,q);
%             end
%             J=T{b(h),4}; %assign J to output node
%             
%         end
%     end
% end
%===============================================

%previous algo (666 for no value, 'x' is 9999)
% if fault(1,2)==0
%     Q(fault(1,1),2)=80;
%     d=80;
% else
%     Q(fault(1,1),2)=81;
%     d=81;
% end
% 
% check = size(find(Q==666),1);
% while check~=0
%     for n=1:1:size(T,1)
%         if strcmp(T(n,1),'INV')==1 && Q(T{n,2},2)~=666 
%             v=find(orderTables==Q(T{n,2},2));
%             Q(T{n,3},2)=ttinv(v);
%             Q(fault(1,1),2)=d;
%         end
%     end
%     for n=1:1:size(T,1)
%         if strcmp(T(n,1),'BUF')==1 && Q(T{n,2},2)~=666
%             Q(T{n,3},2)=Q(T{n,2},2);
%             Q(fault(1,1),2)=d;
%         end
%     end
%     for n=1:1:size(T,1)
%         if strcmp(T(n,1),'AND')==1 && Q(T{n,2},2)~=666 && Q(T{n,3},2)~=666
%             v=find(orderTables==Q(T{n,2},2));
%             q=find(orderTables==Q(T{n,3},2));
%             Q(T{n,4},2)=ttand(v,q);
%             Q(fault(1,1),2)=d;
%         end
%     end
%     for n=1:1:size(T,1)
%         if strcmp(T(n,1),'OR')==1 && Q(T{n,2},2)~=666 && Q(T{n,3},2)~=666
%             v=find(orderTables==Q(T{n,2},2));
%             q=find(orderTables==Q(T{n,3},2));
%             Q(T{n,4},2)=ttor(v,q);
%             Q(fault(1,1),2)=d;
%         end
%     end
%     for n=1:1:size(T,1)
%         if strcmp(T(n,1),'NAND')==1 && Q(T{n,2},2)~=666 && Q(T{n,3},2)~=666
%             v=find(orderTables==Q(T{n,2},2));
%             q=find(orderTables==Q(T{n,3},2));
%             Q(T{n,4},2)=ttNand(v,q);
%             Q(fault(1,1),2)=d;
%         end
%     end
%     for n=1:1:size(T,1)
%         if strcmp(T(n,1),'NOR')==1 && Q(T{n,2},2)~=666 && Q(T{n,3},2)~=666
%             v=find(orderTables==Q(T{n,2},2));
%             q=find(orderTables==Q(T{n,3},2));
%             Q(T{n,4},2)=ttNor(v,q);
%             Q(fault(1,1),2)=d;
%         end
%     end
%     check = size(find(Q==666),1);
% end
% %check for Dfrontier propagation
% for o=1:1:size(Q,1)
%     if Q(o,2)==80||Q(o,2)==81
%         for o1=1:1:size(T,1)
%             if strcmp(T{o1,1},'AND')||strcmp(T{o1,1},'NAND')||strcmp(T{o1,1},'OR')||strcmp(T{o1,1},'NOR')
%                 if T{o1,2}==Q(o,1)||T{o1,3}==Q(o,1)
%                     if Q(T{o1,4},2)==9999%output of the gate should be undefined
%                         if isempty(find(Dfront(:)==T{o1,4},1))==1%check if gate is not already in Dfrontier
%                             Dfront(end+1)=T{o1,4};%add new gate to Dfrontier
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end
% outputs(:,2)=Q(outputs(:,1),2);
% if isempty(find(outputs(:,2)==80,1))==1||isempty(find(outputs(:,2)==81,1))==1
%     disp(['failure for input ',num2str(inputs1(2,:))]);
% else
%     disp(['success for input ',num2str(inputs1(2,:))]);
% end
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%objectiveCopy

% % if Q(K,2)==9999 
% %     V=not(V);
% %     obj=[K V];
% % else
% %     %select gate from Dfront
% %     if size(Dfront,1)==1
% %         G=Dfront(1);
% %     else
% %         G=randsample(Dfront,1);
% %     end
% %     h=find(OP(:,:)==G);
% %     
% %     % choose one input of gate from the D frontier
% %     if strcmp(T(h,1),'INV')||strcmp(T(h,1),'BUF')%%THIS CASE NEVER COMES
% %         if Q(T{h,2},2)==9999 || Q(T{K,4},2)==666 %check if value is undefined
% %             J=T{h,2};
% %             C=V;
% %         end
% %     else strcmp(T(h,1),'OR')||strcmp(T(h,1),'AND')||strcmp(T(h,1),'NOR')||strcmp(T(h,1),'NAND')
% %         if Q(T{h,2},2)==9999 || Q(T{K,4},2)==666
% %             J=T{h,2};
% %         else %Q(T{h,3},2)==9999
% %             J=T{h,3};
% %         end
% %         % set controlling values of gates
% %         if strcmp(T(h,1),'OR')||strcmp(T(h,1),'NOR')
% %             C=1;
% %         else
% %             C=0;
% %         end
% %     end % choosing ends
% %     obj(1,1)=J;
% %     obj(1,2)=not(C);
% %     K=obj(1,1); %setting [k,v] for backtrace
% %     V=obj(1,2);
% % end
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% % % backtrace copy
% % % Icheck=1;
% % % K1=K;
% % % while Icheck==1 
% % %     while isempty(find(OP(:,:)==K, 1))==0
% % %         h=find(OP(:,:)==K);
% % %         
% % %         if strcmp(T(h,1),'INV')||strcmp(T(h,1),'NAND')||strcmp(T(h,1),'NOR')
% % %             I=1; %inversion parity
% % %         else
% % %             I=0;
% % %         end
% % %         
% % %         % choose one input of gate with op k
% % %         if strcmp(T(h,1),'INV')||strcmp(T(h,1),'BUF')
% % %             if Q(T{h,2},2)==666 || Q(T{h,2},2)==9999%check if value is undefined
% % %                 %             while isempty(find(J1==J,1))==1
% % %                 J=T{h,2};
% % %                 
% % %             end
% % %         else strcmp(T(h,1),'OR')||strcmp(T(h,1),'AND')||strcmp(T(h,1),'NOR')||strcmp(T(h,1),'NAND')
% % %             if (Q(T{h,2},2)==666 || Q(T{h,2},2)==9999) && (Q(T{h,2},2)==666 || Q(T{h,2},2)==9999)
% % %                 J=randsample([T{h,2} T{h,3}],1);
% % %             elseif (Q(T{h,2},2)==666) || (Q(T{h,2},2)==9999)
% % %                 J=T{h,2};
% % %             else %Q(T{h,3},2)==9999
% % %                 J=T{h,3};
% % %             end
% % %         end % choosing ends
% % %         
% % %         V=xor(V,I);
% % %         K=J;
% % %     end
% % %     
% % %     if isempty(J1)==1
% % %         J1(1)=K;
% % %         Icheck=0; %input is not repeated as previously
% % %     else
% % %         if isempty(find(J1==K,1))==1
% % %             J1(end+1)=K;
% % %             Icheck=0; %input is not repeated as previously
% % %         else
% % %             Icheck=1; %input is repeated so find a new input
% % %             K=K1; %retain old value of K
% % %         end
% % %     end
% % % end %for the first while loop
% % % backtrace(1,1)=K;
% % % backtrace(1,2)=V;
% % % J=backtrace(1,1);%setting [j,v] for imply
% % % V=backtrace(1,2);
%}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
%]

% % % % %add fault gate to D-frontier
% % % % for j=1:1:size(T,1)
% % % %     if strcmp(T{j,1},'INV')||strcmp(T{j,1},'BUF')
% % % %         if T{j,2}==K
% % % %             if isempty(Dfront)==1
% % % %                 Dfront(1)=T{j,3};
% % % %             else
% % % %                 Dfront(end+1)=T{j,3};
% % % %             end
% % % %         end
% % % %     else
% % % %         if T{j,2}==K
% % % %             if isempty(Dfront)==1
% % % %                 Dfront(1)=T{j,4};
% % % %             else
% % % %                 Dfront(end+1)=T{j,4};
% % % %             end
% % % %         end
% % % %         if T{j,3}==K
% % % %             if isempty(Dfront)==1
% % % %                 Dfront(1)=T{j,4};
% % % %             else
% % % %                 Dfront(end+1)=T{j,4};
% % % %             end
% % % %         end
% % % %     end
% % % % end
% % Dfront(1)=14; 