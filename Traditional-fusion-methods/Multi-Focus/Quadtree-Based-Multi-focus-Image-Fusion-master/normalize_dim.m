function NormDim = normalize_dim(d1, d2)
%--------------------------------------------------------------------------
% Normalize the image dimensions to 2 ^ X
% Implemented by Zhang Yu
%--------------------------------------------------------------------------

dim = max(d1, d2);
NormDim = 1024;
while(dim < NormDim || dim == NormDim)
    NormDim = NormDim / 2;
end
NormDim = NormDim * 2;
