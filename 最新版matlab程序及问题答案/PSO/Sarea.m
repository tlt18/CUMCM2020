function S = Sarea(x)
%计算面积
%改名变T1_5,T6,T7,T8_9,v
global v T1_5 T6 T7 T8_9;
v=x(1);
T1_5=x(2); 
T6=x(3);
T7=x(4);
T8_9=x(5);
 [T,T3,t,t3,N]=get_sol(v);

time=0:0.5:400;
T_solve=interp1(t3,T3(fix(N/2),:),time);
T_solve=T_solve';
t_217=find(floor(T_solve)>=217);
t_limit=find(T_solve==max(T_solve));
t_logical=logical(t_217<t_limit);
t_217=t_217(t_logical);                 
t_dur217=max(time(t_217))-min(time(t_217));%温度大于217℃的时间；
s1=trapz(time(t_217),T_solve(t_217))-217*t_dur217;
 
t_217=find(floor(T_solve)>=217);
     
t_dur217=max(time(t_217))-min(time(t_217));%温度大于217℃的时间；
s2=trapz(time(t_217),T_solve(t_217))-217*t_dur217;

dealta_s=abs(s2-s1-s1);
s=s1;
 
 derivative_T=diff(T_solve)/0.5;%温度变化斜率
 search=logical(derivative_T>=0);
 T_up=derivative_T(search);%温度上升斜率
 derivative_T(search)=[];
 T_down=derivative_T;%温度下降斜率
   T_p=max(T_solve);
 dsolve=diff(T_solve);
 t_limit=find(T_solve==T_p,1);
 t_low=find(T_solve>=150);
 tt_low=find(t_low<t_limit);
 t_high=find(ceil(T_solve)<=190);
 tt_high=find(t_high<t_limit);
 t_dur=max(time(t_high(tt_high)))-min(time(t_low(tt_low)));%温度上升过程中在150℃-190℃的时间
 
 t_217=find(floor(T_solve)>=217);
 t_dur217=max(time(t_217))-min(time(t_217));%温度大于217℃的时间；


pun=10000000;

if (max(T_up)>3|min(T_down)<-3|t_dur<60|t_dur>120|t_dur217<40|t_dur217>90|T_p<240|T_p>250)
  S=s+pun;
else
  S=s;
end

end

