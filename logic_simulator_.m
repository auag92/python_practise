clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%Reading Input File%%%%%%%%%%%%%%%%
fid = fopen('s27.txt','rt'); %for 1st circuit
C = textscan(fid,'%s');
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
