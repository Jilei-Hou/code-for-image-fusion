function K = GradientFusion(I)
% function GradientFusion.m
%--------------------------------------------------------------------------
% DESCRIPTION of the function:
%     This is the main function for fusion of images. It works for color 
%     (RGB) as well as grayscale images, multi-exposure as well as multi-focus images.
%
% INPUT:
%     I = Set of input images. The image set should be a 4-D array of type 
%         uint8 with the last dimension equal to the number of images in the set.
%         I(:,:,i,j) represents the ith channel of the jth image. 
%         For RGB images, i varies from 1 to 3, and for grayscale images, it is 1.
%         All the images in I should be registered or aligned and should be of
%         the same kind (i.e., either all grayscale, or all color, all having
%         different exposures or different regions in focus)
% 
% OUTPUT: 
%     K = the fused image. It is a single image of the same
%     dimension as each of the input images. 
% 
% Written by : Sujoy Paul, Jadavpur University, 2014
%         At : University of Victoria, Canada
% Modified by: Ioana Sevcenco, University of Victoria, 2014
% 
% Last updated: Nov 19, 2014
% REFERENCES:
% 
% [1] S. Paul, I.S. Sevcenco, P. Agathoklis, "Multi-exposure and
% Multi-focus image fusion in gradient domain", Journal of Circuits,
% Systems and Computers, 2016
% 
% [2] I.S. Sevcenco, P.J. Hampton, P. Agathoklis, "A wavelet based method
% for image reconstruction from gradient data with applications",
% Multidimensional Systems and Signal Processing, November 2013

CG = size(I,3);                                              %Number of channels
if (CG ~= 1)&&(CG ~= 3),
    disp('Images must be single channels (grayscale) or in RGB representation');
    return
end

NumberOfImages = size(I,4);                                  %Number of images

%% Transformation of the color images from RGB to YCbCr
if CG == 3,
    for i = 1:NumberOfImages
         I(:,:,:,i)=rgb2ycbcr(uint8(I(:,:,:,i)));
    end
end

% Cast to double precision
I = double(I);

%% Get the Gradients of Luminance and separate the Chrominance
% Preallocate
xH = zeros(size(I,1),size(I,2),NumberOfImages);
yH = xH;
I_Cb = xH;
I_Cr = xH;
for i = 1:NumberOfImages
    [xH(:,:,i), yH(:,:,i)] = getGradientH(I(:,:,1,i),1);  % Compute gradients of Luminance
    if CG == 3,
        I_Cb(:,:,i) = I(:,:,2,i);                         % Store Cb Chrominance
        I_Cr(:,:,i) = I(:,:,3,i);                         % Store Cr Chrominance
    end
end

%% Obtain the gradient of the Luminance component of the fused image
[fxH, fyH] = getFusedGradients(xH,yH);

%% Get the fused Chrominance components by weighted sum
if CG == 3,
    I_Cb128 = abs(double(I_Cb)-128);
    I_Cr128 = abs(double(I_Cr)-128);
    I_CbNew = sum((I_Cb.*I_Cb128)./repmat(sum(I_Cb128,3),[1 1 NumberOfImages]),3);
    I_CrNew = sum((I_Cr.*I_Cr128)./repmat(sum(I_Cr128,3),[1 1 NumberOfImages]),3);
    I_CbNew(isnan(I_CbNew)) = 128;
    I_CrNew(isnan(I_CrNew)) = 128;
end

%% Reconstruct the luminance from luminance gradient
PoissonOn = 1;   % PoissonOn = 1 to activate the Poisson Solver at each resolution
avg = 0;         % avg represent the mean pixel gray level
R = ReconstructGradient(fxH,fyH,avg,PoissonOn); % This function reconstructs the fused luminance from the gradient data

%% Normalize and enhance the fused image
if CG == 1 %if image is one channel (i.e., in grayscale representation)
    J1 = ChannelNorm(R,[0 255]); % Gamma Correction
    J1 = uint8(J1);
    K = J1;
    K = adapthisteq(K,'NumTiles',[8 8],'ClipLimit',0.003); % Adaptive histogram equalization
else % if image is colour 
    % Luminance and Chrominance comhination for color images 
    J1(:,:,1)=ChannelNorm(R(:,:,1),[16 235]);            %Gamma Correction
    J1 = uint8(J1);
    K = J1;
    K(:,:,2) = I_CbNew;
    K(:,:,3) = I_CrNew;
    K = double(K);
    O = (K(:,:,1)-min(min(K(:,:,1))))/(max(max(K(:,:,1)))-min(min(K(:,:,1)))); %Adaptive histogram equalization
    O = adapthisteq(O,'NumTiles',[8 8],'ClipLimit',0.003)*219+16;
    K(:,:,1) = uint8(O);
    K = ycbcr2rgb(uint8(K));
end
K = uint8(K);
end