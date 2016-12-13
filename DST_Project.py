import networkx as nx
import random
G=nx.Graph()
B=nx.Graph()
print("MENU")
print("*******")
print("1. Logic Simulator")
print("2. Deductive Fault Simulator")
print("3. Fault Coverage")
print("4. PODEM")
op=input("Enter your option")

if(int(op)==1 or int(op)==2 or int(op)==3):
    if(int(op)==1 or int(op)==2):
        ip=input('Enter Input Vector\n')
        invec=list(ip)
    op1=0
    if(int(op)==2):
        print("1. Print all faults")
        print("2. Print faults from file")
        op1=input("Enter your option")
        
    temp=0
    run=1;
    print("\n")
    if(int(op1)==2):
        with open("C:/Users/Aman Sidana/Desktop/GT Study Material/DST/T-Square/Project/Part1/stuckat.txt") as f1:
            lines1=f1.readlines()
            gates1=[]
            values1=[]
            for i in range(len(lines1)):
                words1=lines1[i].split()
                gates1.append(words1[0])
                values1.append(words1[1])
            
    with open("C:/Users/Aman Sidana/Desktop/GT Study Material/DST/T-Square/Project/Part1/s298f_2.txt") as f:   
        lines=f.readlines()
        w=lines[len(lines)-2].split()#inputs are split
        l=lines[len(lines)-1].split()#outputs are split
        for i in range(len(lines)-2):
            words=lines[i].split()
            if len(words)==3:
                for x in range(len(words)):
                    G.add_node(i, opv =5, ipv=5, trav=0)
                    B.add_node(i, opv =5, ipv=5)
                    if x==0:
                        G.node[i]['type']=words[x]
                        B.node[i]['type']=words[x]
                    if x==1:
                        G.node[i]['ip']=words[x]
                        B.node[i]['ip']=words[x]
                        if (int(words[x])>temp):
                            temp=int(words[x])
                    if x==2:
                        G.node[i]['op']=words[x]
                        B.node[i]['op']=words[x]
                        if (int(words[x])>temp):
                            temp=int(words[x])
            if len(words)==4:
                G.add_node(i, opv =5, ip1v=5, ip2v=5, trav=0)
                B.add_node(i, opv =5, ip1v=5, ip2v=5)
                for x in range(len(words)):
                    if x==0:
                        G.node[i]['type']=words[x]
                        B.node[i]['type']=words[x]
                    if x==1:
                        G.node[i]['ip1']=words[x]
                        B.node[i]['ip1']=words[x]
                        if (int(words[x])>temp):
                            temp=int(words[x])
                    if x==2:
                        G.node[i]['ip2']=words[x]
                        B.node[i]['ip2']=words[x]
                        if (int(words[x])>temp):
                            temp=int(words[x])
                    if x==3:
                        G.node[i]['op']=words[x]
                        B.node[i]['op']=words[x]
                        if (int(words[x])>temp):
                            temp=int(words[x])
       
        #G.add_node(len(lines)-2)
      
        
        
        
                        
    
        
                 
        
    #............................................................................................#
        arr = [[] for _ in range(temp+3)]
        check =0;
        arro = [[] for _ in range(temp+3)]
        arrfcv = [[] for _ in range(temp+3)]
        arrfcn = []
        count=0
        flag=0
        #print("arrfcn",arrfcn)
        #print("initial arr",arr)
        stop=0
        while(stop!=1):
            
            if(int(op)==3):
                ip=''
                for i in range (1,len(w)-1):
                    ip+=str(random.randint(1,100)%2)
            #ip=str(1110101)
            invec=list(ip)
            #print(ip)
            
            for y in range(1,len(w)-1):
                for x in range (len(lines)-2):    
                    if(G.node[x]['type']=='INV' or G.node[x]['type']=='BUF'):
                        if(w[y]==G.node[x]['ip']):
                            G.node[x]['ipv'] = invec[y-1]
                    if(B.node[x]['type']=='INV' or B.node[x]['type']=='BUF'):
                        if(w[y]==B.node[x]['ip']):
                            B.node[x]['ipv'] = invec[y-1]
                    if(G.node[x]['type']!='INV' and G.node[x]['type']!='BUF'):
                        if(w[y]==G.node[x]['ip1']):
                            G.node[x]['ip1v'] = invec[y-1]
                        if(w[y]==G.node[x]['ip2']):
                            G.node[x]['ip2v'] = invec[y-1]
                    if(B.node[x]['type']!='INV' and B.node[x]['type']!='BUF'):
                        if(w[y]==B.node[x]['ip1']):
                            B.node[x]['ip1v'] = invec[y-1]
                        if(w[y]==B.node[x]['ip2']):
                            B.node[x]['ip2v'] = invec[y-1]
        
            for b in range (0, 300):
                for i in range(len(lines)-2):
                    if(G.node[i]['type']=='INV'):
                        if(int(G.node[i]['opv'])==5 and int(G.node[i]['ipv'])!=5 and G.node[i]['trav']==0):
                            G.node[i]['trav']=1
                            if (int(G.node[i]['ipv'])==1):
                                G.node[i]['opv']=0
                                ipn=int(G.node[i]['ip'])
                                opn=int(G.node[i]['op'])
                                if(arr[ipn].count(ipn+100)!=1):
                                    arr[ipn].append(ipn+100)
                                    arr[ipn].append(0)
                                for q in range (len(arr[ipn])):
                                    arr[opn].append(arr[ipn][q])
                                arr[opn].append(opn+100)
                                arr[opn].append(1)
    
                            if (int(G.node[i]['ipv'])==0):
                                G.node[i]['opv']=1
                                ipn=int(G.node[i]['ip'])
                                opn=int(G.node[i]['op'])
                                if(arr[ipn].count(ipn+100)!=1):
                                    arr[ipn].append(ipn+100)
                                    arr[ipn].append(1)
                                for q in range (len(arr[ipn])):
                                    arr[opn].append(arr[ipn][q])
                                arr[opn].append(opn+100)
                                arr[opn].append(0)
    
    
    
                    if(G.node[i]['type']=='BUF'):
                        if(int(G.node[i]['opv'])==5 and int(G.node[i]['ipv'])!=5 and G.node[i]['trav']==0):
                            G.node[i]['trav']=1
                            if (int(G.node[i]['ipv'])==1):
                                G.node[i]['opv']=1
                                ipn=int(G.node[i]['ip'])
                                opn=int(G.node[i]['op'])
                                if(arr[ipn].count(ipn+100)!=1):
                                    arr[ipn].append(ipn+100)
                                    arr[ipn].append(0)
                                for q in range (len(arr[ipn])):
                                    arr[opn].append(arr[ipn][q])
                                arr[opn].append(opn+100)
                                arr[opn].append(0)
    
                            if (int(G.node[i]['ipv'])==0):
                                G.node[i]['opv']=0
                                ipn=int(G.node[i]['ip'])
                                opn=int(G.node[i]['op'])
                                if(arr[ipn].count(ipn+100)!=1):
                                    arr[ipn].append(ipn+100)
                                    arr[ipn].append(1)
                                for q in range (len(arr[ipn])):
                                    arr[opn].append(arr[ipn][q])
                                arr[opn].append(opn+100)
                                arr[opn].append(1)
    
    
    
                    if(G.node[i]['type']=='AND'):
                        if(int(G.node[i]['opv'])==5 and int(G.node[i]['ip1v'])!=5 and int(G.node[i]['ip2v'])!=5 and G.node[i]['trav']==0):
                            G.node[i]['trav']=1
    
                            if (int(G.node[i]['ip1v'])==1 and int(G.node[i]['ip2v'])==1):
                                G.node[i]['opv']=1
                                ip1n=int(G.node[i]['ip1'])
                                ip2n=int(G.node[i]['ip2'])
                                opn=int(G.node[i]['op'])
    
                                if(arr[ip1n].count(ip1n+100)!=1):
                                    arr[ip1n].append(ip1n+100)
                                    arr[ip1n].append(0)
    
                                if(arr[ip2n].count(ip2n+100)!=1):
                                    arr[ip2n].append(ip2n+100)
                                    arr[ip2n].append(0)
    
                                for q in range (len(arr[ip1n])):
                                    arr[opn].append(arr[ip1n][q])
                                for q in range (len(arr[ip2n])):
                                    if(arr[opn].count(arr[ip2n][q])!=1 and arr[ip2n][q]!=1 and arr[ip2n][q]!=0):
                                        arr[opn].append(arr[ip2n][q])
                                        arr[opn].append(arr[ip2n][q+1])
                                arr[opn].append(opn+100)
                                arr[opn].append(0)
    
    
    
                            if (int(G.node[i]['ip1v'])==1 and int(G.node[i]['ip2v'])==0):
                                G.node[i]['opv']=0
                                ip1n=int(G.node[i]['ip1'])
                                ip2n=int(G.node[i]['ip2'])
                                opn=int(G.node[i]['op'])
    
                                if(arr[ip1n].count(ip1n+100)!=1):
                                    arr[ip1n].append(ip1n+100)
                                    arr[ip1n].append(0)
    
                                if(arr[ip2n].count(ip2n+100)!=1):
                                    arr[ip2n].append(ip2n+100)
                                    arr[ip2n].append(1)
    
                                for q in range (len(arr[ip2n])):
                                    if(arr[ip1n].count(arr[ip2n][q])!=1 and arr[ip2n][q]!=1 and arr[ip2n][q]!=0):
                                        arr[opn].append(arr[ip2n][q])
                                        arr[opn].append(arr[ip2n][q+1])
                                arr[opn].append(opn+100)
                                arr[opn].append(1)
    
    
                            if (int(G.node[i]['ip1v'])==0 and int(G.node[i]['ip2v'])==1):
                                G.node[i]['opv']=0
                                ip1n=int(G.node[i]['ip1'])
                                ip2n=int(G.node[i]['ip2'])
                                opn=int(G.node[i]['op'])
    
                                if(arr[ip1n].count(ip1n+100)!=1):
                                    arr[ip1n].append(ip1n+100)
                                    arr[ip1n].append(1)
    
                                if(arr[ip2n].count(ip2n+100)!=1):
                                    arr[ip2n].append(ip2n+100)
                                    arr[ip2n].append(0)
    
                                for q in range (len(arr[ip1n])):
                                    if(arr[ip2n].count(arr[ip1n][q])!=1 and arr[ip1n][q]!=1 and arr[ip1n][q]!=0):
                                        arr[opn].append(arr[ip1n][q])
                                        arr[opn].append(arr[ip1n][q+1])
                                arr[opn].append(opn+100)
                                arr[opn].append(1)
    
    
                            if (int(G.node[i]['ip1v'])==0 and int(G.node[i]['ip2v'])==0):
                                G.node[i]['opv']=0
                                ip1n=int(G.node[i]['ip1'])
                                ip2n=int(G.node[i]['ip2'])
                                opn=int(G.node[i]['op'])
    
                                if(arr[ip1n].count(ip1n+100)!=1):
                                    arr[ip1n].append(ip1n+100)
                                    arr[ip1n].append(1)
    
                                if(arr[ip2n].count(ip2n+100)!=1):
                                    arr[ip2n].append(ip2n+100)
                                    arr[ip2n].append(1)
    
                                for q in range (len(arr[ip1n])):
                                    if(arr[ip2n].count(arr[ip1n][q])==1 and arr[ip1n][q]!=1 and arr[ip1n][q]!=0):
                                        arr[opn].append(arr[ip1n][q])
                                        arr[opn].append(arr[ip1n][q+1])
                                arr[opn].append(opn+100)
                                arr[opn].append(1)
    
    
    
    
                    if(G.node[i]['type']=='NAND'):
                        if(int(G.node[i]['opv'])==5 and int(G.node[i]['ip1v'])!=5 and int(G.node[i]['ip2v'])!=5 and G.node[i]['trav']==0):
                            G.node[i]['trav']=1
    
                            if (int(G.node[i]['ip1v'])==1 and int(G.node[i]['ip2v'])==1):
                                G.node[i]['opv']=0
                                ip1n=int(G.node[i]['ip1'])
                                ip2n=int(G.node[i]['ip2'])
                                opn=int(G.node[i]['op'])
    
                                if(arr[ip1n].count(ip1n+100)!=1):
                                    arr[ip1n].append(ip1n+100)
                                    arr[ip1n].append(0)
    
                                if(arr[ip2n].count(ip2n+100)!=1):
                                    arr[ip2n].append(ip2n+100)
                                    arr[ip2n].append(0)
    
                                for q in range (len(arr[ip1n])):
                                    arr[opn].append(arr[ip1n][q])
                                for q in range (len(arr[ip2n])):
                                    if(arr[opn].count(arr[ip2n][q])!=1 and arr[ip2n][q]!=1 and arr[ip2n][q]!=0):
                                        arr[opn].append(arr[ip2n][q])
                                        arr[opn].append(arr[ip2n][q+1])
                                arr[opn].append(opn+100)
                                arr[opn].append(1)
    
    
    
                            if (int(G.node[i]['ip1v'])==1 and int(G.node[i]['ip2v'])==0):
                                G.node[i]['opv']=1
                                ip1n=int(G.node[i]['ip1'])
                                ip2n=int(G.node[i]['ip2'])
                                opn=int(G.node[i]['op'])
    
                                if(arr[ip1n].count(ip1n+100)!=1):
                                    arr[ip1n].append(ip1n+100)
                                    arr[ip1n].append(0)
    
                                if(arr[ip2n].count(ip2n+100)!=1):
                                    arr[ip2n].append(ip2n+100)
                                    arr[ip2n].append(1)
    
                                for q in range (len(arr[ip2n])):
                                    if(arr[ip1n].count(arr[ip2n][q])!=1 and arr[ip2n][q]!=1 and arr[ip2n][q]!=0):
                                        arr[opn].append(arr[ip2n][q])
                                        arr[opn].append(arr[ip2n][q+1])
                                arr[opn].append(opn+100)
                                arr[opn].append(0)
    
    
                            if (int(G.node[i]['ip1v'])==0 and int(G.node[i]['ip2v'])==1):
                                G.node[i]['opv']=1
                                ip1n=int(G.node[i]['ip1'])
                                ip2n=int(G.node[i]['ip2'])
                                opn=int(G.node[i]['op'])
    
                                if(arr[ip1n].count(ip1n+100)!=1):
                                    arr[ip1n].append(ip1n+100)
                                    arr[ip1n].append(1)
    
                                if(arr[ip2n].count(ip2n+100)!=1):
                                    arr[ip2n].append(ip2n+100)
                                    arr[ip2n].append(0)
    
                                for q in range (len(arr[ip1n])):
                                    if(arr[ip2n].count(arr[ip1n][q])!=1 and arr[ip1n][q]!=1 and arr[ip1n][q]!=0):
                                        arr[opn].append(arr[ip1n][q])
                                        arr[opn].append(arr[ip1n][q+1])
                                arr[opn].append(opn+100)
                                arr[opn].append(0)
    
    
                            if (int(G.node[i]['ip1v'])==0 and int(G.node[i]['ip2v'])==0):
                                G.node[i]['opv']=1
                                ip1n=int(G.node[i]['ip1'])
                                ip2n=int(G.node[i]['ip2'])
                                opn=int(G.node[i]['op'])
    
                                if(arr[ip1n].count(ip1n+100)!=1):
                                    arr[ip1n].append(ip1n+100)
                                    arr[ip1n].append(1)
    
                                if(arr[ip2n].count(ip2n+100)!=1):
                                    arr[ip2n].append(ip2n+100)
                                    arr[ip2n].append(1)
    
                                for q in range (len(arr[ip1n])):
                                    if(arr[ip2n].count(arr[ip1n][q])==1 and arr[ip1n][q]!=1 and arr[ip1n][q]!=0):
                                        arr[opn].append(arr[ip1n][q])
                                        arr[opn].append(arr[ip1n][q+1])
                                arr[opn].append(opn+100)
                                arr[opn].append(0)
    
    
                    if(G.node[i]['type']=='OR'):
                        if(int(G.node[i]['opv'])==5 and int(G.node[i]['ip1v'])!=5 and int(G.node[i]['ip2v'])!=5 and G.node[i]['trav']==0):
                            G.node[i]['trav']=1
    
                            if (int(G.node[i]['ip1v'])==1 and int(G.node[i]['ip2v'])==1):
                                G.node[i]['opv']=1
                                ip1n=int(G.node[i]['ip1'])
                                ip2n=int(G.node[i]['ip2'])
                                opn=int(G.node[i]['op'])
    
                                if(arr[ip1n].count(ip1n+100)!=1):
                                    arr[ip1n].append(ip1n+100)
                                    arr[ip1n].append(0)
    
                                if(arr[ip2n].count(ip2n+100)!=1):
                                    arr[ip2n].append(ip2n+100)
                                    arr[ip2n].append(0)
    
                                for q in range (len(arr[ip1n])):
                                    if(arr[ip2n].count(arr[ip1n][q])==1 and arr[ip1n][q]!=1 and arr[ip1n][q]!=0):
                                        arr[opn].append(arr[ip1n][q])
                                        arr[opn].append(arr[ip1n][q+1])
                                arr[opn].append(opn+100)
                                arr[opn].append(0)
    
    
    
                            if (int(G.node[i]['ip1v'])==1 and int(G.node[i]['ip2v'])==0):
                                G.node[i]['opv']=1
                                ip1n=int(G.node[i]['ip1'])
                                ip2n=int(G.node[i]['ip2'])
                                opn=int(G.node[i]['op'])
    
                                if(arr[ip1n].count(ip1n+100)!=1):
                                    arr[ip1n].append(ip1n+100)
                                    arr[ip1n].append(0)
    
                                if(arr[ip2n].count(ip2n+100)!=1):
                                    arr[ip2n].append(ip2n+100)
                                    arr[ip2n].append(1)
    
                                for q in range (len(arr[ip1n])):
                                    if(arr[ip2n].count(arr[ip1n][q])!=1 and arr[ip1n][q]!=1 and arr[ip1n][q]!=0):
                                        arr[opn].append(arr[ip1n][q])
                                        arr[opn].append(arr[ip1n][q+1])
                                arr[opn].append(opn+100)
                                arr[opn].append(0)
    
                            if (int(G.node[i]['ip1v'])==0 and int(G.node[i]['ip2v'])==1):
                                G.node[i]['opv']=1
                                ip1n=int(G.node[i]['ip1'])
                                ip2n=int(G.node[i]['ip2'])
                                opn=int(G.node[i]['op'])
    
                                if(arr[ip1n].count(ip1n+100)!=1):
                                    arr[ip1n].append(ip1n+100)
                                    arr[ip1n].append(1)
    
                                if(arr[ip2n].count(ip2n+100)!=1):
                                    arr[ip2n].append(ip2n+100)
                                    arr[ip2n].append(0)
    
                                for q in range (len(arr[ip2n])):
                                    if(arr[ip1n].count(arr[ip2n][q])!=1 and arr[ip2n][q]!=1 and arr[ip2n][q]!=0):
                                        arr[opn].append(arr[ip2n][q])
                                        arr[opn].append(arr[ip2n][q+1])
                                arr[opn].append(opn+100)
                                arr[opn].append(0)
    
    
                            if (int(G.node[i]['ip1v'])==0 and int(G.node[i]['ip2v'])==0):
                                G.node[i]['opv']=0
                                ip1n=int(G.node[i]['ip1'])
                                ip2n=int(G.node[i]['ip2'])
                                opn=int(G.node[i]['op'])
    
                                if(arr[ip1n].count(ip1n+100)!=1):
                                    arr[ip1n].append(ip1n+100)
                                    arr[ip1n].append(1)
    
                                if(arr[ip2n].count(ip2n+100)!=1):
                                    arr[ip2n].append(ip2n+100)
                                    arr[ip2n].append(1)
    
                                for q in range (len(arr[ip1n])):
                                    arr[opn].append(arr[ip1n][q])
                                for q in range (len(arr[ip2n])):
                                    if(arr[opn].count(arr[ip2n][q])!=1 and arr[ip2n][q]!=1 and arr[ip2n][q]!=0):
                                        arr[opn].append(arr[ip2n][q])
                                        arr[opn].append(arr[ip2n][q+1])
                                arr[opn].append(opn+100)
                                arr[opn].append(1)
    
    
    
                    if(G.node[i]['type']=='NOR'):
                        if(int(G.node[i]['opv'])==5 and int(G.node[i]['ip1v'])!=5 and int(G.node[i]['ip2v'])!=5 and G.node[i]['trav']==0):
                            G.node[i]['trav']=1
    
                            if (int(G.node[i]['ip1v'])==1 and int(G.node[i]['ip2v'])==1):
                                G.node[i]['opv']=0
                                ip1n=int(G.node[i]['ip1'])
                                ip2n=int(G.node[i]['ip2'])
                                opn=int(G.node[i]['op'])
    
                                if(arr[ip1n].count(ip1n+100)!=1):
                                    arr[ip1n].append(ip1n+100)
                                    arr[ip1n].append(0)
    
                                if(arr[ip2n].count(ip2n+100)!=1):
                                    arr[ip2n].append(ip2n+100)
                                    arr[ip2n].append(0)
    
                                for q in range (len(arr[ip1n])):
                                    if(arr[ip2n].count(arr[ip1n][q])==1 and arr[ip1n][q]!=1 and arr[ip1n][q]!=0):
                                        arr[opn].append(arr[ip1n][q])
                                        arr[opn].append(arr[ip1n][q+1])
                                arr[opn].append(opn+100)
                                arr[opn].append(1)
    
    
    
                            if (int(G.node[i]['ip1v'])==1 and int(G.node[i]['ip2v'])==0):
                                G.node[i]['opv']=0
                                ip1n=int(G.node[i]['ip1'])
                                ip2n=int(G.node[i]['ip2'])
                                opn=int(G.node[i]['op'])
    
                                if(arr[ip1n].count(ip1n+100)!=1):
                                    arr[ip1n].append(ip1n+100)
                                    arr[ip1n].append(0)
    
                                if(arr[ip2n].count(ip2n+100)!=1):
                                    arr[ip2n].append(ip2n+100)
                                    arr[ip2n].append(1)
    
                                for q in range (len(arr[ip1n])):
                                    if(arr[ip2n].count(arr[ip1n][q])!=1 and arr[ip1n][q]!=1 and arr[ip1n][q]!=0):
                                        arr[opn].append(arr[ip1n][q])
                                        arr[opn].append(arr[ip1n][q+1])
                                arr[opn].append(opn+100)
                                arr[opn].append(1)
    
                            if (int(G.node[i]['ip1v'])==0 and int(G.node[i]['ip2v'])==1):
                                G.node[i]['opv']=0
                                ip1n=int(G.node[i]['ip1'])
                                ip2n=int(G.node[i]['ip2'])
                                opn=int(G.node[i]['op'])
    
                                if(arr[ip1n].count(ip1n+100)!=1):
                                    arr[ip1n].append(ip1n+100)
                                    arr[ip1n].append(1)
    
                                if(arr[ip2n].count(ip2n+100)!=1):
                                    arr[ip2n].append(ip2n+100)
                                    arr[ip2n].append(0)
    
                                for q in range (len(arr[ip2n])):
                                    if(arr[ip1n].count(arr[ip2n][q])!=1 and arr[ip2n][q]!=1 and arr[ip2n][q]!=0):
                                        arr[opn].append(arr[ip2n][q])
                                        arr[opn].append(arr[ip2n][q+1])
                                arr[opn].append(opn+100)
                                arr[opn].append(1)
    
    
                            if (int(G.node[i]['ip1v'])==0 and int(G.node[i]['ip2v'])==0):
                                G.node[i]['opv']=1
                                ip1n=int(G.node[i]['ip1'])
                                ip2n=int(G.node[i]['ip2'])
                                opn=int(G.node[i]['op'])
    
                                if(arr[ip1n].count(ip1n+100)!=1):
                                    arr[ip1n].append(ip1n+100)
                                    arr[ip1n].append(1)
    
                                if(arr[ip2n].count(ip2n+100)!=1):
                                    arr[ip2n].append(ip2n+100)
                                    arr[ip2n].append(1)
    
                                for q in range (len(arr[ip1n])):
                                    arr[opn].append(arr[ip1n][q])
                                for q in range (len(arr[ip2n])):
                                    if(arr[opn].count(arr[ip2n][q])!=1 and arr[ip2n][q]!=1 and arr[ip2n][q]!=0):
                                        arr[opn].append(arr[ip2n][q])
                                        arr[opn].append(arr[ip2n][q+1])
                                arr[opn].append(opn+100)
                                arr[opn].append(0)
    
    
    
                    for j in range(len(lines)-2):
                        if(G.node[j]['type']=='INV' or G.node[j]['type']=='BUF'):
                            if(G.node[i]['op']==G.node[j]['ip']):
                                G.node[j]['ipv']=G.node[i]['opv']
                        if(G.node[j]['type']!='INV' and G.node[j]['type']!='BUF'):
                            if(G.node[i]['op']==G.node[j]['ip1']):
                                G.node[j]['ip1v']=G.node[i]['opv']
                            if(G.node[i]['op']==G.node[j]['ip2']):
                                G.node[j]['ip2v']=G.node[i]['opv']
    
                                
                                
                                
                                
                                
                                
    #...........................................FOR Fault Coverage...........................#
            
            #print (G.nodes(data=True))
                
            if(int(op)==1):
                print("\n")
                for x in range(1,len(l)-1):
                    for i in range(len(lines)-2):
                        if l[x]==G.node[i]['op']:
                            print (G.node[i]['opv'],"--for node--",G.node[i]['op'])
            #print("\n") 
            #print(G.nodes(data=True))
            #print (arr)
            for i in range(len(lines)-2):
                if(G.node[i]['type']=='INV' or G.node[i]['type']=='BUF'):
                    G.node[i]['ipv']=5
                    G.node[i]['opv']=5
                    G.node[i]['trav']=0
                else:    
                    G.node[i]['ip1v']=5
                    G.node[i]['opv']=5
                    G.node[i]['ip2v']=5
                    G.node[i]['trav']=0
            
            
    #...........................................^^..........................................#
    
            if(int(op)==2 or int(op)==3):
                for y in range(1,len(l)-1):
                    t=len(arr[int(l[y])])
                    b=int(l[y]) 
                    for q in range (t):
                        if(arr[temp+2].count(arr[b][q]-100)!=1 and arr[b][q]!=1 and arr[b][q]!=0):
                            #print(arr[21].count(arr[b][q]))
                            arr[temp+2].append(arr[b][q]-100)
                            arro[arr[b][q]-100].append(arr[b][q+1])
                            arrfcv[arr[b][q]-100].append(arr[b][q+1])
                            #print ("\n")  
                            #print (arro)
            
            ff=open("outputs",'w')               
            if(int(op)==2 and int(op1)==1):
                arr[temp+2].sort()
                for y in range(len(arr[temp+2])): 
                    print(arr[temp+2][y],"stuck at",arro[arr[temp+2][y]][0])
                    ff.write(str(arr[temp+2][y]))
                    ff.write("stuck at")
                    ff.write(str(arro[arr[temp+2][y]][0]))
                    ff.write('\n')
            
            if(int(op)==2 and int(op1)==2):
                arr[temp+2].sort()
                for y in range(len(arr[temp+2])): 
                    for yy in range(len(gates1)):
                        #print("arr[temp+2][y]",arr[temp+2][y])
                        #print("gates1[yy]",gates1[yy])
                        #print("arro[arr[temp+2][y]][0]",arro[arr[temp+2][y]][0])
                        #print("values1[yy]",values1[yy])
                        aa=int(arr[temp+2][y])
                        bb=int(arro[arr[temp+2][y]][0])
                        cc=int(gates1[yy])
                        dd=int(values1[yy])
                        if(aa==cc and bb==dd):
                            print(arr[temp+2][y],"stuck at",arro[arr[temp+2][y]][0])
                            ff.write(str(arr[temp+2][y]))
                            ff.write("stuck at")
                            ff.write(str(arro[arr[temp+2][y]][0]))
                            ff.write('\n')
            
           
            if(int(op)==1 or int(op)==2):    
                stop=1
            if(int(op)==3):
                for y in range(len(arr[temp+2])): 
                    if(arrfcn.count(arr[temp+2][y])!=2 and arrfcv[arr[temp+2][y]].count(arro[arr[temp+2][y]][0])):
                        arrfcn.append(arr[temp+2][y])
                        arrfcv[arr[temp+2][y]].append(arro[arr[temp+2][y]][0])
                    
                      
    #...................................................^^....................................#        
            
           
            
            
                count=count+1;
                run=0;
            
                print("No. of vectors:",count)
                print("No. of faults detected are:",len(arrfcn))
            
                if((int(len(arrfcn))*100>75*int(temp)*2 or int(len(arrfcn))*100==75*int(temp)*2)and flag==0):
                    print("             75% COVERAGE IS ACHIEVED WITH",count,"VECTORS")
                    flag=1
            
                if((int(len(arrfcn))*100>90*int(temp)*2 or int(len(arrfcn))*100==90*int(temp)*2)):
                    print("             90% COVERAGE IS ACHIEVED WITH",count,"VECTORS")
                    break
                    #stop=1
    
                    
            
                    #print ("old arr=",arr)
            
                del arr[:]
                del arro[:]
                del arrfcv[:]
                #print("del arr=",arr)
                arr = [[] for _ in range(temp+3)]
                arro = [[] for _ in range(temp+3)]
                arrfcv = [[] for _ in range(temp+3)]
                #print("new arr=",arr)
                #break
            
            
            
        
        #print("\n",arr[21])
