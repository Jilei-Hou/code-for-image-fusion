function [ F ] = DSIFT_exposure_fusion(I,scale,mode)
%This is the MATLAB implementation of the multi-exposure fusion algorithm described in the following paper: 
%N. Hayat and M. Imran, "Ghost-free Multi Exposure Image Fusion using the Dense SIFT Discriptor and the Guided Filter", 

%Inputs:
%I - a color multi-exposure image sequence

%scale - scale factor of dense SIFT, the default value is 16

%mode - controls the fusion mode, static fusion if it is set to 1 and dynamic otherwise

%Output: 
%F - the fused image

addpath('Pyramid_Decomposition');
addpath('Guided_Filter');
addpath('Dense_SIFT');
addpath('Color_Dissimilarity');

tic

[H W C N]=size(I);

    
imgs=double(I)/255;
% 
% 
 imgs_gray=zeros(H,W,N);
 for i=1:N
     imgs_gray(:,:,i)=rgb2gray(imgs(:,:,:,i));
 end
% 
% %dense sift calculation
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

% winner-take-all weighted average strategy for local contrast 

    [x labels]=max(contrast_map,[],3);
    clear x;
    for i=1:N
        mono=zeros(H,W);
        mono(labels==i)=1;
        contrast_map(:,:,i)=mono;
    end


%Brightness Feature
 exposure_map=ones(H,W,N);
 exposure_map((imgs_gray>=0.90)|(imgs_gray<=0.10))=0;

% Color Dissimilarity Feature (only for dynamic fusion)

 I_eq=Heq(double(imgs));
 med_map=median(I_eq,4);
 cost2=distance_map(I_eq,med_map,1,3,30); 
 
 if mode==1

    T_map=exposure_map.*cost2.*contrast_map;
 else
   T_map=exposure_map.*contrast_map;  
 end

weight_map=T_map;

%weight map refinement using Guided Filter
   for i=1:N

  weight_map(:,:,i) = fastGF( weight_map(:,:,i),12,0.25,2.5); 

  end
 
% normalizing weight maps 
% 
  weight_map = weight_map + 10^-25; %avoids division by zero
  weight_map = weight_map./repmat(sum(weight_map,3),[1 1 N]);
 
% Pyramid Decomposition

% create empty pyramid
pyr = gaussian_pyramid(zeros(H,W,3));
nlev = length(pyr);

% multiresolution blending
for i = 1:N
    % construct pyramid from each input image
	pyrW = gaussian_pyramid(weight_map(:,:,i));
	pyrI = laplacian_pyramid(imgs(:,:,:,i));
    
    % blend
    for b = 1:nlev
        w = repmat(pyrW{b},[1 1 3]);
        
        pyr{b} = pyr{b} + w .*pyrI{b};
    end
end

% reconstruct
F = reconstruct_laplacian_pyramid(pyr);
toc
   
end

