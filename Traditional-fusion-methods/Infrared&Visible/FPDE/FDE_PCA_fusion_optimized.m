clc;
clear all;
close all;
home;
% Read Input images and display
file_path1 ='C:\Users\HJL\Desktop\demo\IR_VI\ir\';% path of source image1
file_path2 ='C:\Users\HJL\Desktop\demo\IR_VI\vi\';% path of source image2
img_path_list1 = dir(strcat(file_path1,'*.bmp'));
img_path_list2 = dir(strcat(file_path2,'*.bmp'));
img_num = length(img_path_list1);
time1=clock; 
if img_num > 0 %
    for m = 1:img_num 
        image_name1 = img_path_list1(m).name;
        image_name2 = img_path_list2(m).name;%
        I1=imread(strcat(file_path1,image_name1));
        I2=imread(strcat(file_path2,image_name2));
        if size(I1,3)==3
            I1=rgb2gray(I1);
        end

        if size(I2,3)==3
            I2=rgb2gray(I2);
        end

        n=15; 
        dt=0.9;
        k=4;

        [A1]=fpdepyou(I1,n);
        [A2]=fpdepyou(I2,n);
        D1=double(I1)-double(A1);
        D2=double(I2)-double(A2);

         A(:,:,1)=A1;
         A(:,:,2)=A2;

         D(:,:,1)=D1;
         D(:,:,2)=D2;

        C1 = cov([D1(:) D2(:)]);
        [V11, D11] = eig(C1);
        if D11(1,1) >= D11(2,2)
            pca1 = V11(:,1)./sum(V11(:,1));
        else  
            pca1 = V11(:,2)./sum(V11(:,2));
        end
        imf1 = pca1(1)*D1 + pca1(2)*D2;
        imf2=(0.5*A1+0.5*A2);
        fuseimage=(double(imf1)+double(imf2));
        imwrite(uint8(fuseimage),['C:\Users\HJL\Desktop\demo\IR_VI\FPDE\result\',image_name1]); % path to save fusion results
        
        clear A;
        clear A1;
        clear A2;
        clear C1;
        clear D;
        clear D1;
        clear D11;
        clear D2;
        clear dt;

    end
end

time2=clock;  
T=etime(time2,time1);
disp(['Time:',num2str(T)]);
