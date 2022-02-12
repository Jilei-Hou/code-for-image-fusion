clear all;
clc;
% X1=imread('building.bmp');
% X2=rgb2gray(X1);
X1=imread('clock1.bmp');
X2=imread('clock2.bmp');
% X1=imcrop(X1,[0 0 320 256]);
% X2=imcrop(X2,[0 0 320 256]);
figure;
imshow(X1);
figure;
imshow(X2);
I1=double(X1);
I2=double(X2);
n=3;
[Y1,h1,Ly1] = dtwavexfm2(I1,n,'near_sym_b','qshift_b');
[Y2,h2,Ly2] = dtwavexfm2(I2,n,'near_sym_b','qshift_b');
%��Ƶϵ��ģֵ����ں�
% Y=abs_max(Y1,Y2);

%��Ե���,��Ե�ںϼ�DTCWT��Ƶϵ��ģֵ����ں�
% Yh1=derotated_dtcwt(n,h1);
% Yh2=derotated_dtcwt(n,h2);%DTCWT�任��Ƶϵ������ת
% for i=1:n
%     for j=1:6
%         %edge1{i}(:,:,j)=sobel(Yh1{i}(:,:,j),0.7);
%         %edge2{i}(:,:,j)=sobel(Yh2{i}(:,:,j),0.7);%sobel��Ե���
%         edge1{i}(:,:,j)=edge(Yh1{i}(:,:,j),'sobel');
%         edge2{i}(:,:,j)=edge(Yh2{i}(:,:,j),'sobel');%sobel��Ե���
%         edge{i}(:,:,j)=abs_max(edge1{i}(:,:,j),edge2{i}(:,:,j));%ȡ��Եֵ�ϴ���
%         h{i}(:,:,j)=abs_max(h1{i}(:,:,j),h2{i}(:,:,j));%��Ƶϵ��ģֵ����ں�
%         E_h{i}(:,:,j)=h{i}(:,:,j)+edge{i}(:,:,j);%�Ը�Ƶ�ں�ϵ�����б�Ե��ǿ
%     end
% end
% Z = dtwaveifm2(Y,E_h,'near_sym_b','qshift_b');%�ع�
% figure;
% imshow(Z);

for k=1:n
    for l=1:6
        Yh11=h1{k}(:,:,l);  Yh22=h2{k}(:,:,l);
        Yh11(abs(Yh11)<abs(Yh22))=Yh22(abs(Yh11)<abs(Yh22));
        Yh1{k}(:,:,l)=Yh11;
    end
end

Z = dtwaveifm2((Y2+Y1)./2,Yh1,'near_sym_b','qshift_b');%�ع�
figure,imshow(Z,[ ]);





%cimage5(edge{1}(:,:,1));
%[r,c]=size(Yh1{1}(:,:,1));
%z=Yh1{1}(:,:,1);
%Yh1inter=imresize(z,2);
%[xi,yi]=meshgrid(-3:0.2:3,-3:0.2:3);
%x1=ones(480,480);
%y1=ones(480,480);
%x=1:r;
%y=1:c;
%Yh1inter=interp2(y,x,z,y1,x1,'linear');
%Yh1inter=interp2(z,y1,x1,'nearest');
%size(Yh1inter)
%figure;
%cimage5(Yh1{1}(:,:,1));
