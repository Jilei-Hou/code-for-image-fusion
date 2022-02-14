clear
clc
close all
%% Read Images

% The size of images must be equal
%
% [file, pathname] = uigetfile('*.jpg','Select the PAN Image ');cd(pathname);
% a=imread(file);
% [file, pathname] = uigetfile('*.jpg','Select the Multispectral Image ');cd(pathname);
% b=imread(file);

path='C:\Users\HJL\Desktop\medical';
num=1:34;
for n=1:length(num)
    k=num(n)
    a = im2double(imread(strcat(path,'\Test_far\',num2str(k),'.png')));
    im22 = im2double(imread(strcat(path,'\Test_near_RGB\',num2str(k),'.png')));
    
    for c=1:3
        b(:,:,c)=imresize(im22(:,:,c),size(im22(:,:,c))*1);
    end
%     imwrite(b,strcat(path,'\PET_ds_us\0',num2str(k),'.png'));
    
    %% RGB Component of Multspectal Image
     R=b(:,:,1);G=b(:,:,2);B=b(:,:,3);
    
%     %%   IHS Transformation
%     tic
%     b_IHS=rgb2ihs(b);
%     F_I=a;
%     
%     F_IHS=cat(3,F_I,b_IHS(:,:,2:3));
%     F=ihs2rgb(F_IHS);
%     time(n)=toc
% %     I=a;V1=(R+G-2*B)/sqrt(6);V2=(R-G)/sqrt(2);
% %     RN=I/3+V1/sqrt(6)+V2/sqrt(2);GN=I/3+V1/sqrt(6)-V2/sqrt(2);BN=I/3-2*V1/sqrt(6);
% %     
% %     % Inverse IHS transformation
% %     IM_IHS(:,:,1)=RN;IM_IHS(:,:,2)=GN;IM_IHS(:,:,3)=BN;
%     imshow(F)
%     title('Fused Image Based IHS Transformation')
    
    %%   Brovey Method
    RN=(R./(R+G+B)).*a;GN=(G./(R+G+B)).*a;BN=(B./(R+G+B)).*a;
    IM_PROVEY(:,:,1)=RN;IM_PROVEY(:,:,2)=GN;IM_PROVEY(:,:,3)=BN;
%     figure,imshow(IM_PROVEY)
%     title('Fused Image Based Brovey Method')
%    imwrite(F,strcat('C:\Users\Administrator\Desktop\PET and MRI fusion\�Ա��㷨\IHS\fused_imgs\0',num2str(k),'.png'));
%       if k<=10
% %         imwrite(F_I,strcat('C:\Users\�śų�\Desktop\Second_Fusion\�Ա��㷨ָ��\Medical\�㷨���\�������\Brovey\ԭ���\','F9_0',num2str(k-1),'.bmp'));
%         imwrite(IM_PROVEY,strcat('C:\Users\�śų�\Desktop\Second_Fusion\�Ա��㷨ָ��\Medical\�㷨���\�������\Brovey\���ս��\','F9_0',num2str(k-1),'.bmp'));
%       else
% %         imwrite(F_I,strcat('C:\Users\�śų�\Desktop\Second_Fusion\�Ա��㷨ָ��\Medical\�㷨���\�������\Brovey\ԭ���\','F9_',num2str(k-1),'.bmp'));
%         imwrite(IM_PROVEY,strcat('C:\Users\�śų�\Desktop\Second_Fusion\�Ա��㷨ָ��\Medical\�㷨���\�������\Brovey\���ս��\','F9_',num2str(k-1),'.bmp'));
      imwrite(IM_PROVEY,strcat('C:\Users\HJL\Desktop\medical\result\',num2str(k),'.png'));

%       end
end


