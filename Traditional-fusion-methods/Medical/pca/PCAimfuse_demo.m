%function[] = PCA_demo()
% Image fusion by PCA  - demo
% by VPS Naidu, MSDF Lab, NAL, Bangalore
close all;
clear all;
home;
tic
path='C:\Users\HJL\Desktop\medical';
% insert images
num=1:34;

for n=1:length(num)
    k=num(n)
    im1 = im2double(imread(strcat(path,'\Test_far\',num2str(k),'.png')));
    im2 = im2double(imread(strcat(path,'\Test_near_RGB\',num2str(k),'.png')));
    tic
    im2_ihs=rgb2ihs(im2);
    i=im2_ihs(:,:,1);
    v1=im2_ihs(:,:,2);
    v2=im2_ihs(:,:,3);
    
    I=imresize(i,size(i)*1);
    V1=imresize(v1,size(v1)*1);
    V2=imresize(v2,size(v2)*1);
    
%     figure(1);
%     subplot(121);imshow(im1);
%     subplot(122);imshow(I);
    
    % compute PCA
    C = cov([im1(:) I(:)]);
    [V, D] = eig(C);
    if D(1,1) >= D(2,2)
        pca = V(:,1)./sum(V(:,1));
    else
        pca = V(:,2)./sum(V(:,2));
    end
    
    % fusion
    F_I = pca(1)*im1 + pca(2)*I;
%     figure(2); imshow(F_I);
    time_PCA(k)=toc;
    F_IHS=cat(3,F_I,V1,V2);
    F=ihs2rgb(F_IHS);
%     figure(2)
%     imshow(F)
      disp(strcat('last',num2str(78-k)));

%     imwrite(F_I,strcat('C:\Users\Administrator\Desktop\PET and MRI fusion\�Ա��㷨\pca\fused_I\0',num2str(k),'.png'));
    imwrite(F,strcat('C:\Users\HJL\Desktop\medical\result\',num2str(k),'.png'));
end
toc