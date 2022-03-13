%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Compute Entropy Of Image计算熵 
function AVERENTROPY=averEntropy(img)%平均信息熵
if 1

img_t = double(img);
img_t = img_t/(max(img_t(:))+eps)*255;
img_t = uint8(img_t);
%获取图像行列号
[M,N]=size(img);

%生成值为零的初始化数组。其用来统计和存储对应于每个
%灰度级的频数（概率），数组的大小根据图像的大小而定
temp=zeros(1,256);

%figure,imshow(img);

%对图像的灰度值做统计，计算每个灰度级出现的次数
for m=1:M;
    for n=1:N;
        i=img_t(m,n)+1;
        temp(i)=temp(i)+1;
    end
end
temp=double(temp)/(M*N);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 由熵的定义做计算信息熵 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%初始化信息熵存储变量
EntropyResult=0;

for i=1:length(temp)
    if temp(i)==0;
       EntropyResult=EntropyResult;
    else
       EntropyResult=EntropyResult-temp(i)*log2(temp(i));
    end
end
AVERENTROPY=EntropyResult;
end




