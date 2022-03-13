% function fusion_HOG_LRR_combine

% n=20;% multi-focus
image_num=25;% noise focus
lambda = 95;

for num=1:image_num
    
disp(num2str(num));

path1 = strcat('C:\Users\张浥尘\Desktop\Second_Fusion\multi_focus\对比算法\源数据\Test_ir\',num2str(num),'.bmp');
path2 = strcat('C:\Users\张浥尘\Desktop\Second_Fusion\multi_focus\对比算法\源数据\Test_vi\',num2str(num),'.bmp');
% fuse_path = ['./fused_mf/fused',num2str(num),'_HogLrr.png'];

image1 = imread(path1);
image2 = imread(path2);
I1 = im2double(image1);
I2 = im2double(image2);

classNum = 7;% number of sub-dictionaries
unit = 8; % size of window
[m,n] = size(image1);

tic
[Vi1, Vi2, D0, D1, D2, D3, D4, D5, D6]=func_trainDictionary(I1, I2);

%% get global dictionary
dic_size = 128;
D = zeros(unit*unit,classNum*dic_size);
for i=1:classNum
    tmp_d = eval(['D',num2str(i-1) ]);
    D(:,((i-1)*dic_size+1):dic_size*i) = tmp_d;
end

%% LRR
[vn,vm] = size(Vi1);
disp(strcat('LRR-start'));
% tic
[Z1,E1] = solve_lrr(Vi1(2:vn,:),D,lambda,0,1);
disp(strcat('Z1-Done'));
[Z2,E2] = solve_lrr(Vi2(2:vn,:),D,lambda,0,1);
% toc
disp(strcat('LRR-Done'));

%% Fusion
fusion = zeros(m,n);
disp(strcat('fusion-start'));
for i=1:(m-unit+1)
    if rem(i,50)==0
%         disp(num2str(i));
    end
    for j=1:(n-unit+1)
        % vector
        y1 = Z1(:, (i-1)*(n-unit+1)+j);
        y2 = Z2(:, (i-1)*(n-unit+1)+j);
        LRR1 = norm(y1,1);
        LRR2 = norm(y2,1);
        
        % choose-max
        if LRR1>LRR2
            fv = D*y1;
        else
            fv = D*y2;
        end
        
        fv_block = reshape(fv, [8,8]);
        temp = fusion(i:(i+7),j:(j+7));
        % reconstructure
        fb = (fv_block+temp)/2;
        fusion(i:(i+7),j:(j+7)) = fb;
    end
end
disp(strcat('fusion-Done'));
toc
% imwrite(fusion,fuse_path,'png');

    if i<=10
         imwrite( F, strcat('C:\Users\张浥尘\Desktop\Second_Fusion\multi_focus\对比算法\结果\Others\imagefusion_dllrr-master','\','F9_0',num2str(num-1),'.bmp')); 
      else
         imwrite( F, strcat('C:\Users\张浥尘\Desktop\Second_Fusion\multi_focus\对比算法\结果\Others\imagefusion_dllrr-master','\','F9_',num2str(num-1),'.bmp')); 
    end
    disp(strcat('last',num2str(25-i)))


end

