function C=hf_fusion(A,B,map,e)
%-------------------------------------------------------------------------%
%函数功能：高频分块融合函数，综合用到了两个信息：局部小波能量，像素来源标志图
% 参数说明：
% A，B：待融合的两个高频分量，尺寸一致
% map: 像素来源标志图
% e: 决定比较小波能量时取的局部窗口大小（2*e+1）
% 输出：
% C：融合结果
%-------------------------------------------------------------------------%

if size(A)~=size(B)
    error('two images are not the same size')
end

[M,N]=size(A);
C=zeros(M,N);

expand_A=zeros(M+2*e,N+2*e);
expand_A(e+1:M+e,e+1:N+e)=A;
expand_B=zeros(M+2*e,N+2*e);
expand_B(e+1:M+e,e+1:N+e)=B;

T=0.7;%松弛因子
for j=e+1:M+e
    for i=e+1:N+e
        if sum(sum((expand_A(j-e:j+e,i-e:i+e)).^2))>=T*sum(sum((expand_B(j-e:j+e,i-e:i+e)).^2))&&map(j-e,i-e)==0
            C(j-e,i-e)=expand_A(j,i);   
        elseif sum(sum((expand_B(j-e:j+e,i-e:i+e)).^2))>=T*sum(sum((expand_A(j-e:j+e,i-e:i+e)).^2))&&map(j-e,i-e)==1
            C(j-e,i-e)=expand_B(j,i);   
        else
            C(j-e,i-e)=(expand_A(j,i)+expand_B(j,i))/2;    
        end
    end
end
