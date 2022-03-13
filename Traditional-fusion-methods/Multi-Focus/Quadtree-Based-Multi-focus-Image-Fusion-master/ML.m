function result = ML(g, step, T)
%--------------------------------------------------------------------------    
% ML is the modified Laplacian, which is well-known image gradient for 
% constructing focus measure for multifocus image fusion.   
% Implemented by ZhangYu, Image Processing Center, BUAA
%--------------------------------------------------------------------------
% Input:
%       g: input matrix
%    step: sample distance 
%       T: thresholding value
% Output:
%  result: return the modified Laplacian gradients of the given image g
% Example
%       g = magic(10);
%    step = 1;
%       T = 5;
%  result = = ML(g, step, T);
%--------------------------------------------------------------------------

% Padding the source matrix for convenient computation
domain = ones(2 * step);
gpad = hPadImage(g, domain, 'symmetric');

% Get the dimensions of the image
[M, N] = size(g);
    
% A fast way to compute the SML by using the matrix operations
mat1 = gpad(step + 1 : M + step, step + 1 : N + step);

mat2 = gpad(1 : M, step + 1 : N + step);
mat3 = gpad(2 * step + 1 : M + 2 * step, step + 1 : N + step);

mat4 = gpad(step + 1 : M + step, 1 : N);
mat5 = gpad(step + 1 : M + step, 2 * step + 1 : N + 2 * step);

% Two components
part1 = abs(2 * mat1 - mat2 - mat3);
part2 = abs(2 * mat1 - mat4 - mat5);

result = part1 + part2;  

% Threshold
result(result<T) = 0;