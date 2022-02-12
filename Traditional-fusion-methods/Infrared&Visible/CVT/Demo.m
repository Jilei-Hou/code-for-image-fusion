clc;
clear;
close all;
warning off;
addpath(genpath(cd));

file_path1 ='C:\Users\HJL\Desktop\demo\IR_VI\ir\';% path of source image1
file_path2 ='C:\Users\HJL\Desktop\demo\IR_VI\vi\';% path of source image2

img_path_list1 = dir(strcat(file_path1,'*.bmp'));
img_path_list2 = dir(strcat(file_path2,'*.bmp'));
img_num = 26;
time1=clock; 
if img_num > 0 
    for m = 1:img_num 
        image_name1 = img_path_list1(m).name;
        image_name2 = img_path_list2(m).name;
        I=double(imread(strcat(file_path1,image_name1)))/255;
        V=double(imread(strcat(file_path2,image_name2)))/255;
        image_size=size(I);
        dimension=numel(image_size);
        if dimension == 3
            I=double(rgb2gray(imread(strcat(file_path1,image_name1))))/255;
        end
        
        image_size2=size(V);
        dimension2=numel(image_size2);
        if dimension2 == 3
            V=double(rgb2gray(imread(strcat(file_path2,image_name2))))/255;
        end
        
        calc_metric = 1; 
        ind=findstr(image_name1,'.');
        list=image_name1(1:ind-1);
      



        

        %%
%         Remote sensing image fusion using the curvelet transform(2007)
        level=4;
        [M,N]=size(I);
        I4=imresize(I,[M+mod(M,2) N+mod(N,2)]);
        V4=imresize(V,[M+mod(M,2) N+mod(N,2)]);
        tic;
        X5 = curvelet_fuse(I4, V4,level+1);      %CVT
        t5=toc;
        X5=im2gray(X5);
        imwrite(X5,['C:\Users\HJL\Desktop\demo\IR_VI\fusion\',list,'.bmp']);
        if calc_metric, Result5 = Metric(uint8(abs(I4)*255),uint8(abs(V4)*255),uint8(abs(X5*255))); end

        
    end
end

time2=clock;  
T=etime(time2,time1);
disp(['Time:',num2str(T)]);


