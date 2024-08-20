
mu1=0.1;sig1=1;mu2=0.2;sig2=1;mu3=0.4;sig3=1;
x=-1:0.1:5;n=200;x4=1:1:200;
n1=zeros(1,n);n2=zeros(1,n);n3=zeros(1,n);
y1 = normpdf(x,mu1,sig1);
y2 = normpdf(x,mu2,sig2);
y3 = normpdf(x,mu3,sig3);
figure(1);
%plot(x,y1,'-',x,y2,'-.',x,y3,'.-');
%data=1 + (10-1) .* rand(1,n);
data=normrnd(0.04,0.01,[1,n]);
for i=[30,60,150,100]
    data(i)=normrnd(0.1,0.01);
end
for i=[15,178]
    data(i)=normrnd(0.2,0.1);
end
%data=[0.8000,0.8555,0.9000,0.9001,0.9210,0.9910,1.700,0.8750,0.92250,0.7950,0.9000,0.8998,0.9125,1.800,0.9100,0.9500,0.8999,1.9000,0.8750,0.9235,0.8000,0.8555,0.9000,0.9001,0.9210,0.9910,1.700,0.8750,0.92250,0.7950,0.9000,0.8998,0.9125,1.800,0.9100,0.9500,0.8999,1.9000,0.8750,0.9235];
pr1=0.33;pr2=0.33;pr3=1-pr1-pr2;
for i=1:1:10
    for j=1:1:n
        x1=(exp(-((data(j)-mu1)^2)/(2*sig1)))/(sqrt(2*pi*sig1));
        x2=(exp(-((data(j)-mu2)^2)/(2*sig2)))/(sqrt(2*pi*sig2));
        x3=(exp(-((data(j)-mu3)^2)/(2*sig3)))/(sqrt(2*pi*sig3));
        n1(j)=(x1*pr1)/(x1*pr1+x2*pr2+x3*pr3);
        n2(j)=(x2*pr2)/(x1*pr1+x2*pr2+x3*pr3);
        n3(j)=1-n1(j)-n2(j);
    end
    u1=0;u2=0;u3=0;v1=0;v2=0;v3=0;w1=0;w2=0;w3=0;
    for k=1:1:n
        u1=u1+n1(k)*data(k);
        u2=u2+n1(k)*((data(k)-mu1)^2);
        u3=u3+n1(k);
        v1=v1+n2(k)*data(k);
        v2=v2+n2(k)*((data(k)-mu2)^2);
        v3=v3+n2(k);
        w1=w1+n3(k)*data(k);
        w2=w2+n3(k)*((data(k)-mu3)^2);
        w3=w3+n3(k);
    end
    mu1=u1/u3;
    sig1=u2/u3;
    mu2=v1/v3;
    sig2=v2/v3;
    mu3=w1/w3;
    sig3=w2/w3;
    pr1=u3/n;
    pr2=v3/n;
    pr3=1-pr1-pr2;
end
 
for i=1:n
    if data(i)<0.01
        data(i)=0.04;
    end
end
y1 = normpdf(x,mu1,sig1);
y2 = normpdf(x,mu2,sig2);
y3 = normpdf(x,mu3,sig3);
figure(2);
plot(x,y1,'-',x,y2,'-.',x,y3,'.-');
figure(3);
hold on
for i=1:n
    if data(i)==0.1
        scatter(x4(i),data(i),'xr');
    else
        scatter(x4(i),data(i),'*b');
    end
end
ylim([0 0.2])
hold off


