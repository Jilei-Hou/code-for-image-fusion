%% Fusion of Multi-exposure and Multi-focus images
%
% Version 1.0
% S. Paul(1), I. Sevcenco(2), P. Agathoklis(2)
% (1) Department of Eletronics and Telecommunication Engineerin,
%     Jadavpur University, Kolkata, India
% (2) Department of Electrical and Computer Engineering
%     University of Victoria, Victoria, B.C., Canada
%
% DESCRIPTION of the Code:
%     This is a demo file for executing the fusion of an arbitrary number
%     of grayscale and color images.
%
%     The code can be used to fuse multi-exposure or multi-focus images.
%     The resulting image will have an increased amount of information
%     than the source images.
%
% NOTE: The images to be fused have to be all of the same type
%     (i.e., all in grayscale or all in RGB representation; all
%     multi exposure or all multi focus).
%
% GUIDELINES for running the Code:
%     The input images should be named as ImageName_ImageNumber and should
%     be kept in the same folder as the codes for image fusion.
%
%     For example: An input image stack named 'office' containing 5 images
%     should be named 'office_1', 'office_2', .., 'office_5'
%     The 'office' image stack is part of the MATLAB distribution.
%
%     Specifications to be mentioned in the code:
%         NameImg : A generic name for the set of input images to be fused
%         NumberOfImages : Number of images in the input images stack
%         Format : Format of the input images.
%
% Written by : Sujoy Paul, Jadavpur University, 2014
%         At : University of Victoria, Canada
% Modified by: Ioana Sevcenco, University of Victoria, Canada
% Last updated: Dec 12, 2017
%
% REFERENCES:
%
% [1] S. Paul, I.S. Sevcenco, P. Agathoklis, "Multi-exposure and
% Multi-focus image fusion in gradient domain", Journal of Circuits,
% Systems and Computers, 2016
%
% [2] I.S. Sevcenco, P.J. Hampton, P. Agathoklis, "A wavelet based method
% for image reconstruction from gradient data with applications",
% Multidimensional Systems and Signal Processing, November 2013
clc;
clear; 
close all;
for num=1:60
%     %% Specifications of the set of input images
%     NameImg = strcat('E:\Second_Fusion\multi_focus\对比算法\源数据\图像序列\',num2str(num),'\');                    % Name of the input image set
%     NumberOfImages = 3;                    % Number of images in the input set
%     Format = '.bmp';                       % The format or type of the input images
% 
%     %% Preallocate stack where the images in the input set will be stored
%     tmp = imread(strcat(NameImg,num2str(num-1),Format)); 
%     [s(1),s(2),s(3)]=size(tmp); 
%     clear tmp;
%     I = zeros([s,NumberOfImages]); clear s
%     %% Read the input images

%         I(:,:,:,1) = imread(strcat(NameImg,num2str(num-1),Format));
%         I(:,:,:,2) = imread(strcat(NameImg,num2str(num),Format));
        clear I;
        I(:,:,:,1) = imread(strcat('C:\Users\Train_ir\',num2str(num),'.jpg'));
        I(:,:,:,2)= imread(strcat('C:\Users\Train_vi\',num2str(num),'.jpg'));        
    %% Call the function to fuse the input images
    tic
    G = GradientFusion(I);                 %Main function of image fusion
    time_GD(num)=toc;
    %% Display the fused image
    %%
    % figure,
    % for i = 1:NumberOfImages,
    %     subplot(1,NumberOfImages,i),
    %     imshow(uint8(I(:,:,:,i)));title(['Input image ', num2str(i)]);
    % end

%     text(-1000,7500,'Histograms of grayscale vesions of input images')

%     figure,imshow(G),title('Fused image')
     if num<=10
          imwrite(G, strcat('C:\Users\result','\',num2str(num),'.jpg')); 
      else
         imwrite(G, strcat('C:\Users\result','\',num2str(num),'.jpg')); 
     end
end


