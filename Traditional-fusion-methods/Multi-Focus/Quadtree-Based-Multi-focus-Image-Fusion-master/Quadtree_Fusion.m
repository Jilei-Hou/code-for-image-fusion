function [fimg, Fusion_decision_map] = Quadtree_Fusion(name, type, num, level,num_set)
%--------------------------------------------------------------------------
% Quadtree based image fusion with the weighted focus-measure
%--------------------------------------------------------------------------

% ----------------- Get dimensions of multi-focus images ------------------
img = double(imread (strcat('E:\Second_Fusion\multi_focus\对比算法\源数据\图像序列\', num2str(num_set),'\', num2str(num_set-1), type)));
[p1,p2,p3] = size(img);


% -------------------- Compute the normalized dimensions ------------------
% Normalize the image dimensions to 2 ^ X
NormDim = normalize_dim(p1, p2);

% If the maxDim == 2048, exit the program
if (NormDim == 4000)
    disp('Image size is too big, it cannot process!');
    return;
end


% ---------------------- Read the multi-focus images ----------------------
mImg=zeros(p1, p2, num);
for q=num_set:num_set+1
    img = double(imread (strcat('E:\Second_Fusion\multi_focus\对比算法\源数据\图像序列\', num2str(num_set),'\', num2str(q-1), type)));
    mImg(:,:,q)=img;
end


% ------------------- Compute the gradient maps ---------------------------
% Initialization of the Paras in WML:step, threshold and block size
step = 1; T = 5; bsz = 17;

% Compute the weighted modified laplacian gradients of the images
Grads = zeros(p1, p2, num);
for kk = 1 : num
    img = mImg( : , : , kk);
    Grad = WML(img, step, T, bsz);
    Grads(:,:,kk) = Grad;
end


%--------------- Extend mImgs and Grads to maxDim( 2 ^ X ) ----------------
% If we put the images on the leftup coner of the extended image;
% NormGrads = zeros(maxDim, maxDim, num);
% NormGrads(1 : p1, 1 : p2, : ) = FMs;

% Elseif we center the images and the gradient maps on the extended
% images or maps
dx = ceil((NormDim - p1) / 2);
dy = ceil((NormDim - p2) / 2);

NormGrads = zeros(NormDim, NormDim, num);
NormGrads(dx + 1 : dx + p1, dy + 1 : dy + p2, : ) = Grads;


%------------------------- Quad-tree decomposition  -----------------------
% Set the Default level, when not set level
if level == 0
    level = log2(NormDim);
end

% Quad tree docomposition and decision map detection
[Quadtree_Structure, Fusion_decision_map, maxGrad] = quad_decomp(NormDim, NormGrads, num, level);


%-------------------- Decision map reconstruction -------------------------
% If we put the image on the left up coner of the extended image;
% Fusion_decision_map = Fusion_decision_map(1 : p1, 1 : p2); 

% Elseif we put the source image on the center of the extended image, 
% extract the fusion decision map from the extended map
Fusion_decision_map = Fusion_decision_map(dx + 1 : dx + p1, dy + 1 : dy + p2);
maxGrad = maxGrad(dx + 1 : dx + p1, dy + 1 : dy + p2);

% First Filter: Open and Close morphilogical filtering
Iter = 1;
Fusion_decision_map = morph_filter(Fusion_decision_map, num, Iter);

% Second Filter: Fiter small blocks inside
smallsz = p1 * p2 / 40;
Fusion_decision_map = Small_Block_Filter(Fusion_decision_map, num, smallsz);


%------------------------------ Image Fusion  -----------------------------
% Initialize the fusion image
fimg = zeros(p1,p2);

% Firstly, fusing the defined part, copied directly according to the decision map
for ii = 1 : num	
    fimg = fimg + mImg(:,:,ii) .* (Fusion_decision_map == ii);
end


% Secondly, fusing the non-defined part, copied by maximum selection method
max_tag = zeros(p1, p2, num);
img_tag = zeros(p1, p2);

% Find the pixels with the maximum gradients from each gradient map
for ii = 1 : num
    tag = (Grads(:,:,ii) == maxGrad);
    max_tag(:,:,ii) = tag;
    img_tag = img_tag + tag .* ii;
end

% The nonpart images and maximum selection
non_part = (Fusion_decision_map < 1);
nonImgs = mImg;
part1 = zeros(p1,p2);
for ii = 1 : num
    nonImgs(:,:,ii) = nonImgs(:,:,ii) .* non_part;
    part1 = part1 + nonImgs(:,:,ii) .* max_tag(:,:,ii);
end

% Finding the positions where more than one Grad(i) have the maxGrad
max_num = sum(max_tag, 3);

% The sigle and multiple positions
single_num = (max_num == 1);
multi_num = 1 - single_num;

% If there are more than one image grad(i) equal to maxGrad
part2 = sum(nonImgs, 3) ./ num;

% As to the whole nonpart
nonPart = part1 .* single_num + part2 .* multi_num;

% Final Fused image, which is conbined by the fusion images of the defined
% part and the non-part
fimg = uint8(fimg + nonPart);