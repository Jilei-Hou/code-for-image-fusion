function [dxH, dyH] = getGradientH(ConservativeField,bd)
% program getGradientH.m
%-------------------------------------------------------------------------
% This program computes the Hudgin derivatives of a 2D array;
% Discretization used: forward difference approximation.
% Input:
%   ConservativeField = 2d array, such as a grayscale digital image
%   bd = Optional input: a flag that allows user to opt for Neumann boundary conditions
%        set to 1 if Neumann boundary conditions are required
% Output:
%   dxH, dyH = Hudgin gradient horizontal and vertical components
% Written by: Ioana Sevcenco, University of Victoria, Canada
% Last updated: May 25, 2014

dxH = ConservativeField(:,2:end,:) - ConservativeField(:,1:end-1,:);
dyH = ConservativeField(2:end,:,:) - ConservativeField(1:end-1,:,:);
if nargin > 1,
    if bd,
        dxH = padarray(dxH,[0,1],'post');
        dyH = padarray(dyH,[1,0],'post');
    end
end

end