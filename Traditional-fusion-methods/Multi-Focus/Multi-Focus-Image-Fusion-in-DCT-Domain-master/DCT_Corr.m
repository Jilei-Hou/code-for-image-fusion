function [FusedDCTCorr,FusedDCTCorr_CV]= DCT_Corr(im1, im2)

% C)Mostafa Amin-Naji, Babol Noshirvani University of Technology,
% My Official Website: www.Amin-Naji.com
% My Email: Mostafa.Amin.Naji@Gmail.com

% PLEASE CITE THE BELOW PAPERS IF YOU USE THIS CODE

% M. A. Naji and A. Aghagolzadeh, “Multi-focus image fusion in DCT domain
% based on correlation coefficient,” in 2015 2nd International Conference
% on Knowledge-Based Engineering and Innovation (KBEI), 2015, pp. 632-639.
% https://doi.org/10.1109/KBEI.2015.7436118 

% Inputs:
%       im1	:	First source image 
%       im2	:	Second source image
%               
% Outputs:
%       FusedDCTCorr	:	Fused image as the result of "DCT+Corr" method
%       FusedDCTCorr_CV	:	Fused image as the result of "DCT+Corr+CV" method
% 
% 
% Sample use:
% im1 = imread('book11.tif');
% im2 = imread('book2.tif');
% [FusedDCTCorr,FusedDCTCorr_CV]= DCT_Corr(im1, im2);


if nargin ~= 2	% Check the correct number of arguments
    error('There should be two input images!')
end

if size(im1,3) == 3     % Check if the images are grayscale
    im1 = rgb2gray(im1);
end
if size(im2,3) == 3
    im2 = rgb2gray(im2);
end

if size(im1) ~= size(im2)	% Check if the input images are of the same size
    error('Size of the source images must be the same!')
end

% The Artificial Blurred images are obtained by passing The Images through a
% low-pass filter (5x5 Averaging Filter)
im1low=imfilter(im1,fspecial('average',5),'symmetric');
im2low=imfilter(im2,fspecial('average',5),'symmetric');

% Get input image size
[m,n] = size(im1);
FusedDCTCorr = zeros(m,n);
FusedDCTCorr_CV = zeros(m,n);
Map = zeros(floor(m/8),floor(n/8));	

% Level shifting
im1 = double(im1)-128;
im2 = double(im2)-128;
im1low = double(im1low)-128;
im2low = double(im2low)-128;

% Divide source images into 8*8 blocks and perform the fusion process
for i = 1:floor(m/8)
    for j = 1:floor(n/8)
        
        im1_Block = im1(8*i-7:8*i,8*j-7:8*j);
        im2_Block = im2(8*i-7:8*i,8*j-7:8*j);
        im1_Block_Blurred = im1low(8*i-7:8*i,8*j-7:8*j);
        im2_Block_Blurred = im2low(8*i-7:8*i,8*j-7:8*j);
        
        %  Compute the 2-D DCT of 8*8 blocks 
        im1_Block_DCT = dct2(im1_Block);
        im2_Block_DCT = dct2(im2_Block);
        im1_Block_Blurred_DCT = dct2(im1_Block_Blurred);
        im2_Block_Blurred_DCT = dct2(im2_Block_Blurred);
        
        % Calculate normalized transform coefficients
        im1Norm = im1_Block_DCT ./ 8;
        im2Norm = im2_Block_DCT ./ 8;
        im1Normlow = im1_Block_Blurred_DCT ./ 8;
        im2Normlow = im2_Block_Blurred_DCT ./ 8;
        
        % Mean value of 8*8 block of images (or DC Coefficient)
        im1ave = mean(mean(im1Norm));
        im2ave = mean(mean(im2Norm));
        im1avelow =  mean(mean(im1Normlow));
        im2avelow = mean(mean(im2Normlow));

%Calculate Correlation Coefficient between im1 and artificial blurred of im1 in DCT domain       
a = im1_Block_DCT - im1ave;
b = im1_Block_Blurred_DCT - im1avelow;
im1cor = sum(sum(a.*b))/sqrt(sum(sum(a.*a))*sum(sum(b.*b)));

%Calculate Correlation Coefficient between im2 and artificial blurred of im2 in DCT domain       
a = im2_Block_DCT - im2ave;
b = im2_Block_Blurred_DCT - im2avelow;
im2cor = sum(sum(a.*b))/sqrt(sum(sum(a.*a))*sum(sum(b.*b)));

 % Fusion Process
        if im1cor > im2cor
            dctCorrBlock = im2_Block_DCT;
            Map(i,j) =+1;	% Consistency verification 
        end
        if im1cor <= im2cor
            dctCorrBlock = im1_Block_DCT;
            Map(i,j) = -1;    % Consistency verification 
        end
        
        % Compute the 2-D inverse DCT of 8*8 blocks and construct fused image
        % DCT+Corr Method
        FusedDCTCorr(8*i-7:8*i,8*j-7:8*j) = idct2(dctCorrBlock);
        
    end
end

% Concistency verification (CV) with Majority Filter (3x3 Averaging Filter)

Filter=fspecial('average',3);

Map_Filtered = imfilter(Map, Filter,'symmetric');	

% The CV process
for i = 1:m/8
    for j = 1:n/8
        
        if Map_Filtered(i,j) < 0
            FusedDCTCorr_CV(8*i-7:8*i,8*j-7:8*j) = im1(8*i-7:8*i,8*j-7:8*j);
        else
            FusedDCTCorr_CV(8*i-7:8*i,8*j-7:8*j) = im2(8*i-7:8*i,8*j-7:8*j);
        end
        
    end
end

% Inverse level shifting 
im1 = uint8(double(im1)+128);
im2 = uint8(double(im2)+128);
FusedDCTCorr = uint8(double(FusedDCTCorr)+128);
FusedDCTCorr_CV = uint8(double(FusedDCTCorr_CV)+128);

% Show Images Table
subplot(2,2,1), imshow(im1), title('Source image 1');
subplot(2,2,2), imshow(im2), title('Source image 2');
subplot(2,2,3), imshow(FusedDCTCorr), title('"DCT+Corr" fusion result');
subplot(2,2,4), imshow(FusedDCTCorr_CV), title('"DCT+Corr+CV" fusion result');

% Good Luck
% Mostafa Amin-Naji ;)
