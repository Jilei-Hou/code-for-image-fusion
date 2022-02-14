%function[] = DDCTIFdemo()
% DDCT (Directional Discrete Cosine Transform) based image fusion - demo
% VPS Naidu, MSDF Lab, CSIR-NAL, March 2014
% Reference: "Hybrid DDCT-PCA base multi sensor image fusion? 
%       Journal of Optics, Vol. 43, No.1, pp.48-61, March 2014.

%%
close all;
clear all;
home;

path='C:\Users\HJL\Desktop\medical';
% insert images
%num={30,40,45,50,55,60,65,70,75,80,81,85,90,99};
num=1:78;
time=[];
%%
aflag = 1; % 1: Average, 2: max rule OR 3: energy rule
bs = 4; %[4 8 16 32 64 128 256];  block size

for n=1:length(num)
    k=num(n)
    im1 = im2double(imread(strcat(path,'\Test_far\',num2str(k),'.png')));
    im2 = im2double(imread(strcat(path,'\Test_near_RGB\',num2str(k),'.png')));
    im2_ihs=rgb2ihs(im2);
    i=im2_ihs(:,:,1);
    v1=im2_ihs(:,:,2);
    v2=im2_ihs(:,:,3);
    

    I=i;
    V1=v1;
    V2=v2;
    
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
    F_IHS=cat(3,F_I,V1,V2);
    F=ihs2rgb(F_IHS);
    time(n)=toc
   
%     subplot(133);imshow(F);
    imwrite(F,strcat('C:\Users\HJL\Desktop\medical\resul2\',num2str(k),'.png'));

end

mean(time)
std(time)