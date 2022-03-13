clc;close all;clear;
for i=1:4
    A  = imread(strcat('C:\Users\HJL\Desktop\far\',num2str(i),'.jpg'));
    B  = imread(strcat('C:\Users\HJL\Desktop\near\',num2str(i),'.jpg'));
%     figure;imshow(A);figure;imshow(B);

    if size(A)~=size(B)
        error('two images are not the same size.');
    end

    level=3;

    tic;
    if size(A,3)==1  %for gray images
        F=DWTDE_Fusion(A,B,level); 
    else             %for color images
        F=A;
        for j=1:3
            F(:,:,j)=DWTDE_Fusion(A(:,:,j),B(:,:,j),level);
        end
    end
    time_DWTDE(i)=toc;

%     figure;imshow(F);
%     imwrite(F,'results/fused_dwtde.tif');
    imwrite(F, strcat('C:\Users\HJL\Desktop\result\',num2str(i),'.jpg')); 
%     disp(strcat('last',num2str(30-num)))

end