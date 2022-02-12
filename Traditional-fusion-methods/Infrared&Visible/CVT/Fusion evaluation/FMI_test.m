



%nfmi = fmi(ima, imb, imf);


% %SSIM---------------------------------------------------------------------------------------------------------------------------
% OURS
clear;
file_pathIR ='D:\ZhuoMian\research\NEW_PAPER\实验结果\testimage\Test_ir\';% 图像文件夹路径
img_path_listIR = dir(strcat(file_pathIR,'*.bmp'));%获取该文件夹中所有bmp格式的图像
file_pathVI ='D:\ZhuoMian\research\NEW_PAPER\实验结果\testimage\Test_vi\';% 图像文件夹路径
img_path_listVI = dir(strcat(file_pathVI,'*.bmp'));%获取该文件夹中所有bmp格式的图像
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\实验结果\ours\C_12_5_3_0.5_0.5_6_3_1_1.5_2\epoch8\';% 图像文件夹路径
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%获取该文件夹中所有bmp格式的图像
img_num = length(img_path_list1);%获取图像总数量?
I=cell(1,img_num);
OURS = 1:17;
sum_0URS = 0;
if img_num > 0 %有满足条件的图像
    for m = 1:17 %逐一读取图像   
%         image_name1 = img_path_list1(m).name;% 图像名        
%         image_IR = imread(strcat(file_path1,image_name1));
%         S = std2(image_IR);
%         sum_0URS = sum_0URS+S;
%         OURS(m) = S;
        
        image_name1 = img_path_list1(m).name;% 图像名     
        image_ours = imread(strcat(file_path1,image_name1));
        image_name2 = img_path_listIR(m).name;% 图像名     
        IR = imread(strcat(file_pathIR,image_name2));
        image_size=size(IR);
        dimension=numel(image_size);
        if dimension == 3
            IR=rgb2gray(IR);
        end
%         IR=rgb2gray(IR);
        image_name3 = img_path_listVI(m).name;% 图像名     
        VI = imread(strcat(file_pathVI,image_name3));
%         VI=rgb2gray(VI);
        image_size=size(VI);
        dimension=numel(image_size);
        if dimension == 3
            VI=rgb2gray(VI);
        end
        
%         o = ssim(image_ours, IR);
%         p = ssim(image_ours, VI);
        ssim = fmi(IR, VI, image_ours);
%         S = std2(image_IR);
        sum_0URS = sum_0URS+ssim;
        OURS(m) = ssim;
        clear ssim;
        
        
    end
end
% PMGI   
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\实验结果\PMGI\epoch6\';% 图像文件夹路径
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%获取该文件夹中所有bmp格式的图像
img_num = length(img_path_list1);%获取图像总数量?
I=cell(1,img_num);
sum_PMGI = 0;
PMGI = 1:17;
if img_num > 0 %有满足条件的图像
    for m = 1:17 %逐一读取图像   
        image_name1 = img_path_list1(m).name;% 图像名     
        image_pmgi = imread(strcat(file_path1,image_name1));
        image_name2 = img_path_listIR(m).name;% 图像名     
        IR = imread(strcat(file_pathIR,image_name2));
        image_size=size(IR);
        dimension=numel(image_size);
        if dimension == 3
            IR=rgb2gray(IR);
        end
%         IR=rgb2gray(IR);
        image_name3 = img_path_listVI(m).name;% 图像名     
        VI = imread(strcat(file_pathVI,image_name3));
%         VI=rgb2gray(VI);
        image_size=size(VI);
        dimension=numel(image_size);
        if dimension == 3
            VI=rgb2gray(VI);
        end
        
%         o = ssim(image_pmgi, IR);
%         p = ssim(image_pmgi, VI);
        ssim = fmi(IR, VI, image_pmgi);
%         S = std2(image_IR);
        sum_PMGI = sum_PMGI+ssim;
        PMGI(m) = ssim;
        clear ssim;
    end
end   
% FusionGan
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\实验结果\FusionGAN\epoch12\';% 图像文件夹路径
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%获取该文件夹中所有bmp格式的图像
img_num = length(img_path_list1);%获取图像总数量?
I=cell(1,img_num);
sum_FusionGan = 0;
FusionGan = 1:17;
if img_num > 0 %有满足条件的图像
    for m = 1:17 %逐一读取图像   
        image_name1 = img_path_list1(m).name;% 图像名     
        image_FusionGAN = imread(strcat(file_path1,image_name1));
        image_name2 = img_path_listIR(m).name;% 图像名     
        IR = imread(strcat(file_pathIR,image_name2));
        image_size=size(IR);
        dimension=numel(image_size);
        if dimension == 3
            IR=rgb2gray(IR);
        end
%         IR=rgb2gray(IR);
        image_name3 = img_path_listVI(m).name;% 图像名     
        VI = imread(strcat(file_pathVI,image_name3));
%         VI=rgb2gray(VI);
        image_size=size(VI);
        dimension=numel(image_size);
        if dimension == 3
            VI=rgb2gray(VI);
        end
        
%         o = ssim(image_FusionGAN, IR);
%         p = ssim(image_FusionGAN, VI);
        ssim = fmi(IR, VI, image_FusionGAN);
%         S = std2(image_IR);
        sum_FusionGan = sum_FusionGan+ssim;
        FusionGan(m) = ssim;
        clear ssim;
    end
end 
% GTF
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\实验结果\GTF\';% 图像文件夹路径
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%获取该文件夹中所有bmp格式的图像
img_num = length(img_path_list1);%获取图像总数量?
I=cell(1,img_num);
sum_GTF = 0;
GTF = 1:17;
if img_num > 0 %有满足条件的图像
    for m = 1:17 %逐一读取图像   
        image_name1 = img_path_list1(m).name;% 图像名     
        image_GTF = imread(strcat(file_path1,image_name1));
        image_name2 = img_path_listIR(m).name;% 图像名     
        IR = imread(strcat(file_pathIR,image_name2));
        image_size=size(IR);
        dimension=numel(image_size);
        if dimension == 3
            IR=rgb2gray(IR);
        end
