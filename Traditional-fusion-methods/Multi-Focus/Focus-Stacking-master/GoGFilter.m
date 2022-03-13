function [IGoGMag, IGoGArg]= GoGFilter(I, sigma) 
% This function computes the magnitude and argument of the gaussian gradient of the image I with the smoothing parameter sigma which usually is less than 1.
     [Ix, Iy]=GoGFilterXY(I, sigma);
     IGoGMag=(Ix.^2+Iy.^2).^0.5;
     IGoGArg=atan2(Iy, Ix);
end

function [IGoGx, IGoGy]= GoGFilterXY(I, sigma)
% This function computes the gaussian gradient (along X and Y) of the image I with the smoothing parameter sigma which usually is less than 1.
     x=-2:2; % Size of kernel 5x5
     y=x;
     [X, Y]=meshgrid(x, y);
     GoGx=exp(-(X.^2+Y.^2)/(2*sigma^2)).*(-X)/(2*pi*sigma^4);
     GoGy=exp(-(X.^2+Y.^2)/(2*sigma^2)).*(-Y)/(2*pi*sigma^4)';
     IGoGx=convn(I, GoGx, 'same');
     IGoGy=convn(I, GoGy, 'same');
end
