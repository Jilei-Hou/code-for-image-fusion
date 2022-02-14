clear;
close all
addpath(genpath(pwd));
I1 = imread('1_MRT1.png');
i2 = imread('1_CT.png');
I2=imresize(i2,size(i2)*4);
J(:,:,1) = I1;
J(:,:,2) = I2;

tic
F_echo_dtf = IJF(I1,I2);
toc
Q_echo_dtf = Qp_ABF(I1, I2, F_echo_dtf)
imshow(F_echo_dtf)
figure(2)
imshow(I1)
figure(3)
imshow(I2)
figure(4)
imshow(F_echo_dtf)
imwrite(F_echo_dtf,strcat('D:\Traditional fusion methods\Structure-aware image\Structure-Aware_Image_Fusion-master\Structure-Aware_Image_Fusion-master\tools\1_fmedical','.png'));