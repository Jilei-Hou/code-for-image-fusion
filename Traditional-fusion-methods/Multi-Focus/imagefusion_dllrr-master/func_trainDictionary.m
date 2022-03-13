function [Vi1, Vi2, D0, D1, D2, D3, D4, D5, D6]=func_trainDictionary(I1, I2)
% train sub-dictionaries
Th = 0.25;
classNum = 7;% number of sub-dictionaries
unit = 8; % 窗口大小
[m,n] = size(I1);

% 存放分块数据, 第一行为类标签(0-6)
Vi1 = zeros(unit*unit + 1, (m-unit+1)*(n-unit+1));
Vi2 = zeros(unit*unit + 1, (m-unit+1)*(n-unit+1));

V0 = zeros(unit*unit, (m-unit+1)*(n-unit+1));
V1 = zeros(unit*unit, (m-unit+1)*(n-unit+1));
V2 = zeros(unit*unit, (m-unit+1)*(n-unit+1));
V3 = zeros(unit*unit, (m-unit+1)*(n-unit+1));
V4 = zeros(unit*unit, (m-unit+1)*(n-unit+1));
V5 = zeros(unit*unit, (m-unit+1)*(n-unit+1));
V6 = zeros(unit*unit, (m-unit+1)*(n-unit+1));

count0 = 1;
count1 = 1;
count2 = 1;
count3 = 1;
count4 = 1;
count5 = 1;
count6 = 1;

disp(strcat('Start caculate class values'));
for i=1:(m-unit+1)
    if rem(i,50)==0
%         disp(num2str(i));
    end
    for j=1:(n-unit+1)
        patch1 = I1(i:(i+7),j:(j+7));
        patch2 = I2(i:(i+7),j:(j+7));
        
        c1 = getClassLabel(patch1, classNum, Th);
        c2 = getClassLabel(patch2, classNum, Th);
        
        Vi1(1, (i-1)*(n-unit+1)+j) = c1;
        Vi1(2:end, (i-1)*(n-unit+1)+j) = patch1(:);
        Vi2(1, (i-1)*(n-unit+1)+j) = c2;
        Vi2(2:end, (i-1)*(n-unit+1)+j) = patch2(:);
        
        if c1 == 0
            V0(:,count0) = patch1(:);
            count0 = count0+1;
        elseif c1 == 1
            V1(:,count1) = patch1(:);
            count1 = count1+1;
        elseif c1 == 2
            V2(:,count2) = patch1(:);
            count2 = count2+1;
        elseif c1 == 3
            V3(:,count3) = patch1(:);
            count3 = count3+1;
        elseif c1 == 4
            V4(:,count4) = patch1(:);
            count4 = count4+1;
        elseif c1 == 5
            V5(:,count5) = patch1(:);
            count5 = count5+1;
        elseif c1 == 6
            V6(:,count6) = patch1(:);
            count6 = count6+1;
        end
        
        if c2 == 0
            V0(:,count0) = patch2(:);
            count0 = count0+1;
        elseif c2 == 1
            V1(:,count1) = patch2(:);
            count1 = count1+1;
        elseif c2 == 2
            V2(:,count2) = patch2(:);
            count2 = count2+1;
        elseif c2 == 3
            V3(:,count3) = patch2(:);
            count3 = count3+1;
        elseif c2 == 4
            V4(:,count4) = patch2(:);
            count4 = count4+1;
        elseif c2 == 5
            V5(:,count5) = patch2(:);
            count5 = count5+1;
        elseif c2 == 6
            V6(:,count6) = patch2(:);
            count6 = count6+1;
        end
        
    end
end
disp(strcat('Caculate class values - done'));

% KSVD - train the dictionaries
dic_size = 128;
k = 16;

disp('KSVD- D0');
params.data = V0(:,1:(count0-1));
params.Tdata = k;
params.dictsize = dic_size;
params.iternum = 50;
params.memusage = 'high';
[D0,X0,err0] = ksvd(params,'');

disp('KSVD- D1');
params.data = V1(:,1:(count1-1));
params.Tdata = k;
params.dictsize = dic_size;
params.iternum = 50;
params.memusage = 'high';
[D1,X1,err1] = ksvd(params,'');

disp('KSVD- D2');
params.data = V2(:,1:(count2-1));
params.Tdata = k;
params.dictsize = dic_size;
params.iternum = 50;
params.memusage = 'high';
[D2,X2,err2] = ksvd(params,'');

disp('KSVD- D3');
params.data = V3(:,1:(count3-1));
params.Tdata = k;
params.dictsize = dic_size;
params.iternum = 50;
params.memusage = 'high';
[D3,X3,err3] = ksvd(params,'');

disp('KSVD- D4');
params.data = V4(:,1:(count4-1));
params.Tdata = k;
params.dictsize = dic_size;
params.iternum = 50;
params.memusage = 'high';
[D4,X4,err4] = ksvd(params,'');

disp('KSVD- D5');
params.data = V5(:,1:(count5-1));
params.Tdata = k;
params.dictsize = dic_size;
params.iternum = 50;
params.memusage = 'high';
[D5,X5,err5] = ksvd(params,'');

disp('KSVD- D6');
params.data = V6(:,1:(count6-1));
params.Tdata = k;
params.dictsize = dic_size;
params.iternum = 50;
params.memusage = 'high';
[D6,X6,err6] = ksvd(params,'');

disp('Train dictionary - Done');
end

