function f=SF(A) 
%spatial frequency

A=double(A);
[m,n]=size(A);
df_c=A(2:m,:)-A(1:m-1,:);
df_r=A(:,2:n)-A(:,1:n-1);
mean_c=sum(sum(df_c.^2))/(m*n);
mean_r=sum(sum(df_r.^2))/(m*n);
f=sqrt(mean_c+mean_r);


