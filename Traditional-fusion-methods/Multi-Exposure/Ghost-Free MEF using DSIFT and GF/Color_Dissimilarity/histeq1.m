function [I] = histeq1( I1 )
r1=I1(:,:,1);
g1=I1(:,:,2);
b1=I1(:,:,3);
n=256; 
r1 = histeq(double(r1),n); 
g1 = histeq(double(g1),n); 
b1 = histeq(double(b1),n);
I=cat(3,r1,g1,b1);

