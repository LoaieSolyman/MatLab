dt=0.0001;t=dt:dt:10;n=100000;
d1=dooo();d2=dooo();t1=[];t2=[];t3=[];t4=[];t5=[];t6=[];
pos1=zeros(1,n);pos2=zeros(1,n);pos3=zeros(1,n);
pos4=zeros(1,n);pos5=zeros(1,n);pos6=zeros(1,n);pos7=zeros(1,n);pos8=zeros(1,n);
r1=t;k=-10;
pos1(1)=-1+(3+1)*rand;pos2(1)=-1+(3+1)*rand;pos3(1)=-1+(3+1)*rand;
pos4(1)=pos1(1);pos5(1)=pos2(1);pos6(1)=pos3(1);pos7(1)=pos2(1);pos8(1)=pos3(1);
for i=1:n
    if d1(i)==0
    else
        t1=[t1,i*dt];
        t3=[t3,d1(i)];
    end
    if d2(i)==0
    else
        t2=[t2,i*dt];
        t4=[t4,d2(i)];
    end
end
for i=1:size(t1,2)
    t5=[t5,t1(i)*i+t3(i)];
end
for i=1:size(t2,2)
    t6=[t6,t2(i)*i+t4(i)];
end
s1=0;s2=0;
for i=2:n
    pos1(i)=pos1(i-1)+(k*(pos1(i-1)-r1(i-1))+1)*dt;
    pos2(i)=pos2(i-1)+(k*(pos2(i-1)-pos1(i-1)+1)+1)*dt;
    pos3(i)=pos3(i-1)+(k*(pos3(i-1)-pos2(i-1)+1)+1)*dt;
end
c=0;
for i=2:size(t1,2)
    if i*dt-(t3(i)/10000)<0
        s1=fix(i-1);
        %s1=fix(i*dt*10000-1);
    else
        s1=fix(t3(i)*10000);
    end
    if s1>=i
        s1=i-1;c=c+1;
    end
    pos5(i)=pos5(i-1)+(k*(pos5(i-1)-pos1(i-s1)+1)+2)*dt;
end
for i=2:size(t2,2)
    if i*dt-(t4(i)/10000)<0
        s2=fix(i-1);
        %s2=fix(i*dt*10000-1);
    else
        s2=fix(t4(i)*10000);
    end
    if s2>=i
        s2=i-1;
    end
    pos6(i)=pos6(i-1)+(k*(pos6(i-1)-pos2(i-s2)+1)+2)*dt;
end
pos7(2)=pos2(2);pos8(2)=pos3(2);
for i=3:size(t1,2)
    if i*dt-(t3(i)/10000)<0
        s1=fix(i-1);
        %s1=fix(i*dt*10000-1);
    else
        s1=fix(t3(i)*10000);
    end
    if s1>=i
        s1=i-1;
    end
    if i*dt-(t3(i-1)/10000)<0
        s2=fix(i-1-1);
        %s1=fix(i*dt*10000-1);
    else
        s2=fix(t3(i-1)*10000);
    end
    if s2>=i
        s2=i-1-1;
    end
    pr1=(t(i)*(pos2(i-s1)-pos2(i))+pos2(i)*t1(i-s1)-pos2(i-s1)*t1(i))/(t1(i-s1)-t1(i));
    pos7(i)=pos7(i-1)+(k*(pos7(i-1)-pr1)+1)*dt;
end
c1=0;
for i=3:size(t2,2)
    if i*dt-(t4(i)/10000)<0
        s1=fix(i-1);
        %s1=fix(i*dt*10000-1);
    else
        s1=fix(t4(i)*10000);
    end
    if s1>=i
        s1=i-1;c1=c1+1;
    end
    if i*dt-(t4(i-1)/10000)<0
        s2=fix(i-1-1);
        %s1=fix(i*dt*10000-1);
    else
        s2=fix(t4(i-1)*10000);
    end
    if s2>=i
        s2=i-1-1;
    end
    pr2=(t(i)*(pos3(i-s1)-pos3(i))+pos3(i)*t2(i-s1)-pos3(i-s1)*t2(i))/(t2(i-s1)-t2(i));
    pos8(i)=pos8(i-1)+(k*(pos8(i-1)-pr2)+1)*dt;
end
if size(t5,2)<size(t6,2)
    tx=dt:dt:(size(t5,2)/10000);
else
    tx=dt:dt:(size(t6,2)/10000);
end
e1=zeros(1,size(t5,2));
for i=1:size(t5,2)
    e1(i)=pos2(i)-pos7(i);
end
e2=zeros(1,size(t6,2));
for i=1:size(t6,2)
    e2(i)=pos3(i)-pos8(i);
end
e3=zeros(1,size(t5,2));
for i=1:size(t5,2)
    e3(i)=pos2(i)-pos5(i);
end
e4=zeros(1,size(t6,2));
for i=1:size(t6,2)
    e4(i)=pos3(i)-pos6(i);
end
figure(1);
plot(tx,pos1(1:size(tx,2)),'linewidth',2);
hold on
plot(tx,pos2(1:size(tx,2)),'linewidth',2);
plot(tx,pos3(1:size(tx,2)),'linewidth',2);
plot(tx,pos5(1:size(tx,2)),'linewidth',2);
plot(tx,pos6(1:size(tx,2)),'linewidth',2);
plot(tx,pos7(1:size(tx,2)),'linewidth',2);
plot(tx,pos8(1:size(tx,2)),'linewidth',2);
hold off
xlabel('Time (s)') 
ylabel('Position of the Agent (m)')
legend('leader','follower1NoNetwork','follower2NoNetwork','follower1Network','follower2Network','follower1PredictionA','follower2PredictionA');
figure(2);
plot(tx,e3(1:size(tx,2)),'linewidth',2);
hold on 
plot(tx,e4(1:size(tx,2)),'linewidth',2);
plot(tx,e1(1:size(tx,2)),'linewidth',2);
plot(tx,e2(1:size(tx,2)),'linewidth',2);
hold off
xlabel('Time (s)') 
ylabel('Error between Actual and Desired Position (m)')
legend('Agent1NetworkedError','Agent2NetworkedError','Agent1PredictionError','Agent2PredictionError');