function [w2d] = Kernel(a)
% This function computes a kernel used for expanding and reducing images of the pyramid with the parameter a.
  w1d=[1/4-a/2; 1/4 ;a; 1/4; 1/4-a/2];
  w2d=w1d*w1d';
end
