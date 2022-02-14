clear all;
close all;
clc;

addpath(genpath('sparsefusion'));
addpath(genpath('dtcwt_toolbox'));
addpath(genpath('fdct_wrapping_matlab'));
addpath(genpath('nsct_toolbox'));

load('sparsefusion/Dictionary/D_100000_256_8.mat');

% [imagename1 imagepath1]=uigetfile('source_images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image');
% image_input1=imread(strcat(imagepath1,imagename1));    
% [imagename2 imagepath2]=uigetfile('source_images\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the second input image');
% image_input2=imread(strcat(imagepath2,imagename2));     
% 
% figure;imshow(image_input1);
% figure;imshow(image_input2);

path='C:\Users\张浥尘\Desktop\Second_Fusion\Medical_image\中间处理\bmp';

for k=1:78
            img1 = imread(strcat(path,'\vi\',num2str(k),'.bmp'));
            img2 = imread(strcat(path,'\ir\',num2str(k),'.bmp'));
%             img2 = imresize(img2,size(img2)*4);
% figure;imshow(img1);
% figure;imshow(img2);
            

%             img1 = double(img1)/255;
%             img2 = double(img2)/255;
            img2_YUV=ConvertRGBtoYUV(img2);
            img1_gray=img1;
            img2_gray=img2_YUV(:,:,1);
            U=img2_YUV(:,:,2);
            V=img2_YUV(:,:,3);
            
            U=imresize(U,size(U));
            V=imresize(V,size(V));
            img2_gray=imresize(img2_gray,size(img2_gray));
            [hei, wid] = size(img1_gray);
            image_input1= img1_gray;
            image_input2= img2_gray;



            tic;
            if size(image_input1)~=size(image_input2)
                error('two images are not the same size.');
            end

            img1=double(image_input1);
            img2=double(image_input2);

            overlap = 6;                    
            epsilon=0.1;
            level=4;

            % To make a comparison, please use 
            % LP-SR for medical image fusion, 
            % DTCWT-SR for visible-infrared image fusion,
            % NSCT-SR for multi-focus image fusion.

            tic;
            if size(img1,3)==1    %for gray images
                imgf = lp_sr_fuse(img1,img2,level,3,3,D,overlap,epsilon);      %LP-SR
                %imgf = rp_sr_fuse(img1,img2,level,3,3,D,overlap,epsilon);     %RP-SR
                %imgf = dwt_sr_fuse(img1,img2,level,D,overlap,epsilon);        %DWT-SR
                %imgf = dtcwt_sr_fuse(img1,img2,level,D,overlap,epsilon);      %DTCWT-SR
                %imgf = curvelet_sr_fuse(img1,img2,level+1,D,overlap,epsilon); %CVT-SR
                %imgf = nsct_sr_fuse(img1,img2,[2,3,3,4],D,overlap,epsilon);   %NSCT-SR
            else                  %for color images
                imgf=zeros(size(img1));
                for i=1:3
                    imgf(:,:,i) = lp_sr_fuse(img1(:,:,i),img2(:,:,i),level,3,3,D,overlap,epsilon);      %LP-SR
                    %imgf(:,:,i) = rp_sr_fuse(img1(:,:,i),img2(:,:,i),level,3,3,D,overlap,epsilon);     %RP-SR
                    %imgf(:,:,i) = dwt_sr_fuse(img1(:,:,i),img2(:,:,i),level,D,overlap,epsilon);        %DWT-SR
                    %imgf(:,:,i) = dtcwt_sr_fuse(img1(:,:,i),img2(:,:,i),level,D,overlap,epsilon);      %DTCWT-SR
                    %imgf(:,:,i) = curvelet_sr_fuse(img1(:,:,i),img2(:,:,i),level+1,D,overlap,epsilon); %CVT-SR
                    %imgf(:,:,i) = nsct_sr_fuse(img1(:,:,i),img2(:,:,i),[2,3,3,4],D,overlap,epsilon);   %NSCT-SR
                end
            end
            time(k+1)=toc;
%             toc;
% 
%             figure;imshow(uint8(imgf));
%             imwrite(uint8(imgf),'Results/fused_mstsr.tif');
            imgf_YUV=zeros(hei,wid,3);
            
            imgf_YUV(:,:,1)=imgf;
            imgf_YUV(:,:,2)=U;
            imgf_YUV(:,:,3)=V;
            
            imgf_RGB=ConvertYUVtoRGB(imgf_YUV);

            

%             figure;imshow(uint8(imgf_RGB*255));
%             imwrite(uint8(imgf),strcat('E:\comparision\7_MST_SR_fusion_toolbox\MST_SR_fusion_toolbox\Results\4my_MRIPET_result\F_I\',num2str(k),'.png'));
%             imwrite(uint8(imgf_RGB),strcat('E:\comparision\7_MST_SR_fusion_toolbox\MST_SR_fusion_toolbox\Results\4my_MRIPET_result\F\',num2str(k),'.png'));
      if k<=10
        imwrite(uint8(imgf),strcat('C:\Users\张浥尘\Desktop\Second_Fusion\对比算法指标\Medical\算法结果\结果汇总\MST_SR\原输出\','F9_0',num2str(k-1),'.bmp'));
      else
        imwrite(uint8(imgf),strcat('C:\Users\张浥尘\Desktop\Second_Fusion\对比算法指标\Medical\算法结果\结果汇总\MST_SR\原输出\','F9_',num2str(k-1),'.bmp'));
      end
      disp(strcat('last',num2str(78-k)));
end
