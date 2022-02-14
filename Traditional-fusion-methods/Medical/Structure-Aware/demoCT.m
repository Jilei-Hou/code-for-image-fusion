clear all
clc

path='/media/wit/Data1/HJL/Code/Dual-discriminator/medical/medical';
addpath(genpath(pwd));

num=1:34;
tic
for n=1:length(num)
    k=num(n)
    im1 = im2double(imread(strcat(path,'/Test_far/',num2str(k),'.png')));
    im2 = im2double(imread(strcat(path,'/Test_near_RGB/',num2str(k),'.png')));
    im2_ihs=rgb2ihs(im2);
    i=im2_ihs(:,:,1);
    v1=im2_ihs(:,:,2);
    v2=im2_ihs(:,:,3);
    
%     I=imresize(im2,size(im2)*1);
%     V1=imresize(v1,size(v1)*1);
%     V2=imresize(v2,size(v2)*1);
%     
%     figure(1);
%     subplot(131);imshow(im1);
%     subplot(132);imshow(I);
%     
%      tic
     F_I = im2double(IJF(im1,i));
     time(n)=toc
     F_IHS=cat(3,F_I,v1,v2);
    
     F=ihs2rgb(F_IHS);
% 
%     subplot(133);imshow(F);
%    imwrite(F_I,strcat('D:\Traditional fusion methods\comparision\Structure-Aware\my_fused_CD\',num2str(k),'.png'));
%     imwrite(F,strcat('D:\Traditional fusion methods\comparision\Structure-Aware\my_fused_imgs\',num2str(k),'.png'));
      imwrite(F,strcat('/media/wit/Data1/HJL/Code/Dual-discriminator/medical/StructureAware/',num2str(k),'.png'));

end
toc