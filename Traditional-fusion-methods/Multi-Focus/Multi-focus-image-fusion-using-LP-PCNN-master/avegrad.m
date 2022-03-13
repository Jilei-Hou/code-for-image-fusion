%---------------------------------------------------------�����ݶ�
function AVEGRAD=avegrad(img)
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% this function is used to calculate
%%%% the average gradient of an image.
%%%% ƽ���ݶȿ����еط�ӳͼ���΢Сϸ�ڷ����������������������ͼ���ģ���̶�
%%%% ��ͼ���У�ĳһ����ĻҶȼ��仯�ʴ������ݶ�Ҳ�ʹ���ˣ�������ƽ���ݶ�ֵ
%%%% ������ͼ��������ȣ���ͬʱ��ӳ��ͼ����΢Сϸ�ڷ��������任������

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
