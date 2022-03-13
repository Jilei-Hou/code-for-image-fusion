function [I_eq]=Heq( I )
N=size(I,4);
for i=1:N
I_eq(:,:,:,i)=histeq1(double(I(:,:,:,i)));
end