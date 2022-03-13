close all;
clear all;
clc;

% [imagename1, imagepath1]=uigetfile('sourceimages\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the first input image');
% A=imread(strcat(imagepath1,imagename1));    
% [imagename2, imagepath2]=uigetfile('sourceimages\*.jpg;*.bmp;*.png;*.tif;*.tiff;*.pgm;*.gif','Please choose the second input image');
% B=imread(strcat(imagepath2,imagename2));  
for i=1:4
    A  = imread(strcat('C:\Users\HJL\Desktop\far\',num2str(i),'.jpg'));
    B  = imread(strcat('C:\Users\HJL\Desktop\near\',num2str(i),'.jpg'));

    if size(A)~=size(B)
        error('two images are not the same size.');
    end

%     figure,imshow(A);figure,imshow(B);

    %key parameters
    scale=48;
    blocksize=8;
    matching=1;

    tic;
    F=DSIFT_Fusion(A,B,scale,blocksize,matching);
    toc;

%     figure,imshow(F);
    imwrite(F, strcat('C:\Users\HJL\Desktop\result\',num2str(i),'.jpg')); 
end