function J = ChannelNorm(I,r)
% function ChannelNorm.m
% -------------------------------------------------------------------------
% This function normalizes the image I to a required range using a 
% non-linear transformation 
% 
% Inputs:
%       I = the image (two dimensional array, e.g. an image in grayscale 
%           representation or one channel in a multi-channel image
%           in RGB or YCbCr representaion)
%       r = a vector with two elements representing the minimum and 
%           maximum values of the range onto which the image range has to 
%           be projected;  r = [minimum_value maximum_value];
% Output:
%       J = the image I projected to the desired range r
% 
% Written by : Sujoy Paul, Jadavpur University, 2014
%         At : University of Victoria, Canada
% 
% Modified by: Ioana Sevcenco, University of Victoria, Canada
% 
% Last updated: November 19, 2014
Ran = range(r);
L = range(I(:));
gam = log(Ran)/log(L);
J = Ran*((I-min(I(:)))./(L)).^gam+r(1);
end