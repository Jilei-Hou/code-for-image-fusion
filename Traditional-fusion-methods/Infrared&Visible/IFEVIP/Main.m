
clc,clear,close all;

QuadNormDim = 512;
QuadMinDim = 32;
GaussScale = 9;
MaxRatio = 0.001;
StdRatio = 0.8;
file_path1 ='C:\Users\HJL\Desktop\demo\IR_VI\ir\';% path of source image1
file_path2 ='C:\Users\HJL\Desktop\demo\IR_VI\vi\';% path of source image2
img_path_list1 = dir(strcat(file_path1,'*.bmp'));
img_path_list2 = dir(strcat(file_path2,'*.bmp'));
img_num = length(img_path_list1);
time1=clock; 
if img_num > 0 
    for m = 1:img_num 
        image_name1 = img_path_list1(m).name;
        image_name2 = img_path_list2(m).name;
        I1=imread(strcat(file_path1,image_name1));
        I2=imread(strcat(file_path2,image_name2));
        if size(I1,3)==3
            I1=rgb2gray(I1);
        end

        if size(I2,3)==3
            I2=rgb2gray(I2);
        end
        result = BGR_Fuse(I2, I1, QuadNormDim, QuadMinDim, GaussScale, MaxRatio, StdRatio);
        imwrite(result,['C:\Users\HJL\Desktop\demo\IR_VI\fusion\',image_name1]);
        
    end
end
time2=clock;  
T=etime(time2,time1);
disp(['Time:',num2str(T)]);

