function F=DWTDE_Fusion(A,B,level)
%代码对应如下文章：
%刘羽，汪增福，结合小波变换和自适应分块的多聚焦图像快速融合，中国图象图形学报，vol. 18, no. 11, pp.1435-1444,2013.
%Usage of this code is free for research purposes only. 
%Please refer to the above publication if you use this code.
%%
A=double(A);
B=double(B);
k=2^level;
[h,w]=size(A);
H=ceil(h/k)*k;
W=ceil(w/k)*k;
A=imresize(A,[H W],'bicubic');
B=imresize(B,[H W],'bicubic');
C=zeros(H,W);
if ~exist('level')  %decomposition level of DWT
   level=3;
end
%%
%-------------------------------------------------------------------------%
%                                小波分解
%-------------------------------------------------------------------------%
tempA=A;
tempB=B;                                            
X=cell(level,4);                                                                                       
Y=cell(level,4);                                               
Z=cell(level,4);  
for i=1:level
    [X{i,1},X{i,2},X{i,3},X{i,4}]=dwt2(tempA,'db4','mode','per'); 
    tempA=X{i,1};
    [Y{i,1},Y{i,2},Y{i,3},Y{i,4}]=dwt2(tempB,'db4','mode','per'); 
    tempB=Y{i,1};
end
%%
%-------------------------------------------------------------------------%
%                               低频初始融合
%-------------------------------------------------------------------------%
global A1;
global B1;
global C1;
A1=X{level,1};
B1=Y{level,1};  
[H1,W1]=size(A1);
C1=zeros(H1,W1);
%差分进化算法的参数设置
NP=10;% NP：种群个数
CR=0.2;% CR：交叉算子
F=0.5;% F：变异算子
D=2;% D：问题维数（个体分量数）
xmin=[4,4];% xmin，xmax：个体最小和最大范围限制
xmax=[14,14];
G=20;% G：进化代数

opt_x=DEopt(NP,CR,F,D,xmin,xmax,G);      %DE算法求最优分块尺寸
fitness(opt_x);                                    %根据最优分块尺寸进行分块融合（完成初始融合）
%%
%-------------------------------------------------------------------------%
%                               低频精确融合
%-------------------------------------------------------------------------%
[block_flag,img_flag,edge_flag,edgeimg_flag]=setflag(opt_x);    

E=zeros(size(C1));      %E用来保存精确到像素的来源标签图，0表示该像素应从A1取得，1表示该像素应从B1取得
[M,N]=size(img_flag);

for j=1:M
    for i=1:N
        if edgeimg_flag(j,i)==1
            if  j<M && i<N 
                block1=A(((j-1)*2.^level)+1:(j*2.^level),((i-1)*2.^level)+1:(i*2.^level));
                block2=B(((j-1)*2.^level)+1:(j*2.^level),((i-1)*2.^level)+1:(i*2.^level));
            elseif j==M && i<N
                block1=A(((j-1)*2.^level)+1:H,((i-1)*2.^level)+1:(i*2.^level));
                block2=B(((j-1)*2.^level)+1:H,((i-1)*2.^level)+1:(i*2.^level));
            elseif j<M && i==N
                block1=A(((j-1)*2.^level)+1:(j*2.^level),((i-1)*2.^level)+1:W);
                block2=B(((j-1)*2.^level)+1:(j*2.^level),((i-1)*2.^level)+1:W);
            else
                block1=A(((j-1)*2.^level)+1:H,((i-1)*2.^level)+1:W);
                block2=B(((j-1)*2.^level)+1:H,((i-1)*2.^level)+1:W);
            end
            if BSV(block1)>=BSV(block2)
                E(j,i)=0;
            else
                E(j,i)=1;
            end 
        else
            if img_flag(j,i)==1
                E(j,i)=0;
            else
                E(j,i)=1;
            end
        end
    end
end
E=medfilt2(E,opt_x);
E=medfilt2(E,opt_x);
C1=(1-E).*A1+E.*B1;  
Z{level,1}=C1;
%%
%-------------------------------------------------------------------------%
%                               高频融合
%-------------------------------------------------------------------------%
tempE=E;               
for i=level:-1:1                           
    for j=2:4
        Z{i,j}=hf_fusion(X{i,j},Y{i,j},tempE,2.^(level-i+1)-1);    
    end
    tempE=rc_up2(tempE);          %上采样
end
%%
%-------------------------------------------------------------------------%
%                               小波重构
%-------------------------------------------------------------------------%
for i=level:-1:1
    if i>1
        Z{i-1,1}=idwt2(Z{i,1},Z{i,2},Z{i,3},Z{i,4},'db4','mode','per');
    else
        C=idwt2(Z{i,1},Z{i,2},Z{i,3},Z{i,4},'db4','mode','per');
    end
end
%%
F=uint8(imresize(C,[h w],'bicubic'));