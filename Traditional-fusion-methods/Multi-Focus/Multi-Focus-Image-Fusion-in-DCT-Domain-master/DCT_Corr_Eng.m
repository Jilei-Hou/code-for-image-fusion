% C)Mostafa Amin-Naji, Babol Noshirvani University of Technology,
% My Official Website: www.Amin-Naji.com
% My Email: Mostafa.Amin.Naji@Gmail.com

% PLEASE CITE THE BELOW PAPER IF YOU USE THIS CODE

%M. Amin-Naji and A. Aghagolzadeh, 揗ulti-Focus Image Fusion in DCT Domain using
%Variance and Energy of Laplacian and Correlation Coefficient for Visual Sensor
%Networks,?Journal of AI and Data Miningm vol. 6, no. 2, 2018, pp. 233-250.
% DOI:  http://dx.doi.org/10.22044/jadm.2017.5169.1624

clc
clear
close all

%Select First Image
% disp('Please Select First Image:')
% [filename, pathname]= uigetfile({'*.jpg;*.png;*.tif;*.bmp'},'Select First Image');
% path=fullfile(pathname, filename);
% im1=imread(path);
% disp('Great! First Image is selected')
% 
% %Select Second Image
% disp('Please Select Second Image:')
% [filename, pathname]= uigetfile({'*.jpg;*.png;*.tif'},'Select Second Image');
% path=fullfile(pathname, filename);
% im2=imread(path);
% disp('Great! Second Image is selected')
for num_set=1:25
    im1  = imread(strcat('C:\Users\张浥尘\Desktop\Second_Fusion\multi_focus\对比算法\源数据\Test_ir\',num2str(num_set),'.bmp'));
    im2  = imread(strcat('C:\Users\张浥尘\Desktop\Second_Fusion\multi_focus\对比算法\源数据\Test_vi\',num2str(num_set),'.bmp'));
    



if size(im1,3) == 3     % Check if the images are grayscale
    im1 = rgb2gray(im1);
end
if size(im2,3) == 3
    im2 = rgb2gray(im2);
end

if size(im1) ~= size(im2)	% Check if the input images are of the same size
    error('Size of the source images must be the same!')
end

disp('congratulations! Fusion Process in Running')

% Get input image size
[m,n] = size(im1);
FusedDCT = zeros(m,n);
FusedDCT_CV = zeros(m,n);
Map = zeros(floor(m/8),floor(n/8));	

% Level shifting
im1 = double(im1)-128;
im2 = double(im2)-128;

x=0.0751;
y=0.1238;
z=0.2042;
C=dctmtx(8);
t=[

     y     x     0     0     0     0     0     0
     x     y     x     0     0     0     0     0
     0     x     y     x     0     0     0     0
     0     0     x     y     x     0     0     0
     0     0     0     x     y     x     0     0
     0     0     0     0     x     y     x     0
     0     0     0     0     0     x     y     x
     0     0     0     0     0     0     x     y];
 s=[

     z     y     0     0     0     0     0     0
     y     z     y     0     0     0     0     0
     0     y     z     y     0     0     0     0
     0     0     y     z     y     0     0     0
     0     0     0     y     z     y     0     0
     0     0     0     0     y     z     y     0
     0     0     0     0     0     y     z     y
     0     0     0     0     0     0     y     z];
 u=[

     x+2*y     0     0     0     0     0     0     0
     0         0     0     0     0     0     0     0
     0         0     0     0     0     0     0     0
     0         0     0     0     0     0     0     0
     0         0     0     0     0     0     0     0
     0         0     0     0     0     0     0     0
     0         0     0     0     0     0     0     0
     0         0     0     0     0     0     0     x+2*y ];
 
v=[

     0     x     0     0     0     0     0     0
     x     y     x     0     0     0     0     0
     0     x     y     x     0     0     0     0
     0     0     x     y     x     0     0     0
     0     0     0     x     y     x     0     0
     0     0     0     0     x     y     x     0
     0     0     0     0     0     x     y     x
     0     0     0     0     0     0     x     0];
 
  lu =[

     0     1     0     0     0     0     0     0
     1     0     1     0     0     0     0     0
     0     1     0     1     0     0     0     0
     0     0     1     0     1     0     0     0
     0     0     0     1     0     1     0     0
     0     0     0     0     1     0     1     0
     0     0     0     0     0     1     0     1
     0     0     0     0     0     0     1     0];
   q =[

     1     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     1];
 
 LU=C*lu*C';
 T=C*t*C';
 S=C*s*C';
 U=C*u*C';
 V=C*v*C';
 Q=C*q*C';
 

tic

threshold1=0;
% Divide source images into 8*8 blocks and perform the fusion process
for i = 1:floor(m/8)
    for j = 1:floor(n/8)
        
        im1_Block  = im1(8*i-7:8*i,8*j-7:8*j);
        im2_Block  = im2(8*i-7:8*i,8*j-7:8*j);
        
        % Compute the 2-D DCT of 8*8 blocks
        im1_Block_DCT = C*im1_Block*C';
        im2_Block_DCT = C*im2_Block*C';
        
        im1SubDct_LOW=(LU*im1_Block_DCT*T)+(im1_Block_DCT*S)+((Q*im1_Block_DCT*U)+(V*im1_Block_DCT*Q)+(Q*im1_Block_DCT*V));
        im2SubDct_LOW=(LU*im2_Block_DCT*T)+(im2_Block_DCT*S)+((Q*im2_Block_DCT*U)+(V*im2_Block_DCT*Q)+(Q*im2_Block_DCT*V));

        PimA=im1_Block_DCT-mean2(im1_Block_DCT);
        PimB=im2_Block_DCT-mean2(im2_Block_DCT);
        PimA_Low=im1SubDct_LOW-mean2(im1SubDct_LOW);
        PimB_Low=im2SubDct_LOW-mean2(im2SubDct_LOW);
        
        cor1= sum(sum(PimA.*PimA_Low))/sqrt(sum(sum(PimA.*PimA))*sum(sum(PimA_Low.*PimA_Low)));
        cor2= sum(sum(PimB.*PimB_Low))/sqrt(sum(sum(PimB.*PimB))*sum(sum(PimB_Low.*PimB_Low)));
       
        energy_A=sum(sum(im1_Block_DCT.^2));
        energy_B=sum(sum(im2_Block_DCT.^2));
        energy_A_Low=sum(sum(im1SubDct_LOW.^2));
        energy_B_Low=sum(sum(im2SubDct_LOW.^2));
        
        corr_eng_1=energy_A*(1-cor1)*energy_A_Low;
        corr_eng_2=energy_B*(1-cor2)*energy_B_Low;
        
        
        z=corr_eng_1;
        zz=corr_eng_2;


        if z>=zz
           dctBlock = im1_Block_DCT;
            Map(i,j) = -1;	% Consistency verification index

        end
        if z<zz
            dctBlock = im2_Block_DCT;
            Map(i,j) = +1;    % Consistency verification index



        end
        if z<zz+threshold1 && z>zz-threshold1
            dctBlock = (im2_Block_DCT+im2_Block_DCT)./2;
            Map(i,j) =0 ;
        end
        
        % Compute the 2-D inverse DCT of 8*8 blocks and construct fused image
        FusedDCT(8*i-7:8*i,8*j-7:8*j) = C'*dctBlock*C;	% DCT+Corr_Eng method
       
    end
end
toc
% Concistency verification (CV) with Majority Filter (3x3 Averaging Filter)
fi=fspecial('average',3);
Map_Filtered = imfilter(Map, fi,'symmetric');	% Filtered index map

threshold2=0.00;
for i = 1:m/8
    for j = 1:n/8
        % DCT+Variance+CV method
        if Map_Filtered(i,j) <= -threshold2
            FusedDCT_CV(8*i-7:8*i,8*j-7:8*j) = im1(8*i-7:8*i,8*j-7:8*j);
   
        end
        if Map_Filtered(i,j) > threshold2
            FusedDCT_CV(8*i-7:8*i,8*j-7:8*j) = im2(8*i-7:8*i,8*j-7:8*j);
      
        end
        if Map_Filtered(i,j) > -threshold2 &&  Map_Filtered(i,j) < threshold2
             FusedDCT_CV(8*i-7:8*i,8*j-7:8*j) = (im1(8*i-7:8*i,8*j-7:8*j)+im2(8*i-7:8*i,8*j-7:8*j))./2;
        end
        end
end

% Inverse level shifting 
im1 = uint8(double(im1)+128);
im2 = uint8(double(im2)+128);
FusedDCT = uint8(double(FusedDCT)+128);
FusedDCT_CV = uint8(double(FusedDCT_CV)+128);
    if i<=10
         imwrite( FusedDCT, strcat('C:\Users\张浥尘\Desktop\Second_Fusion\multi_focus\对比算法\结果\Others\Multi-Focus-Image-Fusion-in-DCT-Domain-master\DCT','\','F9_0',num2str(num_set-1),'.bmp'));
         imwrite( FusedDCT_CV, strcat('C:\Users\张浥尘\Desktop\Second_Fusion\multi_focus\对比算法\结果\Others\Multi-Focus-Image-Fusion-in-DCT-Domain-master\DCT_CV','\','F9_0',num2str(num_set-1),'.bmp'));
         
    else
         imwrite( FusedDCT, strcat('C:\Users\张浥尘\Desktop\Second_Fusion\multi_focus\对比算法\结果\Others\Multi-Focus-Image-Fusion-in-DCT-Domain-master\DCT','\','F9_',num2str(num_set-1),'.bmp')); 
         imwrite( FusedDCT_CV, strcat('C:\Users\张浥尘\Desktop\Second_Fusion\multi_focus\对比算法\结果\Others\Multi-Focus-Image-Fusion-in-DCT-Domain-master\DCT_CV','\','F9_',num2str(num_set-1),'.bmp')); 
    end
    disp(strcat('last',num2str(25-num_set)))
end

% Show Images Table
% subplot(2,2,1), imshow(im1), title('Source image 1');
% subplot(2,2,2), imshow(im2), title('Source image 2');
% subplot(2,2,3), imshow(FusedDCT), title('"DCT+Corr_Eng" fusion result');
% subplot(2,2,4), imshow(FusedDCT_CV), title('"DCT+Corr_Eng+CV" fusion result');

% Good Luck
% Mostafa Amin-Naji ;)
