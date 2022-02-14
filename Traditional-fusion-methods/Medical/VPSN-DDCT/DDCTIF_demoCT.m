%%
close all;
clear all;
home;

path='D:\CTMR-T2\medical_test_imgs';
% insert images
%num={30,40,45,50,55,60,65,70,75,80,81,85,90,99};
num=1:20;
time=[];
%%
aflag = 1; % 1: Average, 2: max rule OR 3: energy rule
bs = 4; %[4 8 16 32 64 128 256];  block size

for n=1:length(num)
    k=num(n)
    im1 = im2double(imread(strcat(path,'\MR-T1\',num2str(k),'.png')));
    im2 = im2double(imread(strcat(path,'\PET-I\',num2str(k),'.png')));
%     im2_ihs=rgb2ihs(im2);
%     i=im2_ihs(:,:,1);
%     v1=im2_ihs(:,:,2);
%     v2=im2_ihs(:,:,3);
    
    I=imresize(im2,size(im2)*4);
%     V1=imresize(v1,size(v1)*4);
%     V2=imresize(v2,size(v2)*4);
%     
%     figure(1);
%     subplot(131);imshow(im1);
%     subplot(132);imshow(I);
    
    tic
    %%
    mode = [0 1 3 4 5 6 7 8]; % directional mode
    lmode = length(mode);
    
    %%
    if aflag == 1 % fusion by DDCT average rule
        %  h1 = waitbar(0,'Please wait...');
        for j=1:lmode
            imf1{j} = DDCTIFav(im1,I,bs,mode(j));
            j
            %        waitbar(j/lmode,h1);
        end
        %   close(h1);
    end
    
    %%
    if aflag == 2 % fusion by DDCT max rule
        %    h1 = waitbar(0,'Please wait...');
        for j=1:lmode
            imf1{j} = DDCTIFmax(im1,I,bs,mode(j));
            %        waitbar(j/lmode,h1);
        end
        %   close(h1);
    end
    
    %%
    if aflag == 3 % fusion by DDCT energy rule
        % h1 = waitbar(0,'Please wait...');
        for j=1:lmode
            imf1{j} = DDCTIFek(im1,I,bs,mode(j));
            %waitbar(j/lmode,h1);
        end
        %close(h1);
    end
    %%
    % fusion by PCA
    F_I = fuse_pca(imf1{1},imf1{2},imf1{3},imf1{4},imf1{5},imf1{6},imf1{7},imf1{8});
        
    %%
%     F_IHS=cat(3,F_I,V1,V2);
%     F=ihs2rgb(F_IHS);
    time(n)=toc
%    
%     subplot(133);imshow(F);
%     imwrite(F_I,strcat('D:\Traditional fusion methods\comparision\DDCTPCA\my_fused_CT\',num2str(k),'.png'));
%     imwrite(F,strcat('D:\Traditional fusion methods\comparision\DDCTPCA\my_fused_imgs\',num2str(k),'.png'));
    %%
end

mean(time)
std(time)