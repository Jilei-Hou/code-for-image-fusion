function C=hf_fusion(A,B,map,e)
%-------------------------------------------------------------------------%
%�������ܣ���Ƶ�ֿ��ںϺ������ۺ��õ���������Ϣ���ֲ�С��������������Դ��־ͼ
% ����˵����
% A��B�����ںϵ�������Ƶ�������ߴ�һ��
% map: ������Դ��־ͼ
% e: �����Ƚ�С������ʱȡ�ľֲ����ڴ�С��2*e+1��
% �����
% C���ںϽ��
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

T=0.7;%�ɳ�����
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
