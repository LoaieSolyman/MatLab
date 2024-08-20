sa=0.01;
tau_max=0.15;
simt=10;
t=0:sa:simt;
s=0:sa:simt;
d=[0.1 0.9;0.05 0.95];
for i=1:size(d,1)
    for j=2:size(d,2)
        d(i,j)=d(i,j)+d(i,j-1);
    end
end
d=[zeros(size(d,1),1),d];
d0=tau_max-sa*5;
d1=sa;
s0=2;
r=zeros(size(s));
out=zeros(size(s));
tout1=[];
tout2=[];
r(1)=d0;
y=0;
r0=0;
a=0;
b=0;
for i=2:size(s,2)
    u=rand;
    for j=2:size(d,1)+1
        if u<d(s0,j) && u>d(s0,j-1) && j==2
            y=-1;
            s0=1;
        else
            if u<d(s0,j) && u>d(s0,j-1)
                y=j-2;
                s0=j-1;
            end
        end
    end
    if y==-1
        r(i)=-1;
    else
        a=d1-sa;
        b=tau_max-sa;
        %pd1=makedist('Beta','a',5,'b',2);
        pd1 = makedist('Normal','mu',(b-a)/2,'sigma',0.03);
        t1 = truncate(pd1,a,b);
        r0 = random(t1,1,1);
        %r0=a+(b-a)*rand(1,1);
        r(i) = floor(r0 * 10000) / 10000;
        d1=r(i);
    end
    d0=r(i);
end
h=0;
p=0;
for i=1:size(r,2)
    if r(i)==-1
        for j=i:-1:1
            if r(j)~=-1
                h=j;
                break;
            end
        end
        p=i-(r(h)/sa)-1;
        if p<1
            out(i)=s(1);
        else
            out(i)=s(round(p));
        end
    else
        p=i-(r(i)/sa);
        if p<1
            out(i)=s(1);
        else
            out(i)=s(round(p));
        end
    end
end
plcounter=0;
tsend=[];
trec=[];
for i=1:size(r,2)
    if r(i)~=-1
        tout1=[tout1,sa*(i-1)];
        tout2=[tout2,r(i)+sa*(i-1)];
    else
        plcounter=plcounter+1;
    end
end
i=2;
tout3=tout1;
tout4=tout2;
pd=0;
while i<=size(tout3,2)
        if tout4(i)<tout4(i-1)
            tout3(i-1)=[];
            tout4(i-1)=[];
            i=2;
            pd=pd+1;
        else
            i=i+1;
        end
end
flag3=0;
for i=2:size(tout4,2)
    if tout4(i)-tout4(i-1)>tau_max
        flag3=flag3+1;
    end
end
tsend=tout3;
trec=tout4;
totalp=size(t,2);
pdiscounter=size(tout1,2)-size(trec,2);
pl_perc=(plcounter/totalp)*100;
pdis_perc=(pdiscounter/totalp)*100;
figure(1)
plot(t,s) 
hold on 
stairs(t,out)
legend('NormalSignal','DelayedSignal')
hold off
xlabel('Time')
ylabel('Agent position')
figure(2)
for i=1:size(r,2)
    if r(i)==-1
        r(i)=NaN;
    end
end
x = t;
y = r;
scatter(x,y,'*')
avg=0;
cou=0;
for i=1:size(r,2)
    if isnan(r(i))
        
    else
        avg=avg+r(i);
        cou=cou+1;
    end
end
avg=avg/cou;
avg=avg*1000

