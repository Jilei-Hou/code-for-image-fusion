%---------------------------------------------------------计算梯度
function AVEGRAD=avegrad(img)
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% this function is used to calculate
%%%% the average gradient of an image.
%%%% 平均梯度可敏感地反映图像对微小细节反差表达的能力，可用来评价图像的模糊程度
%%%% 在图像中，某一方向的灰度级变化率大，它的梯度也就大。因此，可以用平均梯度值
%%%% 来衡量图像的清晰度，还同时反映出图像中微小细节反差和纹理变换特征。

img=double(img);
[M,N]=size(img);
gradval=zeros(M,N); %%% save the gradient value of single pixel
diffX=zeros(M,N);    %%% save the differential value of X orient
diffY=zeros(M,N);    %%% save the differential value of Y orient

tempX=zeros(M,N);
tempY=zeros(M,N);
tempX(1:M,1:(N-1))=img(1:M,2:N);
tempY(1:(M-1),1:N)=img(2:M,1:N);

diffX=img-tempX;
diffY=img-tempY;
diffX(1:M,N)=0;       %%% the boundery set to 0
diffY(M,1:N)=0;
diffX=diffX.*diffX;
diffY=diffY.*diffY;
AVEGRAD=sum(sum(diffX+diffY));
AVEGRAD=sqrt(AVEGRAD);
AVEGRAD=AVEGRAD/((M-1)*(N-1)); 
