function G = AG(IF )
%UNTITLED4 Summary of this function goes here

IF = uint8(IF);
[m,n]= size(IF);

 H_IF=imhist(IF);PF = H_IF./(m*n);

%计算互平均梯度--------------------
FI = double(IF);
for i=1:m-1
    for j=1:n-1
        GM(i,j) = (FI(i+1,j) - FI(i,j)).^2 + (FI(i,j+1)-FI(i,j)).^2;
    end
end
GM = sqrt(GM/2);
% GM = sqrt(((double(IF(2:end,:)) - double(IF(1:end-1,:))).^2+(double(IF(:,2:end)) - double(IF(:,1:end-1))).^2)/2);
G = sum(GM(:))/(m*n);

%---------------------------
end

