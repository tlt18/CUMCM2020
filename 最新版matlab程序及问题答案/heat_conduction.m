
%参数设置
L=0.15;
N=50;    
c=0.0067
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
Ti=init_fun2(z);
To=border_funo2(t);
Te=border_fune2(t);
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
To=border_funo2(t2);
Te=border_fune2(t2);
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

T33=zeros(N+1,M2+num_start-1);
T33(:,1:num_start-1)=T(:,1:num_start-1);
T33(:,num_start:M2+num_start-1)=T2(:,2:end);

t33=zeros(M2+num_start-1,1);

t33(1:num_start-1,1)=t(1:num_start-1,1);
t33(num_start:M2+num_start-1,1)=t2(2:end);

% [tt,zz]=meshgrid(t,z);
% subplot(1,2,1);
% surf(tt,zz,T);
% xlabel('t')
% ylabel('x')
% subplot(1,2,2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%改变alfa
%差距值 171.5；
T_start=167;

temp=find(T2(fix(N/2),:)<T_start,3);
num_start3=temp(2);

c3=0.0067;
alfa3=c3^2;
tao3=lambda*h^2/alfa3;


t3=t2(num_start3-1):tao3:tm;
M3=length(t3);
t3=t2(num_start3-1):tao3:(tm+tao3);
T3=zeros(N+1,M3+1);

t3=t3'; %计算初值和边值?
To=border_funo2(t3);
Te=border_fune2(t3);
T3(:,1)=T2(:,num_start3-1);
T3(1,:)=To;
T3(N+1,:)=Te; 

%用差分法求出温度T与杆长L、时间t的关系
for k=1:M3
    m=2;
    while m<=N
        T3(m,k+1)=lambda*(T3(m+1,k)+T3(m-1,k))+(-2*lambda+1)*T3(m,k);
        m=m+1;
    end
end

T4=zeros(N+1,M3+num_start+num_start3-3);
T4(:,1:num_start-1)=T(:,1:num_start-1);

T4(:,num_start:num_start+num_start3-3)=T2(:,2:num_start3-1);

T4(:,num_start+num_start3-2:M3+num_start+num_start3-3)=T3(:,2:end);

t4=zeros(M3+num_start+num_start3-3,1);

t4(1:num_start-1,1)=t(1:num_start-1,1);

t4(num_start:num_start+num_start3-3,1)=t2(2:num_start3-1);

t4(num_start+num_start3-2:M3+num_start+num_start3-3,1)=t3(2:end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5


% plot(t,T(fix(N/2),:));

hold on




plot(t33,T33(fix(N/2),:));
% plot(t4,T4(fix(N/2),:));
% legend('原始曲线','修正曲线','修正曲线2','附件炉温曲线');

data_raw=readtable('.\附件.xlsx');
plot( data_raw.t , data_raw.T );
hold off;

legend('仅修正a的理论曲线','修正区间的理论曲线','实际炉温曲线');

legend('Location','northwest')
xlabel("时间（s）");
ylabel("温度（℃）");
axis([0 400 0 250])




addpath('../lib');



% change properties
opt.XLabel = 't(s)'; % xlabel
opt.YLabel = 'T(℃)'; %ylabel
opt.YTick = [0, 0, 250]; %[tick1, tick2, .. ]
opt.XLim = [0, 400]; % [min, max]
opt.YLim = [0, 250]; % [min, max]

opt.Colors = [ % three colors for three data set
    0,      1,       0;
    0,      0,       1;
    1,      0,       0;   
    ];

opt.LineWidth = [1, 1, 1,]; % three line widths
opt.LineStyle = {'-', '-', '-'}; % three line styles
opt.Legend = {'\theta = 0^o', '\theta = 45^o', '\theta = 90^o'}; % legends

% Save? comment the following line if you do not want to save
opt.FileName = 'plotMultiple2.png'; 

% create the plot
setPlotProp(opt);
    

%%
TT3=interp1(t33,T33(fix(N/2),:),data_raw.t);
delt3=TT3-data_raw.T
max(delt3);
min(delt3);

mean(delt3);
var(delt3);
boxplot(delt3)
% ,'plotstyle','compact'
title('温度差值箱型图')
set(0,'defaultfigurecolor','w')
%%
z;
zzzz=z(1:1:end,1)
t33;
tttt=t33(1:5:end,1)
TTTT=T33(:,1:5:end);
[tt33,zz]=meshgrid(tttt,z);

s=surf(tttt,zz,TTTT);
xlabel('t(s)')
ylabel('x(cm)')
zlabel('T_{stannum}(℃)')
colorbar
% 'FaceAlpha',0.8)

colormap autumn	



s.EdgeColor = 'none';
s.FaceAlpha=0.9800;
%%
t=0:450;
xiuzheng=zeros(length(t),1);
buxiu=zeros(length(t),1);
 for i=1:length(t)
     xiuzheng(i,1)=temperature_air_none(t(1,i));   
     buxiu(i,1)=temperature_air(t(1,i));
 end
 plot(t,buxiu,t,xiuzheng)
 
xlabel('x（cm）');
ylabel("温度（℃）");
legend('原始温度分布','修正后温度分布');
legend('Location','northwest')
addpath('../lib');

% change properties
opt.XLabel = 'x(cm)'; % xlabel
opt.YLabel = 'T(℃)'; %ylabel
opt.YTick = [0, 0, 250]; %[tick1, tick2, .. ]
opt.XLim = [0, 400]; % [min, max]
opt.YLim = [0, 250]; % [min, max]

opt.Colors = [ % three colors for three data set
    0,      0,       1;
    1,      0,       0;
    1,      0,       0;   
    ];

opt.LineWidth = [1, 1, 1,]; % three line widths
opt.LineStyle = {'-', '-', '-'}; % three line styles
opt.Legend = {'\theta = 0^o', '\theta = 45^o', '\theta = 90^o'}; % legends

% Save? comment the following line if you do not want to save
opt.FileName = 'plotMultiple2.png'; 

% create the plot
setPlotProp(opt);

%%

function y=init_fun2(z) %初值条件
y=25;
end

function y=border_funo2(t) %边界条件
y=zeros(length(t),1);
 for i=1:length(t)
     y(i)=temperature_air_none(t(i,1));   
 end
end

function y=border_fune2(t) %边界条件
y=zeros(length(t),1);
 for i=1:length(t)
     y(i)=temperature_air_none(t(i,1));   
 end
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


