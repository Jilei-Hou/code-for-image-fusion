function f=fitness(x)
%-------------------------------------------------------------------------%
%函数功能：根据尺寸x进行对图像分块融合
% 参数说明：
% x：分块尺寸
% 输出：
% f：融合结果的GSV值的负值（某种准则下的全局评价，用于优化算法中的比较）
%-------------------------------------------------------------------------%

global A1;
global B1;
global C1;
[H,W]=size(A1);
m=x(1);%高度，行数
n=x(2);%宽度，列数
count_h=floor(H/m);
count_w=floor(W/n);

for j=1:count_h
    if j<count_h
        for i=1:count_w
            if i<count_w
                block1=A1((j-1)*m+1:j*m ,(i-1)*n+1:i*n);
                block2=B1((j-1)*m+1:j*m ,(i-1)*n+1:i*n);
                if BSV(block1)>=BSV(block2)
                    C1((j-1)*m+1:j*m ,(i-1)*n+1:i*n)=block1;
                else
                    C1((j-1)*m+1:j*m ,(i-1)*n+1:i*n)=block2;
                end
            else
                block1=A1((j-1)*m+1:j*m ,(i-1)*n+1:W);
                block2=B1((j-1)*m+1:j*m ,(i-1)*n+1:W);
                if BSV(block1)>=BSV(block2)
                    C1((j-1)*m+1:j*m ,(i-1)*n+1:W)=block1;
                else
                    C1((j-1)*m+1:j*m ,(i-1)*n+1:W)=block2;
                end
            end
        end
    else
        for i=1:count_w
            if i<count_w
                block1=A1((j-1)*m+1:H ,(i-1)*n+1:i*n);
                block2=B1((j-1)*m+1:H ,(i-1)*n+1:i*n);
                if BSV(block1)>=BSV(block2)
                    C1((j-1)*m+1:H ,(i-1)*n+1:i*n)=block1;
                else
                    C1((j-1)*m+1:H ,(i-1)*n+1:i*n)=block2;
                end
            else
                block1=A1((j-1)*m+1:H ,(i-1)*n+1:W);
                block2=B1((j-1)*m+1:H ,(i-1)*n+1:W);
                if BSV(block1)>=BSV(block2)
                    C1((j-1)*m+1:H ,(i-1)*n+1:W)=block1;
                else
                    C1((j-1)*m+1:H ,(i-1)*n+1:W)=block2;
                end
            end
        end
    end
end

f=-GSV(C1);

    
            
        



