if strcmp(T{K,1},'INV')||strcmp(T{K,1},'BUF')
    if Q(T{K,3},2)==9999 || Q(T{K,4},2)==666
        obj(1,1)=T{K,4};
        obj(1,2)=not(V);
        K=obj(1,1); %setting [k,v] for backtrace
        V=obj(1,2);
    end
elseif strcmp(T{K,1},'AND')||strcmp(T{K,1},'OR')||strcmp(T{K,1},'NOR')||strcmp(T{K,1},'NAND')
    if Q(T{K,4},2)==9999 || Q(T{K,4},2)==666
        obj(1,1)=T{K,4};
        obj(1,2)=not(V);
        K=obj(1,1); %setting [k,v] for backtrace
        V=obj(1,2);
    end