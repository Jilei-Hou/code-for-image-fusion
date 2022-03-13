function [opt_x,opt_value]=DEopt(NP,CR,F,D,xmin,xmax,G)
%-------------------------------------------------------------------------%
%函数功能：差分进化算法，用于得到最优分块尺寸，是一个离散空间问题
% 参数说明：
% NP：种群个数
% CR：交叉算子
% F：变异算子
% D：问题维数（个体分量数）
% xmin，xmax：个体最小和最大范围限制
% G：进化代数
% 输出：
% opt_x：最优解
% opt_value：最优值
%-------------------------------------------------------------------------%

for i=1:NP                                            %初始化
    for j=1:D
        x(i,j)=ceil(rand*(xmax(j)-xmin(j)+1))+xmin(j)-1;
    end
end
                          
v=x;  %临时种群
u=x;  %试验种群
for k=1:G                                               %主循环
    for i=1:NP                                          %变异
        r1=1;                                           
        r2=1;
        r3=1;
        while (r1==r2)||(r1==r3)||(r1==i)||(r2==r3)||(r2==i)||(r3==i)
              r1=ceil(rand*NP);
              r2=ceil(rand*NP);
              r3=ceil(rand*NP);
        end
        v(i,:)=floor(x(r1,:)+F*(x(r2,:)-x(r3,:)));
        out_flag=0;                                   %边界检查
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
    
    for i=1:NP                                          %交叉
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
    
    for i=1:NP                                         %选择
        if fitness(u(i,:))<=fitness(x(i,:))
            x(i,:)=u(i,:);
        else
            x(i,:)=x(i,:);
        end
    end
    
end
%最优值和最优解 
for i=1:NP
    f(i)=fitness(x(i,:));
end
[opt_value,opt_index]=min(f);                     %当前种群的最优值和最优解
opt_x=x(opt_index,:);

    
    
        
        
        
        
            
        
        


