function f=fitness(x)
%-------------------------------------------------------------------------%
%�������ܣ����ݳߴ�x���ж�ͼ��ֿ��ں�
% ����˵����
% x���ֿ�ߴ�
% �����
% f���ںϽ����GSVֵ�ĸ�ֵ��ĳ��׼���µ�ȫ�����ۣ������Ż��㷨�еıȽϣ�
%-------------------------------------------------------------------------%

global A1;
global B1;
global C1;
[H,W]=size(A1);
m=x(1);%�߶ȣ�����
n=x(2);%��ȣ�����
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

    
            
        



