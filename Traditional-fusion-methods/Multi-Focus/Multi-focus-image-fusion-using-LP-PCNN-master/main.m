clc
clear
close all
% x1 = [1 2 -4; 1 1 1; -3 2 2; 0 0 0]
% y= norma_image(x1)
%-----------------------
for i=1:1
    I_a  = imread(strcat('C:\Users\HJL\Desktop\far\',num2str(i),'.jpg'));
    I1 = im2double(I_a);%��ͼ����������ת��Ϊdouble���Ͳ�����
    I_b  = imread(strcat('C:\Users\HJL\Desktop\near\',num2str(i),'.jpg')); 
    I2 = im2double(I_b);
    %--------------------------
    I_blur_Left = I1(160:436,1:222);%��ʾλ������
    I_clear_Left = I2(160:436,1:222);
    I_blur_Right = I1(30:406,223:end);
    I_clear_Right = I2(30:436,223:end);
%     %--------------------------��ʾͼ������------------------
%     figure
%     subplot(2,3,1);imshow(I1,[]);%figure3��ͼ�ų�һ�У�һ�����У���1��λ��
%     subplot(2,3,4);imshow(I2,[]);%imshow��ʾͼ��[]Ĭ�ϱ�ʾ[min(I(;)),max...]�Ҷ�ֵ
%     subplot(2,3,2);imshow(I_blur_Left,[]);
%     subplot(2,3,5);imshow(I_clear_Left,[]);
%     subplot(2,3,3);imshow(I_blur_Right,[]);
%     subplot(2,3,6);imshow(I_clear_Right,[]);%figure1
    %-------------------��������------------------------******************************
    beta = 0.01;%����ǿ��
    N0 = 200;%�������ȶ���
    alpha_F = 4.61/N0 + 0.001;%Fͨ������˥��ָ��
    V_T = 1/(1-exp(-alpha_F))+1;%��ֵ��ֵ
    V_L = 1;
    V_F = 0.1;
    C = 5;%������
    alpha_T =(log(1+V_T*(1-exp(-alpha_F))))/C;
    alpha_L = 8.7/(ceil((log(exp(-alpha_T)+V_T*(1-exp(-alpha_F))))/alpha_T)+1)+0.001;
    theata0 = 1.2;
    %----------------------------------------------�������黯****************************
    P(1)= V_L;
    P(2) = alpha_L;
    P(3) = V_F;
    P(4) = alpha_F;
    P(5) = V_T;
    P(6) = alpha_T;
    P(7) = theata0;
    P(8) = beta;
    %----------------------------*****************************-------------------------------
    N = 200;%��������
    Fire_series1 = PCNN_oscillation(I1,N,P);
    Fire_series11 = Fire_series1./max(Fire_series1(:));%��һ�����������
    Fire_series2 = PCNN_oscillation(I2,N,P);
    Fire_series22 = Fire_series2./max(Fire_series2(:));
    %---------------------------------**********************************
    xn = 10;
    K = ones(xn,xn);
    FA = (conv2(Fire_series11,K,'same'))./(xn.^2);
    FA = abs(Fire_series11 - FA);%�����ֵ����
    FB = (conv2(Fire_series22,K,'same'))./(xn.^2);
    FB = abs(Fire_series22 - FB);
    %-------------------------------------------------******************
    sel_logical = double(FA >FB);
%     figure
%     imwrite(sel_logical,'E.bmp')
%     imshow(sel_logical,[]);%figure2
    image_fushion = I1.*sel_logical + I2.*double(sel_logical==0);
%     figure
%     imwrite(image_fushion,'F.bmp')
%     imshow(image_fushion);%figure3
    imwrite(image_fushion, strcat('C:\Users\HJL\Desktop\result\',num2str(i),'.jpg')); 
%     disp(strcat('last',num2str(25-i)))
end




