function A = hPadImage(A, domain, padopt)
%--------------------------------------------------------------------------    
% hPadImage is a method to extend the maxtrix symmetrically or with zeros or ones 
% Modified by ZhangYu, Image Processing Center, BUAA
%--------------------------------------------------------------------------
% Input:
%            A: input matrix
%       domain: extention size
%       padopt: padding image format
% Output:
%      A: return the padded image
% Example
%       A = magic(10);
%       domain = ones(3);
%       padopt = 'symmetric';
%       A = hPadImage(A, domain, padopt);
%--------------------------------------------------------------------------

% pad the image suitably - 
domainSize = size(domain);
center = floor((domainSize + 1) / 2);

[r,c] = find(domain);
r = r - center(1);
c = c - center(2);

padSize = [max(abs(r)) max(abs(c))];
if (strcmp(padopt, 'zeros'))
    A = padarray(A, padSize, 0, 'both');
elseif (strcmp(padopt, 'ones'))
    A = padarray(A, padSize, 1, 'both');
elseif (strcmp(padopt, 'symmetric'))
    A = padarray(A, padSize, 'symmetric', 'both');
else
%   This block should never be reached.
    error(message('images:maxnumfilt2:incorrectPaddingOption'))
end