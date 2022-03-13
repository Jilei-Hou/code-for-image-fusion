function [Gl1] =Reduce(Gl0, a)
% This function reduces by half the image Gl0 with the parameter a used for blurring before the downsampling.
  w=Kernel(a);
  Gl0=convn(Gl0, w, 'same');
  Gl1=Gl0(1:2:end, 1:2:end, :);
end
