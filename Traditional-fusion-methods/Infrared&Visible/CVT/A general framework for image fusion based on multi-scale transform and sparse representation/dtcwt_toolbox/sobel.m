%����sobel.m: sobel����%
function y=sobel(image,th)  
%image: ����ͼ��%
%th: �ٽ�ֵ%
[Nn Nm]=size(image);           %ͼƬ��С�p
h=[-1 -2 -1;0 0 0;1 2 1];      %Sobel ���Ӥl
Gx=filter2(h,image);           %���ݶ�������Gx����  
Gy=filter2(h',image);          %���ݶ�������Gy����
F=abs(Gx)+abs(Gy);        
Bw_Gx=double(Gx)/255;          %��Gx��Χ��[0, 255]����[0,1]  
Bw_Gy=double(Gy)/255;          %��Gy��Χ��[0, 255]����[0,1]  
Bw_F=double(F)/255;            %��F��Χ��[0, 255]����[0,1]
                               %�趨�ٽ�ֵ����[0,1]֮�� 
for i=1:Nn
  for j=1:Nm 
    if Bw_F(i,j)<th     
      y(i,j)=0;
    else
      y(i,j)=1;
    end
  end
end
