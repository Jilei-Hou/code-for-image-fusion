function [ F ] = DSIFT_fusion(I,scale,weighted_average,mode)
%This is the MATLAB implementation of the multi-exposure fusion algorithm described in the following paper: 
%Y. Liu and Z. Wang, "Dense SIFT for ghost-free multi-exposure fusion", 
%Journal of Visual Communication and Image Representation,vol.31,pp.208-224,2015

%Inputs:
%I - a color multi-exposure image sequence

%scale - scale factor of dense SIFT, the default value is 16

%weighted_average - controls the weight distribution strategy, 
%weighted-average if it is set to 1 and winner-take-all otherwise

%mode - controls the fusion mode, static fusion if it is set to 1 and dynamic otherwise

%Output: 
%F - the fused image


[H W C N]=size(I);

imgs=double(I)/255;

imgs_gray=zeros(H,W,N);
for i=1:N
    imgs_gray(:,:,i)=rgb2gray(imgs(:,:,:,i));
end

%dense sift calculation
dsifts=zeros(H,W,32,N, 'single');
for i=1:N
    img=imgs_gray(:,:,i);
    ext_img=img_extend(img,scale/2-1);
    [dsifts(:,:,:,i)] = DenseSIFT(ext_img, scale, 1);
end

%local contrast
contrast_map=zeros(H,W,N);
for i=1:N
    contrast_map(:,:,i)=sum(dsifts(:,:,:,i),3);
end

%weighted-average (weighted_average==1) or winner-take-all (otherwise) 
if weighted_average~=1
    [x labels]=max(contrast_map,[],3);
    clear x;
    for i=1:N
        mono=zeros(H,W);
        mono(labels==i)=1;
        contrast_map(:,:,i)=mono;
    end
end

%exposure quality
exposure_map=ones(H,W,N);
exposure_map((imgs_gray>=0.90)|(imgs_gray<=0.10))=0;

%spatial consistency (only for dynamic fusion)
if mode~=1
    for i=1:N
        [dsifts(:,:,:,i)] = DSIFTNormalization(dsifts(:,:,:,i));
    end
    distance_map=zeros(H,W,N);
    sigma_map=0.05.*ones(H,W);
    ker=ones(19,19)./(19*19);
    for i=1:N
        for j=1:N
            if j~=i
                distance=imfilter(sum((dsifts(:,:,:,i)-dsifts(:,:,:,j)).^2, 3),ker,'replicate');                                   
                distance_map(:,:,i)=distance_map(:,:,i)+exp(-(0.5.*distance)./(sigma_map.^2));                   
            end
        end
    end
    T_map=exposure_map.*distance_map;
else
    T_map=exposure_map;
end

T_map = T_map + 10^-25; %avoids division by zero
T_map = T_map./repmat(sum(T_map,3),[1 1 N]);

weight_map=contrast_map.*T_map;

%weight map refinement
for i=1:N
    weight_map(:,:,i) = RF(weight_map(:,:,i), 100, 4, 3, imgs(:,:,:,i));
end

weight_map = weight_map + 10^-25; %avoids division by zero
weight_map = weight_map./repmat(sum(weight_map,3),[1 1 N]);

%fusion
F=zeros(H,W,3);
for i=1:N
    w = repmat(weight_map(:,:,i),[1 1 3]);
    F=F+imgs(:,:,:,i).*w;
end

end
