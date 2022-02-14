clear all
clc

path='C:\Users\HJL\Desktop\medical';
addpath(genpath(pwd));

num=1:78;

for n=1:length(num)
    k=num(n)
    im1 = im2double(imread(strcat(path,'\Test_far\',num2str(k),'.png')));
    im2 = im2double(imread(strcat(path,'\Test_near_RGB\',num2str(k),'.png')));
    im2_ihs=rgb2ihs(im2);
    i=im2_ihs(:,:,1);
    v1=im2_ihs(:,:,2);
    v2=im2_ihs(:,:,3);
    
%     I=imresize(i,size(i)*4);
%     V1=imresize(v1,size(v1)*4);
%     V2=imresize(v2,size(v2)*4);
    I=i;
    V1=v1;
    V2=v2;
    
%     figure(1);
%     subplot(131);imshow(im1);
%     subplot(132);imshow(I);
    
    tic
	F_I = im2double(IJF(im1,I));
    time(n)=toc
    F_IHS=cat(3,F_I,V1,V2);
    
    F=ihs2rgb(F_IHS);

%     subplot(133);imshow(F);
    imwrite(F_I,strcat('C:\Users\HJL\Desktop\medical\result\',num2str(k),'.png'));

end