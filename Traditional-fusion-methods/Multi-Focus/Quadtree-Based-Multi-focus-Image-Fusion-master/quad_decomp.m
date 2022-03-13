function [Quadtree_Structure, Fusion_Decision_Map, maxGrad] = quad_decomp(NormDim, NormGrads, num, Def_level)
%--------------------------------------------------------------------------
% quad_decomp is the function to decompose the input images 
% into a quadtree structure
%--------------------------------------------------------------------------

%--------- Computing the minGrad, maxGrad and sumGrad at each pixel -------
minGrad = NormGrads(:,:,1);
maxGrad = minGrad;
for ii = 2 : num
    minGrad = min(minGrad, NormGrads(:,:,ii));
    maxGrad = max(maxGrad, NormGrads(:,:,ii));
end


%------------------- Decomposition of the source images -------------------
% Initialize quadtree structure
S = zeros(NormDim, NormDim);
S(1, 1) = NormDim;

% Set the parameters for quadtree decomposition
dim = NormDim;                          % Initial dim
maxlevel = floor(log2(NormDim));        % Maximum decomposition level
maxlevel = min(maxlevel, Def_level);    % Choose the maximum permitted level
level = 1;                              % Intial level: whole image

% iterative decomposition
while (level < maxlevel)	
    % Extract the blocks at the current level
    [blockVal0, Sind] = qtgetblk(S, S, dim);

    % End condition
    if (isempty(Sind))
        % Done!
        break;
    end

    % Discriminate the block-pairs, which should be split according to the
    % decomposition strategy
    doSplit = decomp_strategy(S, NormGrads, dim, num, minGrad, maxGrad);

    % the dimension in the next level
    dim = dim/2;

    % Split blocks for doSplit == 1 
    Sind = Sind(doSplit);
    Sind = [Sind ; Sind+dim ; (Sind+NormDim*dim) ; (Sind+(NormDim+1)*dim)];
    S(Sind) = dim;

    % Decomposit in the next level
    level = level + 1;
end


%---------------------- Detecting the focused blocks ----------------------
% Initialise data
S = sparse(S);
dim = NormDim;
level = 1;

% Define a tag for most FM images
FM_tag = zeros(NormDim, NormDim);

% Begin loop
while (level <= maxlevel)

    len = length(find(S == dim));
    if len ~= 0
        values = zeros(num, len);
        for i = 1 : num
            % Extrat the corresponding blocks at the current level
            [BlockGrad, Sind] = qtgetblk(NormGrads(:,:,i), S, dim);

            % Compute focus-measure of the blocks
            values(i,:) = sum(sum(BlockGrad));
        end

        % Calculate the maximum focus-measure of the corresponding blocks
        maxVals = max(values);

        % Find the image indices of the blocks with maximum focus-measure
        is_equal = zeros(1, len);
        eq_count = is_equal;
        index = is_equal;

        for i = 1 : num
           is_equal = (maxVals == values(i, : ));
           eq_count = eq_count + is_equal;
           index = index + is_equal * i;
        end

        index = index .* (eq_count == 1) + (-1) * (eq_count > 1);

        % Detecting the focused blocks
        blocktag = zeros(size(BlockGrad));
        for i = 1 : len
            blocktag( : , : , i) = index(1, i);
        end

        % Set the fusion tag as the image indices of the focused blocks
        FM_tag = qtsetblk(FM_tag,S,dim,blocktag);
    end

    % Next scale
    dim = dim/2;
    level = level + 1;
end	

% The fusion decision map, which is the image indices of the focused blocks
Fusion_Decision_Map = FM_tag;
Quadtree_Structure = S;