mu1=0.9306;mu2=0.9885;mu3=3.1847;sig1=0.1483;sig2=0.0247;sig3=0.9523;
%transition=[[0.0782 0.2581 0.6637];[0.2232 0.3561 0.4207];[0.0574 0.1228 0.8198]];
transition=[[0.1474 0.2575 0.5951];[0.139  0.2452 0.6159];[0.0687 0.1418 0.7895]];
%emission=[[0.4066 0.2358 0.3576];[0.0551 0.3399 0.605 ];[0.0731 0.0053 0.9216]];
emission=[[0.1222 0.0884 0.7893];[0.0785 0.1214 0.8002];[0.0438 0.0226 0.9336]];
start=[0.1,0.1,0.8];n=200;
delays=zeros(1,n);
for i=1:size(transition,1)
    for j=2:size(transition,2)
        transition(i,j)=transition(i,j)+transition(i,j-1);
    end
end
for i=1:size(emission,1)
    for j=2:size(emission,2)
        emission(i,j)=emission(i,j)+emission(i,j-1);
    end
end
for i=2:size(start,2)
    start(1,i)=start(1,i)+start(1,i-1);
end
p=rand;
for i=2:size(start,2)
    if p<start(1)
        s=1;
    end
    if p>start(i-1) && p<start(i)
        s=i;
    end
end
for i=1:n
    p1=rand;
    for j=2:size(transition,2)
        if p1<transition(s,1)
            s1=1;
        end
        if p1>transition(s,j-1) && p1<transition(s,j)
            s1=j;
        end
    end
    p2=rand;
    for j=2:size(emission,2)
        if p2<emission(s1,1)
            s2=1;
        end
        if p2>emission(s1,j-1) && p2<emission(s1,j)
            s2=j;
        end
    end
    if s2==1
        delays(i)=normrnd(mu3,sig3);
    else
        if s2==2
            delays(i)=normrnd(mu1,sig1);
        else
            delays(i)=normrnd(mu2,sig2);
        end
    end
end
plot(delays,'.')