%         IR=rgb2gray(IR);
        image_name3 = img_path_listVI(m).name;% 图像名     
        VI = imread(strcat(file_pathVI,image_name3));
%         VI=rgb2gray(VI);
        image_size=size(VI);
        dimension=numel(image_size);
        if dimension == 3
            VI=rgb2gray(VI);
        end
        
%         o = ssim(image_GTF, IR);
%         p = ssim(image_GTF, VI);
        ssim = fmi(IR, VI, image_GTF);
%         S = std2(image_IR);
        sum_GTF = sum_GTF+ssim;
        GTF(m) = ssim;
        clear ssim;
    end
end 
% LPP
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\实验结果\Densefuse\';% 图像文件夹路径
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%获取该文件夹中所有bmp格式的图像
img_num = length(img_path_list1);%获取图像总数量?
I=cell(1,img_num);
sum_LPP = 0;
LPP = 1:17;
if img_num > 0 %有满足条件的图像
    for m = 1:17 %逐一读取图像   
        image_name1 = img_path_list1(m).name;% 图像名     
        image_LPP = imread(strcat(file_path1,image_name1));
        image_size=size(image_LPP);
        dimension=numel(image_size);
        if dimension == 3
            image_LPP=rgb2gray(image_LPP);
        end
        
        image_name2 = img_path_listIR(m).name;% 图像名     
        IR = imread(strcat(file_pathIR,image_name2));
        image_size=size(IR);
        dimension=numel(image_size);
        if dimension == 3
            IR=rgb2gray(IR);
        end
%         IR=rgb2gray(IR);
        image_name3 = img_path_listVI(m).name;% 图像名     
        VI = imread(strcat(file_pathVI,image_name3));
%         VI=rgb2gray(VI);
        image_size=size(VI);
        dimension=numel(image_size);
        if dimension == 3
            VI=rgb2gray(VI);
        end
        
%         o = ssim(image_LPP, IR);
%         p = ssim(image_LPP, VI);
        ssim = fmi(IR, VI, image_LPP);
%         S = std2(image_IR);
        sum_LPP = sum_LPP+ssim;
        LPP(m) = ssim;
        clear ssim;
    end
end 
% DTCWT
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\实验结果\DTCWT\';% 图像文件夹路径
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%获取该文件夹中所有bmp格式的图像
img_num = length(img_path_list1);%获取图像总数量?
I=cell(1,img_num);
sum_DTCWT = 0;
DTCWT = 1:17;
if img_num > 0 %有满足条件的图像
    for m = 1:17 %逐一读取图像   
        image_name1 = img_path_list1(m).name;% 图像名     
        image_DTCWT = imread(strcat(file_path1,image_name1));
        image_size=size(image_DTCWT);
        dimension=numel(image_size);
        if dimension == 3
            image_DTCWT=rgb2gray(image_DTCWT);
        end
        image_name2 = img_path_listIR(m).name;% 图像名     
        IR = imread(strcat(file_pathIR,image_name2));
        image_size=size(IR);
        dimension=numel(image_size);
        if dimension == 3
            IR=rgb2gray(IR);
        end
%         IR=rgb2gray(IR);
        image_name3 = img_path_listVI(m).name;% 图像名     
        VI = imread(strcat(file_pathVI,image_name3));
%         VI=rgb2gray(VI);
        image_size=size(VI);
        dimension=numel(image_size);
        if dimension == 3
            VI=rgb2gray(VI);
        end
        
%         o = ssim(image_DTCWT, IR);
%         p = ssim(image_DTCWT, VI);
        ssim = fmi(IR, VI, image_DTCWT);
%         S = std2(image_IR);
        sum_DTCWT = sum_DTCWT+ssim;
        DTCWT(m) = ssim;
        clear ssim;
    end
end 



% 画图
sum_GTF=sum_GTF/17;
sum_0URS=sum_0URS/17;
sum_PMGI=sum_PMGI/17;
sum_FusionGan=sum_FusionGan/17;
sum_LPP=sum_LPP/17;
sum_DTCWT=sum_DTCWT/17;
x=1:1:17;%x轴上的数据，第一个值代表数据开始，第二个值代表间隔，第三个值代表终止

c1=plot(x,OURS,'-og',x,PMGI,'-+m',x,FusionGan,'-xc','LineWidth',1.5);
hold on

c2=plot(x,LPP,'-sk',x,GTF,'-hr',x,DTCWT,'->b','LineWidth',1.5);
axis([1,17,0.3,1.2]); %确定x轴与y轴框图大小
set(gca,'XTick',[1:5:17],'LineWidth',1.5); %x轴范围1-6，间隔1
set(gca,'YTick',[0.3:0.1:1.2],'LineWidth',1.5); %y轴范围0-700，间隔100
xlabel('image pairs','FontSize',13,'FontWeight','bold');
ylabel('SSIM','FontSize',13,'FontWeight','bold');
l1=legend(c1,{'OURS:0.6509','PMGI:0.6488','FusionGAN:0.6211'},'Location','NorthWest');
set(l1,'Box','off','Fontname', 'Times New Roman','FontWeight','bold','FontSize',13);
ah=axes('position',get(gca,'position'),'visible','off');
l2=legend(ah,c2,{'Densefuse:0.5728','GTF:0.6239','DTCWT:0.6472'},'Location','NorthEast');
set(l2,'Box','off','Fontname', 'Times New Roman','FontWeight','bold','FontSize',13);