function [opt_x,opt_value]=DEopt(NP,CR,F,D,xmin,xmax,G)
%-------------------------------------------------------------------------%
%�������ܣ���ֽ����㷨�����ڵõ����ŷֿ�ߴ磬��һ����ɢ�ռ�����
% ����˵����
% NP����Ⱥ����
% CR����������
% F����������
% D������ά���������������
% xmin��xmax��������С�����Χ����
% G����������
% �����
% opt_x�����Ž�
% opt_value������ֵ
%-------------------------------------------------------------------------%

for i=1:NP                                            %��ʼ��
    for j=1:D
        x(i,j)=ceil(rand*(xmax(j)-xmin(j)+1))+xmin(j)-1;
    end
end
                          
v=x;  %��ʱ��Ⱥ
u=x;  %������Ⱥ
for k=1:G                                               %��ѭ��
    for i=1:NP                                          %����
        r1=1;                                           
        r2=1;
        r3=1;
        while (r1==r2)||(r1==r3)||(r1==i)||(r2==r3)||(r2==i)||(r3==i)
              r1=ceil(rand*NP);
              r2=ceil(rand*NP);
              r3=ceil(rand*NP);
        end
        v(i,:)=floor(x(r1,:)+F*(x(r2,:)-x(r3,:)));
        out_flag=0;                                   %�߽���
        for j=1:D
            if (v(i,j)<xmin(j))||(v(i,j)>xmax(j))
                out_flag=1;
                break;
            end
        end
        if out_flag==1
            v(i,:)=ceil(rand*(xmax(j)-xmin(j)+1))+xmin(j)-1;
        end
    end
    
    for i=1:NP                                          %����
        for j=1:D                             
            rj=ceil(rand*D);
            rp=rand;
            if (rp<=CR)||(j==rj)
                u(i,j)=v(i,j);
            else
                u(i,j)=x(i,j);
            end
        end
    end
    
    for i=1:NP                                         %ѡ��
        if fitness(u(i,:))<=fitness(x(i,:))
            x(i,:)=u(i,:);
        else
            x(i,:)=x(i,:);
        end
    end
    
end
%����ֵ�����Ž� 
for i=1:NP
    f(i)=fitness(x(i,:));
end
[opt_value,opt_index]=min(f);                     %��ǰ��Ⱥ������ֵ�����Ž�
opt_x=x(opt_index,:);

    
    
        
        
        
        
            
        
        


