function [I2, LvlMax] = PaddZeros(I1)
% This function padd the images I1 with zeros so that the size of image is the nearest power of two plus 1.
  [row, col, Nbframe]=size(I1);
  Nrow=ceil(log(row)/log(2));
  Ncol=ceil(log(col)/log(2));
  N=max([Nrow, Ncol]);
  S=(2^N)+1;
  I2=zeros(S, S, Nbframe);
  I2(1:row, 1:col, :)=I1;
  LvlMax=N;
end
