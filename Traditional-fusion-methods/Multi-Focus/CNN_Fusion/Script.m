close all;
clear all;
clc;
for i=1:30
    A  = imread(strcat('C:\Users\HJL\Desktop\far\',num2str(i),'.jpg'));
    B  = imread(strcat('C:\Users\HJL\Desktop\near\',num2str(i),'.jpg'));
    if size(A)~=size(B)
        error('two images are not the same size.');
    end
    % figure,imshow(A);figure,imshow(B);

    model_name = 'model/cnnmodel.mat';
    tic;
    F=CNN_Fusion(A,B,model_name);
    time_CNN(i)=toc;
%     figure,imshow(F);

    imwrite( F, strcat('C:\Users\HJL\Desktop\result\',num2str(i-1),'.jpg')); 
    disp(strcat('last',num2str(30-i)))
 

%     imwrite(F,'results/fused_cnn.tif');
end