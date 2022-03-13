clc; close all; clear all;
tic
%% Loading Images
[~, IBW, H, W, nbframe]=LoadingImg('Demo_from_Helicon_Focus/', 'DSC0', 8953, 8956, '.jpg', 1);

%% Generating in-focus maps
sigma=0.5; %parameter used for computing the gaussian gradient 
threshold_for_quantile=0.8; % parameter used for the threshold of the gaussian gradient
se_size=10; % parameter used for dilating the threshold
InfocusMaps = In_focus_Maps(IBW, sigma, threshold_for_quantile, se_size);

%% Generating in-focus maps and gray leveled pyramids
a=0.5;
InfocusGP=StackGP(InfocusMaps, a);
IBWLP=StackLP(IBW, a);
for i=1:size(InfocusGP.G, 2)
    IBWLP.L{i}=IBWLP.L{i}.*InfocusGP.G{i}; %Pre-selection of the in-focus pixels
end
clearvars InfocusMaps InfocusGP;

%% Fusing the grayed pyramids
FusedLP=PyramidFusion(IBWLP, a);
clearvars IBW IBWLP;

%% Generating all-in-focus BW image
FusedLP=ILP(FusedLP, a);
Iref=FusedLP.G{1}(1:H, 1:W);
clear FusedLP;

%% Showing the fused image
figure;
imshow(Iref);
toc;
