mu1=0.9306;mu2=0.9885;mu3=3.1847;sig1=0.1483;sig2=0.0247;sig3=0.9523;
%transition=[[0.0782 0.2581 0.6637];[0.2232 0.3561 0.4207];[0.0574 0.1228 0.8198]];
transition=[[0.1733 0.3183 0.5084];[0.135  0.2796 0.5854];[0.0818 0.1888 0.7294]];
%emission=[[0.4066 0.2358 0.3576];[0.0551 0.3399 0.605 ];[0.0731 0.0053 0.9216]];
emission=[[0.7702 0.2298];[0.7422 0.2578];[0.9495 0.0505]];
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
        delays(i)=0;
    else
        delays(i)=1;
    end
end
plot(delays,'o')