%%
%������������
%����
L=30.5; %С��������cm
global a
a=5; %��϶cm
ll=25; %¯ǰ����¯��������cm
global d
d=0.15; %����������mm
%�������¶�
global T0
T0=25; %�����¶ȡ�¯ǰ�����¯������10_11����25��
%�ɿز���
global v T1_5 T6 T7 T8_9
T1_5=175; %175\pm10
T6=195; %195\pm10
T7=235; %235\pm10
T8_9=255; %255\pm10

%%
%����¯������
data_raw=readtable('.\����.xlsx');%��������ӵ���ǰ·��
plot(data_raw{:,1},data_raw {:,2});
title("����¯������");
xlabel("ʱ�䣨s��");
ylabel("�¶ȣ��棩");


%%
%ʱ���¶ȷֲ�
hold on
T_temp=zeros(1,400);
v=70; %65_100 cm/min
for i=1:800
    T_step(1,i)=temperature_air(i*0.5,v);%��0.5��Ϊ�����ݶ�
end
plot(0.5:0.5:400,T_step(1,:));


%%
[T,T3,t,t3,N]=get_sol(v);
% plot(t,T(fix(N/2),:));
% hold on
% plot(t3,T3(fix(N/2),:));
% time=0:0.5:400;
% sol=interp1(t3,T3(fix(N/2),:)',time);
% data_raw=readtable('.\����.xlsx');%��������ӵ���ǰ·��
% plot(data_raw{:,1},data_raw {:,2});
% title("����¯������");
% xlabel("ʱ�䣨s��");
% ylabel("�¶ȣ��棩");
% legend("δ����","����","ԭʼ")

%%
%����һ
T1_5=173; %175\pm10
T6=198; %195\pm10
T7=230; %235\pm10
T8_9=257; %255\pm10
v=78;
[T,T3,t,t3,N]=get_sol(v);
T_solve=T3(fix(N/2),:)';
plot(t3,T_solve);
title("��ǰ�¶��º������������¶ȱ仯���");
xlabel("ʱ�䣨s��");
ylabel("�¶ȣ��棩");
s3=111.25;
s6=217.75;
s7=253.25;
s8=304;
t_block3=s3/(v/60);
t_block6=s6/(v/60);
t_block7=s7/(v/60);
t_block8=s8/(v/60);
T_blockq=interp1(t3,T_solve',[t_block3,t_block6,t_block7,t_block8]);
T_block3=T_blockq(1)%С����3���ĺ����������ĵ��¶�
T_block6=T_blockq(2)%С����6���ĺ����������ĵ��¶�
T_block7=T_blockq(3)%С����7���ĺ����������ĵ��¶�
T_block9=T_blockq(4)%С����8�����������������ĵ��¶�

%%
%�����

v_test=65:1:100; %���ʹ����ٶȷ�Χ
time=0:0.5:400;
v_able=zeros(1,length(v_test));
for n=1:length(v_able)%���ʹ����ٶȷ�Χ
    flag=1;
    v=v_test(n);
    T1_5=183; %175\pm10
    T6=203; %195\pm10
    T7=237; %235\pm10
    T8_9=254; %255\pm10
    [T,T3,t,t3,N]=get_sol(v);
   
    time=0:0.5:400;
    T_solve=interp1(t3,T3(fix(N/2),:),time);
    T_solve=T_solve';
    %�ɿز���
    T_p=max(T_solve);%��ֵ�¶�
    T_pp(n)=T_p;
    derivative_T=diff(T_solve)/0.5;%�¶ȱ仯б��
    search=logical(derivative_T>=0);
    T_up=derivative_T(search);%�¶�����б��
    derivative_T(search)=[];
    T_down=derivative_T;%�¶��½�б��
    dsolve=diff(T_solve);
    t_limit=find(T_solve==T_p);
    t_low=find(T_solve>=150);
    tt_low=find(t_low<t_limit);
    t_high=find(ceil(T_solve)<=190);
    tt_high=find(t_high<t_limit);
    t_dur=max(time(t_high(tt_high)))-min(time(t_low(tt_low)));%�¶�������������150��-190���ʱ��
    t_217=find(floor(T_solve)>=217);
    t_dur217=max(time(t_217))-min(time(t_217));%�¶ȴ���217���ʱ�䣻
    tt_dur217(n)=t_dur217;
    
if (max(T_up)>3|min(T_down)<-3|t_dur<60|t_dur>120|t_dur217<40|t_dur217>90|T_p<240|T_p>250)
    flag=0;
end

if (flag==1)
    v_able(n)=v_test(n);
end

end
v_max=max(v_able);%ȷ�����������ʹ���¯�ٶ�

%%
%������

xlabel("���ʹ��ٶȣ�cm/min��");
yyaxis left
plot(65:100,tt_dur217);%��������������ݣ����������217������ʱ��ʹ��ʹ��ٶȵĹ�ϵ����
ylabel("�¶ȸ���217��ĳ���ʱ��")
hold on
yyaxis right
plot(65:100,T_pp);%��������������ݣ������ֵ��С�ʹ��ʹ��ٶȵĹ�ϵ����
ylabel("��ֵ�߶ȣ��棩")
legend("�¶ȸ���217���ʱ�䡪�����ʹ��ٶ�","��ֵ�߶ȡ������ʹ��ٶ�");
%�¶ȷ�ֵԽ�ߣ��¶ȸ���217��ĳ���ʱ��Խ����ͼ2��Ӱ�������Խ��
%��������2���ݷ����ã����ʹ��ٶ�Խ�ͣ��¶ȸ���217��ĳ���ʱ��Խ�����¶ȷ�ֵԽ��
%���¶ȷ�ֵ���¶ȸ���217��ĳ���ʱ���봫�ʹ��ٶȱ仯��ϵ֪����Ӱ���������СֵӦ�ڴ��ʹ��ٶ����ʱȡ�á�
v=85;
%%

v= 99.8100;
% for i=1:20
T1_5=177.855334006216; %175\pm10
T6=195.433443245191; %195\pm10
T7=230.980705960280; %235\pm10
T8_9=263.013254873667;%255\pm10
%     saveT(i)=T8_9;
%     savev(i)=v;
[T,T3,t,t3,N]=get_sol(v);
time=0:0.5:400;
T_solve=interp1(t3,T3(fix(N/2),:),time);
T_solve=T_solve';
t_217=find(floor(T_solve)>=217);
t_limit=find(T_solve==max(T_solve));
t_logical=logical(t_217<t_limit);
t_217=t_217(t_logical);
t_dur217=max(time(t_217))-min(time(t_217));%�¶ȴ���217���ʱ�䣻
s=trapz(time(t_217),T_solve(t_217))-217*t_dur217;
%  saves(i)=s;
%  end
% hold on
% %  plot(savev,saves);
% plot(saveT,saves);
% %  legend("����1-5","6","7","8-9")
% xlabel("�¶ȣ��棩")
% %  xlabel("�ٶȣ�cm/s��")
%  ylabel("��Ӱ�������s")
%  title("��Ӱ�������-С�����¶ȣ���T1_5=175,T6=195,T7=235,T8_9=255Ϊ��׼��ͼ��")
% %  title("��Ӱ�������-���ʹ��ٶ�")

%%
s_realm=[];
T1_5realm=[];
T6realm=[];
T7realm=[];
T8_9realm=[];
v_realm=[];
T1_5=181.1;
n = 1;
for i=1
    v=99.81;
    for j=1
        T6=196.7;
        for p=1
            T7=230.3;
            for q=1
                T8_9=264.3;
                flag=1;
                [T,T3,t,t3,N]=get_sol(v);
                time=0:0.5:400;
                T_solve=interp1(t3,T3(fix(N/2),:),time);
                T_solve=T_solve';
               
                 t_217=find(floor(T_solve)>=217);
                 t_limit=find(T_solve==max(T_solve));
                 t_logical=logical(t_217<t_limit);
                 t_217=t_217(t_logical);                 
                 t_dur217=max(time(t_217))-min(time(t_217));%�¶ȴ���217���ʱ�䣻
                 s=trapz(time(t_217),T_solve(t_217))-217*t_dur217;
                 
                 
                %saves(i)=s;
                
                T_p=max(T_solve);%��ֵ�¶�
                derivative_T=diff(T_solve)/0.5;%�¶ȱ仯б��
                search=logical(derivative_T>=0);
                T_up=derivative_T(search);%�¶�����б��
                derivative_T(search)=[];
                T_down=derivative_T;%�¶��½�б��
                dsolve=diff(T_solve);
                t_limit=find(T_solve==T_p);
                t_low=find(T_solve>=150);
                tt_low=find(t_low<t_limit);
                t_high=find(ceil(T_solve)<=190);
                tt_high=find(t_high<t_limit);
                t_dur=max(time(t_high(tt_high)))-min(time(t_low(tt_low)));%�¶�������������150��-190���ʱ��
                t_217=find(floor(T_solve)>=217);
                t_dur217=max(time(t_217))-min(time(t_217));%�¶ȴ���217���ʱ�䣻
                if (max(T_up)>3|min(T_down)<-3|t_dur<60|t_dur>120|t_dur217<40|t_dur217>90|T_p<240|T_p>250)
                    flag=0;
                end
                if(flag==1)
                s_realm(n)=s;
                T1_5realm(n)=T1_5;
                T6realm(n)=T6;
                T7realm(n)=T7;
                T8_9realm(n)=T8_9;
                v_realm(n)=v;
                n = n + 1;
                end
            end
        end
    end
end
index=find(s_realm==min(s_realm));   
min(s_realm)
T1_5realm(index)
T6realm(index)
T7realm(index)
T8_9realm(index)
v_realm(index)
%%
T1_5=T1_5realm(index); %175\pm10
T6=T6realm(index); %195\pm10
T7=T7realm(index); %235\pm10
T8_9=T8_9realm(index); %255\pm10
v=v_realm(index);
[T,T3,t,t3,N]=get_sol(v);
T_solve=T3(fix(N/2),:)';
plot(t3,T_solve);
title("����¯������");
xlabel("ʱ�䣨s��");
ylabel("�¶ȣ��棩");
                    
 %%
 %�����ģ�
 for i=1:n-1
     T1_5=T1_5realm(i); %175\pm10
     T6=T6realm(i); %195\pm10
     T7=T7realm(i); %235\pm10
     T8_9=T8_9realm(i); %255\pm10
     v=v_realm(i);
     
     [T,T3,t,t3,N]=get_sol(v);
     time=0:0.5:400;
     T_solve=interp1(t3,T3(fix(N/2),:),time);
     T_solve=T_solve';
     
     t_217=find(floor(T_solve)>=217);
     t_limit=find(T_solve==max(T_solve));
     t_logical=logical(t_217<t_limit);
     t_217=t_217(t_logical);
     t_dur217=max(time(t_217))-min(time(t_217));%�¶ȴ���217���ʱ�䣻
     s1=trapz(time(t_217),T_solve(t_217))-217*t_dur217;
     t_217=find(floor(T_solve)>=217);
     
     t_dur217=max(time(t_217))-min(time(t_217));%�¶ȴ���217���ʱ�䣻
     s2=trapz(time(t_217),T_solve(t_217))-217*t_dur217;
     dealta_s(i)=abs(s2-s1-s1);
 end
index=find(dealta_s==min(dealta_s));   
T1_5realm(index)
T6realm(index)
T7realm(index)
T8_9realm(index)
v_realm(index)
%%
T1_5=173.4; %175\pm10
T6=188.47; %195\pm10
T7=231.15; %235\pm10
T8_9=264.29; %255\pm10
v=95.2
[T,T3,t,t3,N]=get_sol(v);
T_solve=T3(fix(N/2),:)';
plot(t3,T_solve,'LineWidth',2,'Color','b');

xlabel("t��s��");
ylabel("T���棩");
addpath('../lib');

% change properties
opt.XLabel = 'x(cm)'; % xlabel
opt.YLabel = 'T(��)'; %ylabel
opt.YTick = [0, 0, 250]; %[tick1, tick2, .. ]
opt.XLim = [0, 400]; % [min, max]
opt.YLim = [0, 250]; % [min, max]

opt.Colors = [ % three colors for three data set
    1,      0,       0;
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

 
 
 