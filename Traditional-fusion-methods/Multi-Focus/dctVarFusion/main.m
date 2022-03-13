close all;
clear all;
clc;
for i=1:4
    A  = imread(strcat('C:\Users\HJL\Desktop\far\',num2str(i),'.jpg'));
    B  = imread(strcat('C:\Users\HJL\Desktop\near\',num2str(i),'.jpg'));
    tic;
    fusedDctVar = dctVarFusion1(A, B);
    time_DCTVARFUSION(i)=toc;
    imwrite(fusedDctVar, strcat('C:\Users\HJL\Desktop\result\',num2str(i),'.jpg')); 
    disp(strcat('last',num2str(25-i)))


end