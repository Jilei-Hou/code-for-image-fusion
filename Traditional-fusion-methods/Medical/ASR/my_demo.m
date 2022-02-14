clear all
clc

path='C:\Users\HJL\Desktop\medical';


num=1:34;
for n=1:length(num)
    k=num(n)
    t1 = im2double(imread(strcat(path,'\Test_far\',num2str(k),'.png')));
    im2 = im2double(imread(strcat(path,'\Test_near_RGB\',num2str(k),'.png')));
    im2_ihs=rgb2ihs(im2);
    i=im2_ihs(:,:,1);
    v1=im2_ihs(:,:,2);
    v2=im2_ihs(:,:,3);
    
    I=imresize(i,size(i)*1);
    V1=imresize(v1,size(v1)*1);
    V2=imresize(v2,size(v2)*1);
    
%     figure(1);
%     subplot(131);imshow(t1);
%     subplot(132);imshow(I);
    
    
    tic;
    %%% ASR fusion
    image_input1=t1;
    image_input2=I;
    sigma = 0; %standard deviation of added noise, sigma<=0 means images are not corrupted by noise
    if sigma>0
        v=sigma*sigma/(255*255);
        image_input1=imnoise(image_input1,'gaussian',0, v );
        image_input2=imnoise(image_input2,'gaussian',0, v );
%         figure;imshow(image_input1);
%         figure;imshow(image_input2);
    end
    
    img1=double(image_input1);
    img2=double(image_input2);
    
    addpath(genpath('ksvdbox'));
    dic_size=256; % 256 or 128
    load(['Dictionary/D_100000_' num2str(dic_size) '_8_0.mat']); %the first sub-dictionary 'D'
    load(['Dictionary/D_100000_' num2str(dic_size) '_8_6.mat']); %other sub-dictionaries 'Dn' and the number is 'dic_number'
    overlap = 7;
    epsilon = 0.1;
    C = 1.15;
    
    if size(img1,3)==1   %for gray images
        imgf=asr_fuse(img1,img2,D,Dn,dic_number,overlap,8*C*sigma+epsilon);
    else                 %for color images
        imgf=zeros(size(img1));
        for i=1:3
            imgf(:,:,i)=asr_fuse(img1(:,:,i),img2(:,:,i),D,Dn,dic_number,overlap,8*C*sigma+epsilon);
        end
    end
    
    F_I=imgf;
    F_IHS=cat(3,F_I,V1,V2);
    F=ihs2rgb(F_IHS);
    imwrite(F,strcat('C:\Users\HJL\Desktop\medical\result\',num2str(k),'.png'));
    time_ASR(n)=toc;
end