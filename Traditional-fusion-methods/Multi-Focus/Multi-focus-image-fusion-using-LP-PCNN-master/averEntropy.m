%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Compute Entropy Of Image������ 
function AVERENTROPY=averEntropy(img)%ƽ����Ϣ��
if 1

img_t = double(img);
img_t = img_t/(max(img_t(:))+eps)*255;
img_t = uint8(img_t);
%��ȡͼ�����к�
[M,N]=size(img);

%����ֵΪ��ĳ�ʼ�����顣������ͳ�ƺʹ洢��Ӧ��ÿ��
%�Ҷȼ���Ƶ�������ʣ�������Ĵ�С����ͼ��Ĵ�С����
temp=zeros(1,256);

%figure,imshow(img);

%��ͼ��ĻҶ�ֵ��ͳ�ƣ�����ÿ���Ҷȼ����ֵĴ���
for m=1:M;
    for n=1:N;
        i=img_t(m,n)+1;
        temp(i)=temp(i)+1;
    end
end
temp=double(temp)/(M*N);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ���صĶ�����������Ϣ�� %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%��ʼ����Ϣ�ش洢����
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




