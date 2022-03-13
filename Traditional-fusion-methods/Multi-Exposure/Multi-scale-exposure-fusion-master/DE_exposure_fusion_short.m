tic
clc;
clear all;
I = load_images('7_11');

[R,Lu] = multiscale_exposure_fusion(I);
RLu = luminance(R);
[h,w,t] = size(Lu);
log_lu = zeros(size(Lu(:,:,:)));
log_R_lu = zeros(size(RLu(:,:)));
for i = 1:h
    for j = 1:w
        for k = 1:t
            log_lu(i,j,k) = log(Lu(i,j,k)+1);
            log_R_lu(i,j) = log(RLu(i,j)+1);
        end
    end
end

% construct weight
% find the max
maxX = [0,0,0];
maxY = [0,0,0];
for i = 1:h-1
    for j = 1:w-1
        for k = 1:t
            x = f(Lu(i,j,k))*f(Lu(i+1,j,k));
            y = f(Lu(i,j,k))*f(Lu(i,j+1,k));
            if x > maxX(1,k)
                maxX(1,k) = x;
            end
            if y >maxY(1,k)
                maxY(1,k) = y;
            end
        end
    end
end

weightX = zeros(size(log_lu));
weightY = zeros(size(log_lu));
for i = 1:h-1
    for j = 1:w-1
        for k = 1:t
            weightX(i,j,k) = f(Lu(i,j,k))*f(Lu(i+1,j,k)) / maxX(1,k);
            weightY(i,j,k) = f(Lu(i,j,k))*f(Lu(i,j+1,k)) / maxY(1,k);
        end
    end
end

% note: in each weight, the value of last column and row are still zero!!!

% weighted gradient and singular value decomposition
gx = zeros(size(log_lu));
gy = zeros(size(log_lu));
[Rgx,Rgy] = gradient(log_R_lu);
for i = 1:3
    [gx(:,:,i),gy(:,:,i)]=gradient(log_lu(:,:,i));
end

%weight_grad = zeros(h,w);
vector_field1 = zeros(h,w);
vector_field2 = zeros(h,w);
for i = 1:h
    for j = 1:w
        weight_grad = [weightX(i,j,1)*gx(i,j,1),weightY(i,j,1)*gy(i,j,1);weightX(i,j,2)*gx(i,j,2),weightY(i,j,2)*gy(i,j,2);weightX(i,j,3)*gx(i,j,3),weightY(i,j,3)*gy(i,j,3)];
        [U,S,V] = svd(weight_grad);
        s1 = sigma1(Rgx(i,j),Rgy(i,j));
        s2 = sigma2(Rgx(i,j),Rgy(i,j));
        denom = sqrt(Rgx(i,j)^2 + Rgy(i,j)^2);
        % construct vector field
        vf = (s1*S(1,1).*V(1,:).' + s2*S(2,2).*V(2,:).') ./ (denom);
        vector_field1(i,j) = vf(1,1);
        vector_field2(i,j) = vf(2,1);
    end
end

%lambda = 0.03125;
F1 = FGS(vector_field1,0.1,0.03125);
F2 = FGS(vector_field2,0.1,0.03125);
F = F1 + F2;

Final = R;
[h,w,t] = size(R);
for i = 1:h
    for j = 1:w
        Final(i,j) = Final(i,j)* exp(F(i,j));
    end
end
toc