if(int(op)==4):   
    import networkx as nx
    import random
    G=nx.Graph()
    B=nx.Graph()
    temp=0
    print("\n")
    ipsal=input("Enter the input stuck at line")
    ipsav=input("Enter the input stuck at value")
    if(int(ipsav)==0):
        ipsavo=1
        dordbar=2
    else:
        ipsavo=0
        dordbar=3
    
    
           
        #if (StuckAtLine==int(G.node[i]['ip']) && ):
        #if (int(G.node[i]['opv'])==1 or int(G.node[i]['opv'])==0):
            #incon+=1 
        
        
    with open("C:/Users/Aman Sidana/Desktop/GT Study Material/DST/T-Square/Project/Part1/s27.txt") as f:
        lines=f.readlines()
        w=lines[len(lines)-2].split()#.................................input
        l=lines[len(lines)-1].split()#....................................output
        for i in range(len(lines)-2):
            words=lines[i].split()
            if len(words)==3:
                for x in range(len(words)):
                    G.add_node(i, opv =4, ipv=4, trav=0)
                    B.add_node(i, opv =4, ipv=4)
                    if x==0:
                        G.node[i]['type']=words[x]
                        B.node[i]['type']=words[x]
                    if x==1:
                        G.node[i]['ip']=words[x]
                        B.node[i]['ip']=words[x]
                        #if (int(words[x])>temp):
                            #temp=int(words[x])
                    if x==2:
                        G.node[i]['op']=words[x]
                        B.node[i]['op']=words[x]
                        #if (int(words[x])>temp):
                            #temp=int(words[x])
            if len(words)==4:
                G.add_node(i, opv =4, ip1v=4, ip2v=4, trav=0)
                B.add_node(i, opv =4, ip1v=4, ip2v=4)
                for x in range(len(words)):
                    if x==0:
                        G.node[i]['type']=words[x]
                        B.node[i]['type']=words[x]
                    if x==1:
                        G.node[i]['ip1']=words[x]
                        B.node[i]['ip1']=words[x]
                        #if (int(words[x])>temp):
                            #temp=int(words[x])
                    if x==2:
                        G.node[i]['ip2']=words[x]
                        B.node[i]['ip2']=words[x]
                        #if (int(words[x])>temp):
                            #temp=int(words[x])
                    if x==3:
                        G.node[i]['op']=words[x]
                        B.node[i]['op']=words[x]
                        #if (int(words[x])>temp):
                            #temp=int(words[x])
        
        print(G.nodes(data=True))
        checkincon=-1
        checktnp=-1
        Darr = []
        Dfrontempty=0
        FirstD=0
        
        varri=-1
        statli= int(ipsal)
        for i in range(len(lines)-2):
            if (statli==int(G.node[i]['op'])):
                varri=i
       
            
            
          
        
    #........................................INCON AND TNP START.......................................................#     
        
        def inconsistency():
            StuckAtLine=int(ipsal)
            sav=int(ipsav)
            incon=0
            global Dfrontempty
            for x in range(1,len(l)-1):
                for i in range(len(lines)-2):
                    if l[x]==G.node[i]['op']:
                        if (int(G.node[i]['opv'])==1 or int(G.node[i]['opv'])==0):
                            incon+=1
            print("Dfrontempty=",Dfrontempty)
            if(varri!=-1):
                if (incon==(len(l)-2) or (Dfrontempty==1)and int(G.node[varri]['opv'])==dordbar):
                    print("Failure")
                    return 1
                else:
                    print("Success at incon")
                    return 0
            else:
                if (incon==(len(l)-2)):
                    print("Failure")
                    return 1
                else:
                    print("Success at incon")
                    return 0
                
        def testnotpos():
            StuckAtLine=int(ipsal)
            sav=int(ipsav)
            for i in range(len(lines)-2):
                if(int(G.node[i]['op'])==StuckAtLine):
                    if(int(G.node[i]['opv'])==sav):
                        print("failure")
                        return 1
            print("success at testnotposs")
            return 0
                      
        
    #........................................INCON AND TNP END.......................................................#                 
             
        
        
        
        
        
        
    #.............................................D-FRONT STARTS.......................................................#
        def dfront():
            global Dfrontempty
            Dfrontempty=0
            
            #print("ip1 = ",G.node[19]['ip1'],G.node[19]['ip1v'])
            #print("ip2 = ",G.node[19]['ip2'], G.node[19]['ip2v'])
            #print("op = ",G.node[19]['op'], G.node[19]['opv'])
            #print("ip1 = ",G.node[53]['ip1'],G.node[53]['ip1v'])
            #print("ip2 = ",G.node[53]['ip2'], G.node[53]['ip2v'])
            #print("op = ",G.node[53]['op'], G.node[53]['opv'])
            #print("ip1 = ",G.node[55]['ip1'],G.node[55]['ip1v'])
            #print("ip2 = ",G.node[55]['ip2'], G.node[55]['ip2v'])
            #print("op = ",G.node[55]['op'], G.node[55]['opv'])
            #print("Entering D front")
            for i in range(len(lines)-2):
                if(G.node[i]['type']=='INV' or G.node[i]['type']=='BUF'):
                    if ((int(G.node[i]['ipv'])==2 or int(G.node[i]['ipv'])==3) and int(G.node[i]['opv'])==4):
                        if(Darr.count(i)!=1):
                            Darr.append(i)
                    if (int(G.node[i]['opv'])==2 or int(G.node[i]['opv'])==3):
                        if(Darr.count(i)==1):
                            Darr.remove(i)
                
                else:
                    if ((int(G.node[i]['ip1v'])==2 or int(G.node[i]['ip1v'])==3) and int(G.node[i]['opv'])==4):
                        if(Darr.count(i)!=1):
                            Darr.append(i)
                    
                    if ((int(G.node[i]['ip2v'])==2 or int(G.node[i]['ip2v'])==3) and int(G.node[i]['opv'])==4):
                        if(Darr.count(i)!=1):
                            Darr.append(i)
                            
                    if (int(G.node[i]['opv'])==2 or int(G.node[i]['opv'])==3):
                        if(Darr.count(i)==1):
                            Darr.remove(i)
                           
            print("LenofDarr====",len(Darr),Darr)
            if(varri!=-1):
                if(len(Darr)==0 and int(G.node[varri]['opv'])==dordbar):
                    #global Dfrontempty
                    Dfrontempty=1 
                    print("Dfrontempty==",Dfrontempty)
            else:
                if(len(Darr)==0):
                    #global Dfrontempty
                    Dfrontempty=1 
                    print("Dfrontempty==",Dfrontempty)
            
    #.............................................D-FRONT ENDS.......................................................#
        
                        
    
    
    
    
        
    #.............................................OBJ STARTS.......................................................#
    
        def objective():
            print("Entering objective")
            StuckAtLine=int(ipsal)
            val=ipsavo
            length=0
            gate=-1
            ifpo=0
            
            for i in range(len(lines)-2):
                if(G.node[i]['type']=='INV' or G.node[i]['type']=='BUF'):
                    print("enters inv or buff", G.node[i]['ip'])
                    if (StuckAtLine==int(G.node[i]['ip'])): 
                        print("enters loop sal=ip")
                        print("G.node[i]['ipv']==4",G.node[i]['ipv'])
                        if (int(G.node[i]['ipv'])==4):
                            print("obj return stuck")
                            return (StuckAtLine,val) 
                    if (StuckAtLine==int(G.node[i]['op'])): 
                        print("enters loop sal=op")
                        print("G.node[i]['opv']==4",G.node[i]['opv'])
                        if (int(G.node[i]['opv'])==4):
                            print("obj return stuck")
                            return (StuckAtLine,val) 
                else:
                    print("enters other gates",G.node[i]['ip1'],G.node[i]['ip2'])
                    if (StuckAtLine==int(G.node[i]['ip1'])): 
                        print("enters loop sal=ip1")
                        print("G.node[i]['ip1v']==4",G.node[i]['ip1v'])
                        if (int(G.node[i]['ip1v'])==4):
                            print ("obj return stuck")
                            return (StuckAtLine,val) 
                        
                    if (StuckAtLine==int(G.node[i]['ip2'])): 
                        print("enters loop sal=ip2")
                        print("G.node[i]['ip2v']==4",G.node[i]['ip2v'])
                        if (int(G.node[i]['ip2v'])==4):
                            print ("obj return stuck")
                            return (StuckAtLine,val) 
                    if (StuckAtLine==int(G.node[i]['op'])): 
                        print("enters loop sal=op")
                        print("G.node[i]['opv']==4",G.node[i]['opv'])
                        if (int(G.node[i]['opv'])==4):
                            print("obj return stuck")
                            return (StuckAtLine,val) 
                            
              
            #print(G.node[63]['ip1'],G.node[63]['ip1v'])
            print("LenofDarr=",len(Darr),Darr)
            gate= Darr[len(Darr)-1]
            print("gate=",gate)
            print(G.node[gate]['type'],G.node[gate]['ip1'],G.node[gate]['ip2'])
            #print(G.nodes(data=True))
            if(G.node[gate]['type']=='AND' or G.node[gate]['type']=='NAND'):
                print(G.node[gate]['ip1v'],G.node[gate]['ip2v'])
                if((G.node[gate]['ip1v'])==4):
                    print ("obj return")
                    return(int(G.node[gate]['ip1']),1)
                if(int(G.node[gate]['ip2v'])==4):
                    print ("obj return")
                    return(int(G.node[gate]['ip2']),1)
                
            if(G.node[gate]['type']=='OR' or G.node[gate]['type']=='NOR'):
                if(int(G.node[gate]['ip1v'])==4):
                    print ("obj return")
                    return(int(G.node[gate]['ip1']),0)
                if(int(G.node[gate]['ip2v'])==4):
                    print ("obj return")
                    return(int(G.node[gate]['ip2']),0)     
            
    #.............................................OBJ ENDS.......................................................#
        
    
        
        
    
        
    #.............................................BACKTRACE STARTS.......................................................#
        def backtrace(k,vk):
            print("ENtering backtrace",k,vk)
            stopp=0
            stoppp=0
            line=k
            inv=0
            print('inv=',inv)
            for y in range(1,len(w)-1):
                print("Initial check for PI in backtrace", line, w[y])
                if(line==int(w[y])):
                    stopp=1
            while(stopp!=1):
                print("Entering while of backtrace")
                stoppp=0
                for i in range(len(lines)-2):
                    print("Entering for loop of backtrace")
                    print("----",G.node[i]['op'],line)
                    if(int(G.node[i]['op'])==line):
                        print("??")
                    if (stopp==0 and stoppp==0):
                        #if(G.node[i]['type']=='INV' or G.node[i]['type']=='NOR' or G.node[i]['type']=='NAND'):
                            #inv=inv+1
                            #print("Inversion bit update=",inv)
    
                        if(G.node[i]['type']=='INV' or G.node[i]['type']=='BUF'):
                            print("FOR INV BUF-",G.node[i]['op'],line)
                            if(int(G.node[i]['op'])==line):
                                print("FOR INV BUF-",G.node[i]['ipv'],4)
                                if(int(G.node[i]['ipv'])==4):
                                    line=int(G.node[i]['ip'])
                                    stoppp=1
                                    if(G.node[i]['type']=='INV' or G.node[i]['type']=='NOR' or G.node[i]['type']=='NAND'):
                                        inv=inv+1
                                        print("Inversion bit update=",inv)
                                    print("for inv buf line-", line)
                                    for y in range(1,len(w)-1):
                                        if(line==int(w[y])):
                                            stopp=1
    
                        else:
                            print("FOR others!!-",int(G.node[i]['op']),line)
                            if(int(G.node[i]['op'])==line):
                                print("FOR others inp1-",G.node[i]['ip1v'],4)
                                if(int(G.node[i]['ip1v'])==4):
                                    line=int(G.node[i]['ip1'])
                                    stoppp=1
                                    if(G.node[i]['type']=='INV' or G.node[i]['type']=='NOR' or G.node[i]['type']=='NAND'):
                                        inv=inv+1
                                        print("Inversion bit update=",inv)
                                    print("for others ip1 line-", line)
                                    for y in range(1,len(w)-1):
                                        if(line==int(w[y])):
                                            stopp=1
                                print("FOR others inp2-",G.node[i]['ip2v'],4)
                                if(int(G.node[i]['ip2v'])==4 and stoppp==0):
                                    line=int(G.node[i]['ip2'])
                                    stoppp=1
                                    if(G.node[i]['type']=='INV' or G.node[i]['type']=='NOR' or G.node[i]['type']=='NAND'):
                                        inv=inv+1
                                        print("Inversion bit update=",inv)
                                    print("for others ip2 line-", line)
                                    for y in range(1,len(w)-1):
                                        if(line==int(w[y])):
                                            stopp=1
            
            inv=inv%2
            print(inv)
            if((inv==0 and vk==0 ) or (inv==1 and vk==1)):
                print("backtrace return line,0",line)
                return(line,0)
            else:
                print("backtrace return line,1",line)
                return(line,1)
    
    #.............................................BACKTRACE ENDS.......................................................#
    
    
        
    
    
    #.............................................IMPLY STARTS.......................................................#  
        
        def imply(j,val):
            
            FirstD=0
            print("Entering imply")
            StuckAtLine=int(ipsal)
            vall=ipsavo #stuck at 1
            
                            
            for i in range(len(lines)-2):
                G.node[i]['trav']=0
                if(G.node[i]['type']=='INV' or G.node[i]['type']=='BUF'):
                    G.node[i]['it']=0
                    G.node[i]['ot']=0
                else:
                    G.node[i]['i1t']=0
                    G.node[i]['i2t']=0
                    G.node[i]['ot']=0
                    
            for y in range(1,len(w)-1):
                for x in range (len(lines)-2):    
                    if(G.node[x]['type']=='INV' or G.node[x]['type']=='BUF'):
                        if(w[y]==G.node[x]['ip']):
                            G.node[x]['it']=1
                        if(int(G.node[x]['ip'])==j):
                            G.node[x]['ipv']=val
                    if(G.node[x]['type']!='INV' and G.node[x]['type']!='BUF'):
                        if(w[y]==G.node[x]['ip1']):
                            G.node[x]['i1t']=1
                        if(int(G.node[x]['ip1'])==j):
                            G.node[x]['ip1v']=val
                        if(w[y]==G.node[x]['ip2']):
                            G.node[x]['i2t']=1
                        if(int(G.node[x]['ip2'])==j):
                            G.node[x]['ip2v']=val

            for i in range(len(lines)-2):
                if(int(G.node[i]['op'])==StuckAtLine and FirstD==0):
                    if(int(G.node[i]['opv'])==vall):
                        G.node[i]['opv']=dordbar
                    
                if((G.node[i]['type']=='INV' or G.node[i]['type']=='BUF') and FirstD==0 and int(G.node[i]['ip'])==StuckAtLine):
                    if(int(G.node[i]['ipv']==vall)):
                        G.node[i]['ipv']=dordbar
                            
                if((G.node[i]['type']!='INV' and G.node[i]['type']!='BUF') and FirstD==0):
                    if(int(G.node[i]['ip1v']==vall) and int(G.node[i]['ip1'])==StuckAtLine):
                        G.node[i]['ip1v']=dordbar
                    if(int(G.node[i]['ip2v']==vall) and int(G.node[i]['ip2'])==StuckAtLine):
                        G.node[i]['ip2v']=dordbar
            stop=0
            counttrav=0
            while(stop!=1):
                for i in range(len(lines)-2):
                    entered=0
                    if(G.node[i]['type']=='INV'):
                        if(int(G.node[i]['it'])==1 and int(G.node[i]['ot'])!=1 and int(G.node[i]['trav'])==0):
                            #print("\ngate--",i,G.node[i]['trav'],G.node[i]['type'])
                            if (int(G.node[i]['ipv'])==1):
                                G.node[i]['opv']=0
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ipv'])==0):
                                G.node[i]['opv']=1
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ipv'])==2):
                                G.node[i]['opv']=3
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ipv'])==3):
                                G.node[i]['opv']=2
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ipv'])==4):
                                G.node[i]['opv']=4
                                G.node[i]['ot']=1
                            entered=1
                            G.node[i]['trav']=1
    
    
                    if(G.node[i]['type']=='BUF'):
                        if(int(G.node[i]['it'])==1 and int(G.node[i]['ot'])!=1 and int(G.node[i]['trav'])==0):
                            #print("\ngate--",i,G.node[i]['trav'],G.node[i]['type'])
                            if (int(G.node[i]['ipv'])==1):
                                G.node[i]['opv']=1
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ipv'])==0):
                                G.node[i]['opv']=0
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ipv'])==2):
                                G.node[i]['opv']=2
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ipv'])==3):
                                G.node[i]['opv']=3
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ipv'])==4):
                                G.node[i]['opv']=4
                                G.node[i]['ot']=1
                            entered=1
                            G.node[i]['trav']=1
    
    
                    if(G.node[i]['type']=='AND'):
                        if(int(G.node[i]['ot'])!=1 and int(G.node[i]['i1t'])==1 and int(G.node[i]['i2t'])==1 and int(G.node[i]['trav'])==0):    
                            #print("\ngate--",i,G.node[i]['trav'])
                            if (int(G.node[i]['ip1v'])==0 or int(G.node[i]['ip2v'])==0):
                                G.node[i]['opv']=0
                                G.node[i]['ot']=1   
                            if (int(G.node[i]['ip1v'])==2 and int(G.node[i]['ip2v'])==3):
                                G.node[i]['opv']=0
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==3 and int(G.node[i]['ip2v'])==2):
                                G.node[i]['opv']=0
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==1 and int(G.node[i]['ip2v'])==1):
                                G.node[i]['opv']=1
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==4 and int(G.node[i]['ip2v'])!=0):
                                G.node[i]['opv']=4
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])!=0 and int(G.node[i]['ip2v'])==4):
                                G.node[i]['opv']=4
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==2 and int(G.node[i]['ip2v'])==1):
                                G.node[i]['opv']=2
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==1 and int(G.node[i]['ip2v'])==2):
                                G.node[i]['opv']=2
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==2 and int(G.node[i]['ip2v'])==2):
                                G.node[i]['opv']=2
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==3 and int(G.node[i]['ip2v'])==1):
                                G.node[i]['opv']=3
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==1 and int(G.node[i]['ip2v'])==3):
                                G.node[i]['opv']=3
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==3 and int(G.node[i]['ip2v'])==3):
                                G.node[i]['opv']=3
                                G.node[i]['ot']=1
                            entered=1
                            G.node[i]['trav']=1
    
                    if(G.node[i]['type']=='OR'):
                        if(int(G.node[i]['ot'])!=1 and int(G.node[i]['i1t'])==1 and int(G.node[i]['i2t'])==1 and int(G.node[i]['trav'])==0):
                            #print("\ngate--",i,G.node[i]['trav'])
                            if (int(G.node[i]['ip1v'])==1 or int(G.node[i]['ip2v'])==1):
                                G.node[i]['opv']=1
                                G.node[i]['ot']=1   
                            if (int(G.node[i]['ip1v'])==2 and int(G.node[i]['ip2v'])==3):
                                G.node[i]['opv']=1
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==3 and int(G.node[i]['ip2v'])==2):
                                G.node[i]['opv']=1
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==0 and int(G.node[i]['ip2v'])==0):
                                G.node[i]['opv']=0
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==4 and int(G.node[i]['ip2v'])!=1):
                                G.node[i]['opv']=4
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])!=1 and int(G.node[i]['ip2v'])==4):
                                G.node[i]['opv']=4
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==2 and int(G.node[i]['ip2v'])==0):
                                G.node[i]['opv']=2
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==0 and int(G.node[i]['ip2v'])==2):
                                G.node[i]['opv']=2
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==2 and int(G.node[i]['ip2v'])==2):
                                G.node[i]['opv']=2
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==3 and int(G.node[i]['ip2v'])==0):
                                G.node[i]['opv']=3
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==0 and int(G.node[i]['ip2v'])==3):
                                G.node[i]['opv']=3
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==3 and int(G.node[i]['ip2v'])==3):
                                G.node[i]['opv']=3
                                G.node[i]['ot']=1
                            entered=1
                            G.node[i]['trav']=1
    
                    if(G.node[i]['type']=='NAND'):
                        if(int(G.node[i]['ot'])!=1 and int(G.node[i]['i1t'])==1 and int(G.node[i]['i2t'])==1 and int(G.node[i]['trav'])==0):
                            #print("\ngate--",i,G.node[i]['trav'])
                            if (int(G.node[i]['ip1v'])==0 or int(G.node[i]['ip2v'])==0):
                                G.node[i]['opv']=1
                                G.node[i]['ot']=1   
                            if (int(G.node[i]['ip1v'])==2 and int(G.node[i]['ip2v'])==3):
                                G.node[i]['opv']=1
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==3 and int(G.node[i]['ip2v'])==2):
                                G.node[i]['opv']=1
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==1 and int(G.node[i]['ip2v'])==1):
                                G.node[i]['opv']=0
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==4 and int(G.node[i]['ip2v'])!=0):
                                G.node[i]['opv']=4
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])!=0 and int(G.node[i]['ip2v'])==4):
                                G.node[i]['opv']=4
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==2 and int(G.node[i]['ip2v'])==1):
                                G.node[i]['opv']=3
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==1 and int(G.node[i]['ip2v'])==2):
                                G.node[i]['opv']=3
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==2 and int(G.node[i]['ip2v'])==2):
                                G.node[i]['opv']=3
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==3 and int(G.node[i]['ip2v'])==1):
                                G.node[i]['opv']=2
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==1 and int(G.node[i]['ip2v'])==3):
                                G.node[i]['opv']=2
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==3 and int(G.node[i]['ip2v'])==3):
                                G.node[i]['opv']=2
                                G.node[i]['ot']=1
                            entered=1
                            G.node[i]['trav']=1
    
                    if(G.node[i]['type']=='NOR'):
                        if(int(G.node[i]['ot'])!=1 and int(G.node[i]['i1t'])==1 and int(G.node[i]['i2t'])==1 and int(G.node[i]['trav'])==0):
                            #print("\ngate--",i,G.node[i]['trav'])
                            if (int(G.node[i]['ip1v'])==1 or int(G.node[i]['ip2v'])==1):
                                G.node[i]['opv']=0
                                G.node[i]['ot']=1   
                            if (int(G.node[i]['ip1v'])==2 and int(G.node[i]['ip2v'])==3):
                                G.node[i]['opv']=0
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==3 and int(G.node[i]['ip2v'])==2):
                                G.node[i]['opv']=0
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==0 and int(G.node[i]['ip2v'])==0):
                                G.node[i]['opv']=1
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==4 and int(G.node[i]['ip2v'])!=1):
                                G.node[i]['opv']=4
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])!=1 and int(G.node[i]['ip2v'])==4):
                                G.node[i]['opv']=4
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==2 and int(G.node[i]['ip2v'])==0):
                                G.node[i]['opv']=3
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==0 and int(G.node[i]['ip2v'])==2):
                                G.node[i]['opv']=3
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==2 and int(G.node[i]['ip2v'])==2):
                                G.node[i]['opv']=3
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==3 and int(G.node[i]['ip2v'])==0):
                                G.node[i]['opv']=2
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==0 and int(G.node[i]['ip2v'])==3):
                                G.node[i]['opv']=2
                                G.node[i]['ot']=1
                            if (int(G.node[i]['ip1v'])==3 and int(G.node[i]['ip2v'])==3):
                                G.node[i]['opv']=2
                                G.node[i]['ot']=1
                            entered=1
                            G.node[i]['trav']=1
    
                    
                    
                    if(int(G.node[i]['op'])==StuckAtLine and FirstD==0):
                        if(int(G.node[i]['opv'])==vall):
                            G.node[i]['opv']=dordbar
                            FirstD=1
                    if((G.node[i]['type']=='INV' or G.node[i]['type']=='BUF') and FirstD==0 and int(G.node[i]['ip'])==StuckAtLine):
                        if(int(G.node[i]['ipv']==vall)):
                            G.node[i]['ipv']=dordbar
                            FirstD=1
                            #print("HAHA*************************************************************")
                    if((G.node[i]['type']!='INV' and G.node[i]['type']!='BUF') and FirstD==0):
                        if(int(G.node[i]['ip1v']==vall) and int(G.node[i]['ip1'])==StuckAtLine):
                            G.node[i]['ip1v']=dordbar
                            FirstD=1
                        if(int(G.node[i]['ip2v']==vall) and int(G.node[i]['ip2'])==StuckAtLine):
                            G.node[i]['ip2v']=dordbar
                            FirstD=1
                    
                    if(entered==1):
                        #print("GATE",i,G.node[i]['op'])
                        for j in range(len(lines)-2):
                                if(G.node[j]['type']=='INV' or G.node[j]['type']=='BUF'):
                                    if(G.node[i]['op']==G.node[j]['ip']):
                                        G.node[j]['ipv']=G.node[i]['opv']
                                        G.node[j]['it']=1
                                if(G.node[j]['type']!='INV' and G.node[j]['type']!='BUF'):
                                    if(G.node[i]['op']==G.node[j]['ip1']):
                                        G.node[j]['ip1v']=G.node[i]['opv']
                                        G.node[j]['i1t']=1
                                    if(G.node[i]['op']==G.node[j]['ip2']):
                                        G.node[j]['ip2v']=G.node[i]['opv']
                                        G.node[j]['i2t']=1                    
    
    
                    if(entered==1):
                        counttrav+=1
                        print(counttrav,len(lines)-2)
    
                if(counttrav==len(lines)-2):
                    stop=1
                print("Exiting imply")
                #print(G.node[1]['ipv'])
                #print(G.node[1]['opv'])
                #print(G.node[3]['ip1v'])
                #print(G.node[3]['ip2v'])
                #print(G.node[3]['opv'])
    #.............................................IMPLY ENDS.......................................................#  
    
    
    
    
    
    
    #.............................................PODEM STARTS.......................................................#     
        
        #0 is success
        #1 is failure
        
        def podem():
            k=-1
            j=-1
            vk=-1
            vj=-1
           
            for x in range(1,len(l)-1):
                for i in range(len(lines)-2):
                    if l[x]==G.node[i]['op']:
                        if(int(G.node[i]['opv'])==2 or int(G.node[i]['opv'])==3):
                            print("SUCCESS FAULT AT OP") ##THAT fault is at one of the outputs
                            return 0
        
        
            
            
            checkincon = inconsistency() ## CHECKING INCONSISTENCY
            if (checkincon==1):
                return 1
                
            checktnp = testnotpos() ##CHECKING IF TEST IS POSS OR NOT
            if (checktnp==1):
                return 1
            
            (k,vk)=objective()
            (j,vj)=backtrace(k,vk)
            
            imply(j,vj)                 ## IMPLY FUNCTION
            dfront()                     ## UPDATING D-FRONTIER
            print(G.nodes(data=True))
            print("PIs after impy j,vj*********************************************************")
            for y in range(1,len(w)-1):
              for x in range (len(lines)-2):    
                  if(G.node[x]['type']=='INV' or G.node[x]['type']=='BUF'):
                      if(w[y]==G.node[x]['ip']):
                          print(G.node[x]['ip'],G.node[x]['ipv'])
                          break
                  if(G.node[x]['type']!='INV' and G.node[x]['type']!='BUF'):
                      if(w[y]==G.node[x]['ip1']):
                          print(G.node[x]['ip1'],G.node[x]['ip1v'])
                          break
                      if(w[y]==G.node[x]['ip2']):
                          print(G.node[x]['ip2'],G.node[x]['ip2v'])
                          break
            if (podem()==0):
                print("podem success")
                return 0
            
            if(vj==0):
                vjbar=1
            else:
                vjbar=0
            print("doosra imply")
            imply(j,vjbar)
            print(j,vjbar)
            dfront()
            print(G.nodes(data=True))
            print("***********************************************************************")
            for y in range(1,len(w)-1):
               for x in range (len(lines)-2):    
                   if(G.node[x]['type']=='INV' or G.node[x]['type']=='BUF'):
                       if(w[y]==G.node[x]['ip']):
                           print(G.node[x]['ip'],G.node[x]['ipv'])
                           break
                   if(G.node[x]['type']!='INV' and G.node[x]['type']!='BUF'):
                       if(w[y]==G.node[x]['ip1']):
                           print(G.node[x]['ip1'],G.node[x]['ip1v'])
                           break
                       if(w[y]==G.node[x]['ip2']):
                           print(G.node[x]['ip2'],G.node[x]['ip2v'])
                           break
            if (podem()==0):
                print("podem success")
                return 0
            print("Entering for x")
            imply(j,4)
            dfront()
            print("podem failure")
            return 1
        
    #.............................................PODEM ENDS.......................................................# 
    
    
    
        podemvalue=-1
        podemvalue=podem()
        print(podemvalue)
        if (podemvalue==0):
            print("THE INPUT VECTOR IS:")
            for y in range(1,len(w)-1):
                for x in range (len(lines)-2):    
                    if(G.node[x]['type']=='INV' or G.node[x]['type']=='BUF'):
                        if(w[y]==G.node[x]['ip']):
                            if(int(G.node[x]['ipv'])==4):
                                print(G.node[x]['ip'],"x")
                                break
                            else:
                                print(G.node[x]['ip'],G.node[x]['ipv'])
                                break
                    else:
                        if(w[y]==G.node[x]['ip1']):
                            if(int(G.node[x]['ip1v'])==4):
                                print(G.node[x]['ip1'],"x")
                                break
                            else:
                                print(G.node[x]['ip1'],G.node[x]['ip1v'])
                                break
                        
                        if(w[y]==G.node[x]['ip2']):
                            if(int(G.node[x]['ip2v'])==4):
                                print(G.node[x]['ip2'],"x")
                                break
                            else:
                                print(G.node[x]['ip2'],G.node[x]['ip2v'])
                                break
        
        if(podemvalue==1):
            print("FAULT NOT DETECTED")
           
            
            
        