function [mat2,result,x_check,XF,DFront,fp,v,count,x_len,test]=podem1(mat,mat2,fault_node,fault_val,pis,DFront,fp,v,in,count,output_nodes,c,x_check,XF,out_length,x_len,pos,test)
% podem1 fnction is essntially the main body of PODEM algorithm which is used recursively to generate
% a test vector for a any given stuck fault in any circuit.
% 
% Working:
%     The function uses other functions like Objective, Backtrace, Imply and X_path_check to check for
%     all the possible conditions for successfull generation of a test vector.
%     
% License to use and modify this code is granted freely to all interested, as long as the 
% original author is referenced and attributed as such. The original author maintains the 
% right to be solely associated with this work.
% 
% Version: 1.0, 12/01/2015
% Author:  C.V. Chaitanya Krishna
% email:   cvchaitanyak7@gmail.com


%CHECKING IF FAULT IS PROPAGATED TO POs%%
for i1=2:size(mat2,2)
    for j2=3:4
        for j1=1:size(mat,1)-2
            if strcmp(mat(size(mat,1),i1),mat(j1,j2))
                mat2{size(mat,1),i1}=mat2{j1,j2};
                if strcmp(mat2{size(mat,1),i1},'d')||strcmp(mat2{size(mat,1),i1},'d_bar')
                    result='success';
                    for k11=2:size(mat2,2)
                        disp(mat2{size(mat2,1)-1,k11})
                    end
                    return;
                end
            end
        end
    end
end

%%%%%%%%%CHECKING FOR X-PATH AFTER FAULT IS ACTIVATED%%%%%%%
for j2=1:size(mat,1)-2
    for j1=2:4
        if strcmp(fault_node,mat{j2,j1})
            if strcmp(mat2{j2,j1},'d') || strcmp(mat2{j2,j1},'d_bar')
                if strcmp(x_check,'x path check failed')
                    disp('x path check failed')
                    result='failure';
                    return;
                end
            end
        end
    end
end

%%%%%%%check if podem is success%%%%%
if strcmp(x_check,'x path check failed')
    disp('x path check failed')
    result='failure';
    return;
end

%%%%%%%%%%%%%OBJECTIVE%%%%%%%%%%%%%%%%%%
[mat2,fp,v]=objective(mat,mat2,fault_node,fault_val,DFront,c,v,fp);
matrev=mat2; %%backing up mat2 to use when reversing decision

%%%%%%%%%%%%%BACKTRACE%%%%%%%%%%%%%%%%%%
[mat2,count,fp,v]=backtrace(mat,mat2,fp,v,output_nodes,in,pis,fault_node,fault_val,count);
vbar=~v; %%backing up vbar to use when reversing decision of setting fp to v

%%%%%%%%%%%%%IMPLY%%%%%%%%%%%%%%%%%%%%%%
[mat2,DFront,XF,test]=imply2(mat2,mat,fault_val,fault_node,XF,test,pis);

%%%%%%%%%%%%%X-PATH CHECK AFTER FAULT IS EXCITED%%%%%%%%%%%%%%%
for j2=1:size(mat,1)-2
    for j1=2:4
        if x_check==0;
            if strcmp(fault_node,mat{j2,j1})
                if strcmp(mat2{j2,j1},'d') || strcmp(mat2{j2,j1},'d_bar')
                    %%%%optional for loop%%%%
                    [x_check,XF,x_len]=x_path_check(mat,mat2,x_check,out_length,XF,DFront,x_len,pos);
                    disp(x_check)
                    break;
                elseif strcmp(mat2{j2,j1},'0')||strcmp(mat2{j2,j1},'1')
                    x_check='x path check failed';
                end
            end
        end
    end
end

%%%%%%%%%%%%%PODEM%%%%%%%%%%%%%%%%%%%%%%
[mat2,result,x_check,XF,DFront,fp,v,count,x_len,test]=podem1(mat,mat2,fault_node,fault_val,pis,DFront,fp,v,in,count,output_nodes,c,x_check,XF,out_length,x_len,pos,test);

%%%checking is podem is successfull%%%
if strcmp(result,'success')
    return
end

%%%%%%%%%%%%%REVERSE DECISION%%%%%%%%%%%
sprintf('Reversing previous PI assignment')
mat2=matrev;%%%setting mat2 to matrev to reverse the previous backtrace
x_check=0;%%%resetting x_check to 0
v=vbar;%%%setting v as vbar to reverse the previous backtrace
[mat2,count]=backtrace(mat,mat2,fp,v,output_nodes,in,pis,fault_node,fault_val,count);
[mat2,DFront,XF,test]=imply2(mat2,mat,(fault_val),fault_node,XF,test,pis);
matx=matrev;%%%backing up matrev so that another combination of PIs can be used if reverse decision fails

%%%%%%%%%%%%%X-PATH CHECK AFTER FAULT IS EXCITED%%%%%%%%%%%%%%%
for j2=1:size(mat,1)-2
    for j1=2:4
        if x_check==0
            if strcmp(fault_node,mat{j2,j1})
                if strcmp(mat2{j2,j1},'d') || strcmp(mat2{j2,j1},'d_bar')
                    %%%optional for loop%%%
                    [x_check,XF,x_len]=x_path_check(mat,mat2,x_check,out_length,XF,DFront,x_len,pos);
                    disp(x_check)
                    break;
                elseif strcmp(mat2{j2,j1},'0')||strcmp(mat2{j2,j1},'1')
                    x_check='x path check failed';
                end
            end
        end
    end
end

%%%%%%%%%%%%%PODEM%%%%%%%%%%%%%%%%%%%%%%
[mat2,result,x_check,XF,DFront,fp,v,count,x_len,test]=podem1(mat,mat2,fault_node,fault_val,pis,DFront,fp,v,in,count,output_nodes,c,x_check,XF,out_length,x_len,pos,test);

%%%%checking if podem is successfull%%%%
if strcmp(result,'success')
    return
end

%%%%assigining x to previous backtraced node%%%%
for j1=1:size(mat,1)-2
    for j2=2:4
        if strcmp(fp,mat{j1,j2})
            matx{j1,j2}='x';
        end
    end
end

%%%%%%%%%%%%%%%ASSIGN X TO PI%%%%%%%%%%%%%
mat2=matx;%%%restoring matx to mat2 to check for remaining PI assignments after reverse decision failed
x_check=0;%%%resetting x_check to 0
[mat2,count]=backtrace(mat,mat2,fp,vbar,output_nodes,in,pis,fault_node,fault_val,count);
[mat2,DFront,XF]=imply2(mat2,mat,(fault_val),fault_node,XF);

result='failure';
return

end
