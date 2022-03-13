function [block_flag,img_flag,edge_flag,edgeimg_flag]=setflag(x)
%-------------------------------------------------------------------------%
%�������ܣ����ø��ֱ�־���������ں��������ȷ������Դ��־ͼ
% ����˵����
% x���ֿ�ߴ�
% �����
% block_flag   ��������Դ��Ϣ����СΪcount_h*count_w
% img_flag     ��block_flag��ÿ��ϸ�������ر�ʾ����СΪH*W
% edge_flag    ��־�߽�飬��СΪcount_h*count_w
% edgeimg_flag ��edge_flag��ÿ��ϸ�������أ���СΪH*W
%-------------------------------------------------------------------------%

global A1;
global C1;
[H,W]=size(C1);
m=x(1);
n=x(2);
count_h=floor(H/m);
count_w=floor(W/n);

block_flag=zeros(count_h,count_w);

%���������ж���Դ
for j=1:count_h
    if j<count_h
        for i=1:count_w
            if i<count_w
                if C1((j-1)*m+1:j*m ,(i-1)*n+1:i*n)==A1((j-1)*m+1:j*m ,(i-1)*n+1:i*n)
                    block_flag(j,i)=1;
                else
                    block_flag(j,i)=2;
                end
            else
                if C1((j-1)*m+1:j*m ,(i-1)*n+1:W)==A1((j-1)*m+1:j*m ,(i-1)*n+1:W)
                    block_flag(j,i)=1;
                else
                    block_flag(j,i)=2;
                end
            end
        end
    else
        for i=1:count_w
            if i<count_w
                if C1((j-1)*m+1:H ,(i-1)*n+1:i*n)==A1((j-1)*m+1:H ,(i-1)*n+1:i*n)
                    block_flag(j,i)=1;
                else
                    block_flag(j,i)=2;
                end
            else
                if C1((j-1)*m+1:H ,(i-1)*n+1:W)==A1((j-1)*m+1:H ,(i-1)*n+1:W)
                    block_flag(j,i)=1;
                else
                    block_flag(j,i)=2;
                end
            end
        end
    end
end

%������������blog_flag��һ��������Χ���Զ���ͬ�Ŀ�Ҫ�ı��־
expand_flag=zeros(count_h+2,count_w+2);
expand_flag(2:count_h+1,2:count_w+1)=block_flag;
for j=2:count_h+1
    for i=2:count_w+1
        if expand_flag(j,i)~=expand_flag(j-1,i)&&expand_flag(j,i)~=expand_flag(j+1,i)&&expand_flag(j,i)~=expand_flag(j,i-1)&&expand_flag(j,i)~=expand_flag(j,i+1)
            if expand_flag(j,i)==1
                block_flag(j-1,i-1)=2;
            else
                block_flag(j-1,i-1)=1;
            end
        end
    end
end

%ϸ��������
img_flag=zeros(size(C1));
for j=1:count_h
    if j<count_h
        for i=1:count_w
            if i<count_w
                if block_flag(j,i)==1
                    img_flag((j-1)*m+1:j*m ,(i-1)*n+1:i*n)=1;
                else
                    img_flag((j-1)*m+1:j*m ,(i-1)*n+1:i*n)=2;
                end
            else
                if block_flag(j,i)==1
                    img_flag((j-1)*m+1:j*m ,(i-1)*n+1:W)=1;
                else
                    img_flag((j-1)*m+1:j*m ,(i-1)*n+1:W)=2;
                end
            end
        end
    else
        for i=1:count_w
            if i<count_w
                if block_flag(j,i)==1
                    img_flag((j-1)*m+1:H ,(i-1)*n+1:i*n)=1;
                else
                    img_flag((j-1)*m+1:H ,(i-1)*n+1:i*n)=2;
                end
            else
                if block_flag(j,i)==1
                    img_flag((j-1)*m+1:H ,(i-1)*n+1:W)=1;
                else
                    img_flag((j-1)*m+1:H ,(i-1)*n+1:W)=2;
                end
            end
        end
    end
end

%ȷ���߽���ܵ�λ�ã�ע�ⲻ����img_flag�������ǲ��ɿ��ģ�Ҫ��block_flag��һ�������������������Դ��ڲ�ͬ����Ϊ�Ǳ߽��
edge_flag=zeros(count_h,count_w);
expand_flag(2:count_h+1,2:count_w+1)=block_flag;
for j=2:count_h+1
    for i=2:count_w+1
        if expand_flag(j,i)==1
            if expand_flag(j-1,i)==2||expand_flag(j+1,i)==2||expand_flag(j,i-1)==2||expand_flag(j,i+1)==2
                edge_flag(j-1,i-1)=1;
            else
                edge_flag(j-1,i-1)=0;
            end
        end
        if expand_flag(j,i)==2
            if expand_flag(j-1,i)==1||expand_flag(j+1,i)==1||expand_flag(j,i-1)==1||expand_flag(j,i+1)==1
                edge_flag(j-1,i-1)=1;
            else
                edge_flag(j-1,i-1)=0;
            end
        end
    end
end

%ϸ��������
edgeimg_flag=zeros(size(C1));
for j=1:count_h
    if j<count_h
        for i=1:count_w
            if i<count_w
                if edge_flag(j,i)==1
                    edgeimg_flag((j-1)*m+1:j*m ,(i-1)*n+1:i*n)=1;
                else
                    edgeimg_flag((j-1)*m+1:j*m ,(i-1)*n+1:i*n)=0;
                end
            else
                if edge_flag(j,i)==1
                    edgeimg_flag((j-1)*m+1:j*m ,(i-1)*n+1:W)=1;
                else
                    edgeimg_flag((j-1)*m+1:j*m ,(i-1)*n+1:W)=0;
                end
            end
        end
    else
        for i=1:count_w
            if i<count_w
                if edge_flag(j,i)==1
                    edgeimg_flag((j-1)*m+1:H ,(i-1)*n+1:i*n)=1;
                else
                    edgeimg_flag((j-1)*m+1:H ,(i-1)*n+1:i*n)=0;
                end
            else
                if edge_flag(j,i)==1
                    edgeimg_flag((j-1)*m+1:H ,(i-1)*n+1:W)=1;
                else
                    edgeimg_flag((j-1)*m+1:H ,(i-1)*n+1:W)=0;
                end
            end
        end
    end
end


                

