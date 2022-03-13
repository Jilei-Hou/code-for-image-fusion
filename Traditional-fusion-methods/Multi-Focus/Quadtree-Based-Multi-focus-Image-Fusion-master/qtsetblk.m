function B = qtsetblk(A,S,dim,val)
%--------------------------------------------------------------------------
%QTSETBLK Set block values in quadtree decomposition.
%   J = QTSETBLK(I,S,DIM,VALS) replaces each DIM-by-DIM block in the quadtree
%   decomposition of I with the corresponding DIM-by-DIM block in VALS. S is
%   the sparse matrix returned by QTDECOMP; it contains the quadtree
%   structure. VALS is a DIM-by-DIM-by-K array, where K is the number of
%   DIM-by-DIM blocks in the quadtree decomposition.
%
%   Class Support
%   -------------
%   I can be logical, uint8, uint16, int16, single, or double. S is sparse.
%
%   Remarks
%   -------
%   The ordering of the blocks in VALS must match the columnwise order of the
%   blocks in I. For example, if VALS is 4-by-4-by-2, VALS(:,:,1) contains the
%   values used to replace the first 4-by-4 block in I, and VALS(:,:,2)
%   contains the values for the second 4-by-4 block.
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
%       newvals = cat(3,zeros(4),ones(4));
%       J = qtsetblk(I,S,4,newvals);
%
%   See also QTDECOMP, QTGETBLK.

%   Copyright 1993-2010 The MathWorks, Inc.
%--------------------------------------------------------------------------

narginchk(4,4)

M = size(A,1);

blocks = find(S == dim)';
numBlocks = length(blocks);
if (~isequal([size(val,1) size(val,2) size(val,3)], [dim dim numBlocks]))
    if (numel(val) == numBlocks)
        % Expand values to fill up the dim-by-dim blocks.
        val = repmat(val(:)',[dim^2 1]);
    else
        error(message('images:qtsetblk:wrongDimensions'))
    end
end
val = val(:);

% Compute block indices for a dim-by-dim block.
rows = (0:dim-1)';
cols = 0:M:(dim-1)*M;
rows = rows(:,ones(1,dim));
cols = cols(ones(dim,1),:);
ind = rows + cols;
ind = ind(:);

% Compute index matrix for block computations.
blocks = blocks(ones(length(ind),1),:);
ind = ind(:, ones(1,numBlocks));
ind = ind + blocks;

B = A;
B(ind) = val;
