clear all;
close all;
clc;

addpath(genpath('dtcwt_toolbox'));
addpath(genpath('fdct_wrapping_matlab'));
addpath(genpath('nsct_toolbox'));
tic;
% [imagename1 imagepath1]=uigetfile('source_images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image');
% image_input1=imread(strcat(imagepath1,imagename1));    
% [imagename2 imagepath2]=uigetfile('source_images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the second input image');
% image_input2=imread(strcat(imagepath2,imagename2));     
% 
% figure;imshow(image_input1);
% figure;imshow(image_input2);

path='/media/wit/Data/HJL/Code/Dual-discriminator/medical/medical';
% tic;
for k=1:34
            img1 = imread(strcat(path,'/Test_far/',num2str(k),'.png'));
            img2 = imread(strcat(path,'/Test_near_RGB/',num2str(k),'.png'));
%             [cdata,cmap] = imread(strcat(path,'\Test_near_RGB_����\1 (',num2str(k),').png'));
%             img2 = ind2rgb(cdata,cmap)
% figure;imshow(img1);
% figure;imshow(img2);
            tic;

%             img1 = double(img1)/255;
%             img2 = double(img2)/255;
            img2_YUV=ConvertRGBtoYUV(img2);
            img1_gray=img1;
            img2_gray=img2_YUV(:,:,1);
            U=img2_YUV(:,:,2);
            V=img2_YUV(:,:,3);
%             
%             U=imresize(U,size(U)*4);
%             V=imresize(V,size(V)*4);
%             img2_gray=imresize(img2_gray,size(img2_gray)*4);
            [hei, wid] = size(img1_gray);
            image_input1= img1_gray;
            image_input2= img2_gray;




            if size(image_input1)~=size(image_input2)
                error('two images are not the same size.');
            end

            img1=double(image_input1);
            img2=double(image_input2);

%             overlap = 6;                    
%             epsilon=0.1;
%             level=4;

            % To make a comparison, please use 
            % LP-SR for medical image fusion, 
            % DTCWT-SR for visible-infrared image fusion,
            % NSCT-SR for multi-focus image fusion.

            level=4;

%             tic;

            if size(img1,3)==1    %for gray images
                imgf = lp_fuse(img1, img2, level, 3, 3);       %LP
%                 imgf = rp_fuse(img1, img2, level, 3, 3);      %RP
%                 imgf = dwt_fuse(img1, img2, level);           %DWT
%                 imgf = dtcwt_fuse(img1,img2,level);           %DTCWT
%                 imgf = curvelet_fuse(img1,img2,level+1);      %CVT
%                 imgf = nsct_fuse(img1,img2,[2,3,3,4]);        %NSCT
            else               %for color images
                img1=zeros(size(img1));
                for i=1:3
                    imgf(:,:,i) = lp_fuse(img1(:,:,i), img2(:,:,i), level, 3, 3);       %LP
%                     imgf(:,:,i) = rp_fuse(img1(:,:,i), img2(:,:,i), level, 3, 3);      %RP
%                     imgf(:,:,i) = dwt_fuse(img1(:,:,i), img2(:,:,i), level);           %DWT
%                     imgf(:,:,i) = dtcwt_fuse(img1(:,:,i),img2(:,:,i),level);           %DTCWT
%                     imgf(:,:,i) = curvelet_fuse(img1(:,:,i),img2(:,:,i),level+1);      %CVT
%                     imgf(:,:,i) = nsct_fuse(img1(:,:,i),img2(:,:,i),[2,3,3,4]);        %NSCT
                end
            end
%             toc;
% 
%             figure;imshow(uint8(imgf));
%             imwrite(uint8(imgf),'Results/fused_mstsr.tif');
            imgf_YUV=zeros(hei,wid,3);
            
            imgf_YUV(:,:,1)=imgf;
            imgf_YUV(:,:,2)=U;
            imgf_YUV(:,:,3)=V;
            
            imgf_RGB=ConvertYUVtoRGB(imgf_YUV);

%             toc;

%             figure;imshow(uint8(imgf_RGB*255));
%             imwrite(uint8(imgf),strcat('C:\Users\HJL\Desktop\Dual-discriminator\medical\MRISPECT\F_I\',num2str(k),'.png'));
            imwrite(uint8(imgf_RGB),strcat('/media/wit/Data/HJL/Code/Dual-discriminator/medical/LP/',num2str(k),'.png'));
end
toc;