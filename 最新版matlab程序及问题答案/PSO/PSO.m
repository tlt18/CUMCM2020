%%
clc
clear

E=0.000001;
maxnum=30;%����������
narvs=5;%Ŀ�꺯�����Ա�������
particlesize=20;%����Ⱥ��ģ
c1=2;%ÿ�����ӵĸ���ѧϰ���ӣ����ٶȳ���
c2=2;%ÿ�����ӵ����ѧϰ���ӣ����ٶȳ���
w=0.6;%��������
vmax=2;%���ӵ��������ٶ�
vfly=0.5*rand(particlesize,narvs);%���ӷ����ٶ�

x=zeros(particlesize,narvs);
x(:,1)=65+35*rand(particlesize,1);
x(:,2)=165+20*rand(particlesize,1);
x(:,3)=185+20*rand(particlesize,1);
x(:,4)=225+20*rand(particlesize,1);
x(:,5)=245+20*rand(particlesize,1);
% x=-300+600*rand(particlesize,narvs);%��������λ��

%������Ӧ�Ⱥ���
fitness=@Sarea;


for i=1:particlesize
	f(i)=fitness(x(i,:));	
end

personalbest_x=x;
personalbest_faval=f;
[globalbest_faval,i]=min(personalbest_faval);
globalbest_x=personalbest_x(i,:); 

k=1;
ff=zeros(maxnum,1);
while (k<=maxnum)
	for i=1:particlesize
			f(i)=fitness(x(i,:));
		if f(i)<personalbest_faval(i)
			personalbest_faval(i)=f(i);
			personalbest_x(i,:)=x(i,:);
		end
    end
    
	[globalbest_faval,i]=min(personalbest_faval);
	globalbest_x=personalbest_x(i,:);
    
	for i=1:particlesize
		vfly(i,:)=w*vfly(i,:)+c1*rand*(personalbest_x(i,:)-x(i,:))...
			+c2*rand*(globalbest_x-x(i,:));
		for j=1:narvs
			if vfly(i,j)>vmax
				vfly(i,j)=vmax;
			elseif vfly(i,j)<-vmax
				vfly(i,j)=-vmax;
            end
		end
		x(i,:)=x(i,:)+vfly(i,:);
        
        if(x(i,1)<65) 
            x(i,1)=65;
        end
        if(x(i,1)>100) 
            x(i,1)=100;
        end
        if(x(i,2)<165) 
            x(i,2)=165;
        end
        if(x(i,2)>185) 
            x(i,1)=185;
        end
        if(x(i,3)<185) 
            x(i,3)=185;
        end
        if(x(i,3)>205) 
            x(i,3)=205;
        end
        if(x(i,4)<225) 
            x(i,4)=225;
        end
        if(x(i,4)>245) 
            x(i,4)=245;
        end
        if(x(i,5)<245) 
            x(i,5)=245;
        end
        if(x(i,5)>265) 
            x(i,5)=265;
        end
            
    end
    
    ff(k)=globalbest_faval;
    
%     if globalbest_faval<E
%         break
        
%     end
%       figure(1)
%       for i= 1:particlesize
%       plot(x(i,1),x(i,2),'*')
%       end
	k=k+1;
end
xbest=globalbest_x;

figure(2)
set(gcf,'color','white');
plot(1:length(ff),ff)
xlabel('��������');
ylabel('��Ӧ��');
