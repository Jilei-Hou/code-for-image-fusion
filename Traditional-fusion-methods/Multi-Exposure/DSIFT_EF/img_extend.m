function extendA=img_extend(A,length)

A=double(A);
[m,n,c]=size(A);
extendA=zeros(m+2*length,n+2*length,c);
for i=1:c    
    extendA(length+1:length+m,length+1:length+n,i)=A(:,:,i);    
end






