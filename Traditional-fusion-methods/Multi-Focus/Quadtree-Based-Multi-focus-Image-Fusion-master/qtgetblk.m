function [val,r,c] = qtgetblk(A,S,dim)
%--------------------------------------------------------------------------
%QTGETBLK Get block values in quadtree decomposition.
%   [VALS,R,C] = QTGETBLK(I,S,DIM) returns in VALS an array containing the
%   DIM-by-DIM blocks in the quadtree decomposition of I. S is the sparse
%   matrix returned by QTDECOMP; it contains the quadtree structure. VALS is a
%   DIM-by-DIM-by-K array, where K is the number of DIM-by-DIM blocks in the
%   quadtree decomposition; if there are no blocks of the specified size, all
%   outputs are returned as empty matrices. R and C are vectors containing the
%   row and column coordinates of the upper-left corners of the blocks.
%
%   [VALS,IDX] = QTGETBLK(I,S,DIM) returns in IDX a vector containing the
%   linear indices of the upper-left corners of the blocks.
%
%   Class Support
%   -------------
%   I can be logical, uint8, uint16, int16, single, or double. S is sparse.
%
%   Remarks
%   -------
%   The ordering of the blocks in VALS matches the columnwise order of the
%   blocks in I. For example, if VALS is 4-by-4-by-2, VALS(:,:,1) contains the
%   values from the first 4-by-4 block in I, and VALS(:,:,2) contains the
%   values from the second 4-by-4 block.
%
%   Example
%   -------
%       I = [1    1    1    1    2    3    6    6
%            1    1    2    1    4    5    6    8
%            1    1    1    1   10   15    7    7
%            1    1    1    1   20   25    7    7
%           20   22   20   22    1    2    3    4
%           20   22   22   20    5    6    7    8
%           20   22   20   20    9   10   11   12
%           22   22   20   20   13   14   15   16];
%
%       S = qtdecomp(I,5);
%       [vals,r,c] = qtgetblk(I,S,4);
%
%   See also QTDECOMP, QTSETBLK.

%   Copyright 1993-2009 The MathWorks, Inc.
%--------------------------------------------------------------------------

narginchk(3,3);

M = size(A,1);

Sind = find(S == dim);
numBlocks = length(Sind);
if (numBlocks == 0)
    % Didn't find any blocks.
    val = zeros(dim,dim,0);
    r = zeros(0,1);
    c = zeros(0,1);
    return;
end

% Compute block indices for a dim-by-dim block.
rows = (0:dim-1)';
cols = 0:M:(dim-1)*M;
rows = rows(:,ones(1,dim));
cols = cols(ones(dim,1),:);
ind = rows + cols;
ind = bsxfun(@plus, ind(:), Sind');

val = A(ind);

val = reshape(val, [dim dim numBlocks]);

if (nargout == 2)
    r = Sind;
    
elseif (nargout == 3)
    [r,c] = find(S == dim);
end

