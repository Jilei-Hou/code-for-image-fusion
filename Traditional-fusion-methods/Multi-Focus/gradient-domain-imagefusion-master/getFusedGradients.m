function [fxH, fyH] = getFusedGradients(gxH,gyH)
% function getFusedGradients.m
%-------------------------------------------------------------------------
% DESCRIPTION of the Code:
%          This function fuses the gradients of several single channel 
%          images by taking the maximum gradient magnitude at each pixel 
%          location. 
%
% INPUTS:
%          gxH and gyH = the x- and y- stacked gradient components of 
%               a set of single channel (e.g., grayscale representation) 
%               input images.
%               Both gxH and gyH should be of double format, with size:
%               Height x Width x NumberOfImagesInTheStack (where Height and
%               Width are the common dimensions of all images in the
%               stack)
%           
%          gxH(:,:,i) and gyH(:,:,i) represent the x- and y-gradient components
%               of the ith image in the stack; the index i varies from 
%               1 to the total number of images in the stack.
%
% OUTPUTS:
%          fxH and fyH = the horizontal and vertical gradient components 
%               from which the single channel fused image will be reconstructed
%               (outside this function)
% 
% Written by : Sujoy Paul, Jadavpur University, 2014
%         At : University of Victoria, Canada
% Modified by: Ioana Sevcenco, University of Victoria, Canada
% Last updated: Nov. 19, 2014

v = (gxH.^2+gyH.^2).^0.5;            % Compute gradient magnitudes
N = size(gxH);
[~, pos] = max(v,[],3);
T = zeros(N); % preallocate T
for i = 1:N(3)
    T(:,:,i)=ones(N(1:2))*i;
end
Index = (T==repmat(pos,[1 1 N(3)]));
fxH = sum(gxH.*Index,3);
fyH = sum(gyH.*Index,3);

end