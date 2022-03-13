function [block_flag,img_flag,edge_flag,edgeimg_flag]=setflag(x)
%-------------------------------------------------------------------------%
%函数功能：设置各种标志参数，用于后面产生精确像素来源标志图
% 参数说明：
% x：分块尺寸
% 输出：
% block_flag   保存块的来源信息，大小为count_h*count_w
% img_flag     将block_flag的每块细化到像素表示，大小为H*W
% edge_flag    标志边界块，大小为count_h*count_w
% edgeimg_flag 将edge_flag的每块细化到像素，大小为H*W
%-------------------------------------------------------------------------%

global A1;
global C1;
[H,W]=size(C1);
m=x(1);
n=x(2);
count_h=floor(H/m);
count_w=floor(W/n);

block_flag=zeros(count_h,count_w);

%根据内容判断来源
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

%由连续性修正blog_flag，一个和它周围属性都不同的块要改变标志
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

%细化到像素
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

%确定边界可能的位置，注意不能用img_flag，那样是不可靠的，要用block_flag，一个块如果它四领域块属性存在不同，认为是边界块
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

%细化到像素
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


                

