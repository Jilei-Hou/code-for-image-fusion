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
        %The laplacian pyramid as a compact image code(1983)
        level=4;
        tic;
        X1 = lp_fuse(I, V, level, 3, 3);       %LP
        t1=toc;
        X1=im2gray(X1);
%         imwrite(X1,'lake_1.png','png');
        imwrite(X1,['C:\Users\HJL\Desktop\demo\IR_VI\fusion\',list,'.bmp']);
        if calc_metric, Result1 = Metric(uint8(abs(I)*255),uint8(abs(V)*255),uint8(abs(X1*255))); end

       
    end
end

time2=clock;  
T=etime(time2,time1);
disp(['Time:',num2str(T)]);


