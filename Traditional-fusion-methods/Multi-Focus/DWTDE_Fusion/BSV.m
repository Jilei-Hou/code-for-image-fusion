function f=BSV(A)
%-------------------------------------------------------------------------%
%函数功能：计算A在某个评价准则意义下的函数值（B表示每块block）
% 参数说明：
% A：输入图像
% 输出：
% f：A在某个评价准则意义下的函数值，最终选取的是EOG
%-------------------------------------------------------------------------%
A=double(A);
%VAR
%f=var(A(:),1);

% %SF
% [m,n]=size(A);
% df_c=A(2:m,:)-A(1:m-1,:);
% df_r=A(:,2:n)-A(:,1:n-1);
% mean_c=sum(sum(df_c.^2))/(m*n);
% mean_r=sum(sum(df_r.^2))/(m*n);
% f=sqrt(mean_c+mean_r);

%EOG
[h w]=size(A);
if h>1 && w>1
    [dx,dy]=gradient(A);
    f=sum(sum(dx.^2+dy.^2));
else
    d=gradient(A);
    f=sum(d.^2);
end
    

% %SML
% hx=[-1 2 -1];
% hy=[-1 2 -1]';
% dx2=imfilter(A,hx);
% dy2=imfilter(A,hy);
% d2=abs(dx2)+abs(dy2);
% f=sum(sum(d2));
