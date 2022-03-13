function [Gl0] =Expand(Gl1, a)
% This function retrieves the floor Gl1 of the gaussian pyramid with the parameter a for the gaussian kernel to compute an expansion
% of the floor at the size of the previous floor.
  w=Kernel(a); %Gaussian kernel
  [Rl1, Cl1, Nbframe]=size(Gl1); %Size of the floor Gl1
  %Expansion of the floor Gl1
  Gl0=zeros((Rl1-1)*2+1, (Cl1-1)*2+1, Nbframe);
  Gl0(1:2:end, 1:2:end, :)=Gl1;
  Gl0=4*convn(Gl0, w, 'same');	
end
