function [T,T3,t,t3,N] = get_sol(v)
L=0.15;
N=50;
i=0;
c=0.0067;
alfa=c^2;
lambda=0.5;
tm=400;

h=L/N;        %空间步长
z=0:h:L;      %z：空间步长分割
z=z';

tao=lambda*h^2/alfa;
t=0:tao:tm;
M=length(t);
t=0:tao:(tm+tao);
t=t'; %计算初值和边值?
T=zeros(N+1,M+1);
Ti=init_fun(z);
To=border_funo(t);
Te=border_fune(t);
T(:,1)=Ti;
T(1,:)=To;
T(N+1,:)=Te; 
%用差分法求出温度T与杆长L、时间t的关系
for k=1:M
    m=2;
    while m<=N
        T(m,k+1)=lambda*(T(m+1,k)+T(m-1,k))+(-2*lambda+1)*T(m,k);
        m=m+1;
    end
end

%改变alfa
%差距值 171.5；
T_start=167;
num_start=find(T(fix(N/2),:)>T_start,1);

c2=0.0077;
alfa2=c2^2;
tao2=lambda*h^2/alfa2;


t2=t(num_start-1):tao2:tm;
M2=length(t2);
t2=t(num_start-1):tao2:(tm+tao2);
T2=zeros(N+1,M2+1);

t2=t2'; %计算初值和边值?
To=border_funo(t2);
Te=border_fune(t2);
T2(:,1)=T(:,num_start-1);
T2(1,:)=To;
T2(N+1,:)=Te; 

%用差分法求出温度T与杆长L、时间t的关系
for k=1:M2
    m=2;
    while m<=N
        T2(m,k+1)=lambda*(T2(m+1,k)+T2(m-1,k))+(-2*lambda+1)*T2(m,k);
        m=m+1;
    end
end

T3=zeros(N+1,M2+num_start-1);
T3(:,1:num_start-1)=T(:,1:num_start-1);
T3(:,num_start:M2+num_start-1)=T2(:,2:end);

t3=zeros(M2+num_start-1,1);

t3(1:num_start-1,1)=t(1:num_start-1,1);
t3(num_start:M2+num_start-1,1)=t2(2:end);



% [tt,zz]=meshgrid(t,z);
% subplot(1,2,1);
% surf(tt,zz,T);
% xlabel('t')
% ylabel('x')
% subplot(1,2,2)
end

function y=init_fun(z) %初值条件
y=25;
end

function y=border_funo(t) %边界条件
y=zeros(length(t),1);
 for i=1:length(t)
     y(i)=temperature_air(t(i,1));   
 end
end

function y=border_fune(t) %边界条件
y=zeros(length(t),1);
 for i=1:length(t)
     y(i)=temperature_air(t(i,1));   
 end
end










