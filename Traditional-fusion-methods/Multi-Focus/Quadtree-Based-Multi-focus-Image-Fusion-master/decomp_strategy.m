function result = decomp_strategy(S, NormGrads, dim, num, minGrad, maxGrad)
%--------------------------------------------------------------------------
% Decompose the images according to the decomposition strategy 
%--------------------------------------------------------------------------
   
% Get the gradients of the corresponding blocks
[blockV, Sind] = qtgetblk(NormGrads(:,:,1), S, dim);

% Compute the maxFM and minFM
sumBlock = sum(sum(blockV));
minBlock = sumBlock;
maxBlock = sumBlock;
for i = 2 : num
    [blockV, Sind] = qtgetblk(NormGrads(:,:,i), S, dim);
    tempBlock = sum(sum(blockV));
    minBlock = min(minBlock, tempBlock);
    maxBlock = max(maxBlock, tempBlock);
end

% Compute MDFM: maximum difference in the focus measures
MDFM = abs(minBlock - maxBlock);

% Extract the maximum and minimum gradients of each pair of blocks
[minblockV, Sind] = qtgetblk(minGrad, S, dim);
[maxblockV, Sind] = qtgetblk(maxGrad, S, dim);

maxSum = sum(sum(maxblockV));
minSum = sum(sum(minblockV));
% Compute SMDG: the sum of maximum difference of the gradients
SMDG = abs(maxSum - minSum);

% Compute the threshold T for descriminate whether the block-pair should be split
T = SMDG * 0.98;

% The block-pairs should be split
result = (MDFM > 0) &(MDFM < T);