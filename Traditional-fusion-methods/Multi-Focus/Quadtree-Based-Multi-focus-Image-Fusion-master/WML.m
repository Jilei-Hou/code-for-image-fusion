function result = WML(img, step, T, bsz)
%--------------------------------------------------------------------------
% Weighted modified laplacian proposed in quadtree based multi-focus image
% fusion using a weighted focus-measure
% Implemented by Yu Zhang
%--------------------------------------------------------------------------

% First, compute the modified Laplacian gradients
mlg = ML(img, step, T);
% Then, sum the ML gradients with local weights
result = Local_Weight(mlg, bsz);