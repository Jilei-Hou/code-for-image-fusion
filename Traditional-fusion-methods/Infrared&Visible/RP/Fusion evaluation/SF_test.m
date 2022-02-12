%SD---------------------------------------------------------------------------------------------------------------------------
% OURS
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\实验结果\ours\C_12_5_3_0.5_0.5_6_3_1_1.5_2\epoch8\';% 图像文件夹路径
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%获取该文件夹中所有bmp格式的图像
img_num = length(img_path_list1);%获取图像总数量?
I=cell(1,img_num);
OURS = 1:17;
sum_0URS = 0;
if img_num > 0 %有满足条件的图像
    for m = 1:17 %逐一读取图像   
        image_name1 = img_path_list1(m).name;% 图像名
        
        image_IR = imread(strcat(file_path1,image_name1));
%         En = entrCompute(image_IR,1);
% %         S = std2(image_IR);
%         sum_0URS = sum_0URS+En;
%         OURS(m) = En;
        S = func_evaluate_spatial_frequency(image_IR);
        sum_0URS = sum_0URS+S;
        OURS(m) = S;
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
        
        image_IR = imread(strcat(file_path1,image_name1));
%         En = entrCompute(image_IR,1);
% %         S = std2(image_IR);
%         sum_PMGI = sum_PMGI+En;
%         PMGI(m) = En;
        S = func_evaluate_spatial_frequency(image_IR);
        sum_PMGI = sum_PMGI+S;
        PMGI(m) = S;
    end
end   
% FusionGan
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\实验结果\FusionGAN2\';% 图像文件夹路径
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%获取该文件夹中所有bmp格式的图像
img_num = length(img_path_list1);%获取图像总数量?
I=cell(1,img_num);
sum_FusionGan = 0;
FusionGan = 1:17;
if img_num > 0 %有满足条件的图像
    for m = 1:17 %逐一读取图像   
        image_name1 = img_path_list1(m).name;% 图像名
        
        image_IR = imread(strcat(file_path1,image_name1));
%         En = entrCompute(image_IR,1);
% %         S = std2(image_IR);
%         sum_FusionGan = sum_FusionGan+En;
%         FusionGan(m) = En;
        S = func_evaluate_spatial_frequency(image_IR);
        sum_FusionGan = sum_FusionGan+S;
        FusionGan(m) = S;
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
        
        image_IR = imread(strcat(file_path1,image_name1));
%         En = entrCompute(image_IR,1);
% %         S = std2(image_IR);
%         sum_GTF = sum_GTF+En;
%         GTF(m) = En;
        S = func_evaluate_spatial_frequency(image_IR);
        sum_GTF = sum_GTF+S;
        GTF(m) = S;
    end
end 
% Densefuse
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\实验结果\Densefuse\';% 图像文件夹路径
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%获取该文件夹中所有bmp格式的图像
img_num = length(img_path_list1);%获取图像总数量?
I=cell(1,img_num);
sum_Densefuse = 0;
Densefuse = 1:17;
if img_num > 0 %有满足条件的图像
    for m = 1:17 %逐一读取图像   
        image_name1 = img_path_list1(m).name;% 图像名
        
        image_IR = imread(strcat(file_path1,image_name1));
        image_size=size(image_IR);
        dimension=numel(image_size);
        if dimension == 3
            image_IR=rgb2gray(image_IR);
        end
%         En = entrCompute(image_IR,1);
% %         S = std2(image_IR);
%         sum_LPP = sum_LPP+En;
%         LPP(m) = En;
        S = func_evaluate_spatial_frequency(image_IR);
        sum_Densefuse = sum_Densefuse+S;
        Densefuse(m) = S;
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
        
        image_IR = imread(strcat(file_path1,image_name1));
        image_size=size(image_IR);
        dimension=numel(image_size);
        if dimension == 3
            image_IR=rgb2gray(image_IR);
        end
%         En = entrCompute(image_IR,1);
% %         S = std2(image_IR);
%         sum_DTCWT = sum_DTCWT+En;
%         DTCWT(m) = En;
        S = func_evaluate_spatial_frequency(image_IR);
        sum_DTCWT = sum_DTCWT+S;
        DTCWT(m) = S;
    end
end 

% FPED
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\实验结果\FPED\';% 图像文件夹路径
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%获取该文件夹中所有bmp格式的图像
img_num = length(img_path_list1);%获取图像总数量?
I=cell(1,img_num);
sum_FPED = 0;
FPED = 1:17;
if img_num > 0 %有满足条件的图像
    for m = 1:17 %逐一读取图像   
        image_name1 = img_path_list1(m).name;% 图像名
        
        image_IR = imread(strcat(file_path1,image_name1));
%         En = entrCompute(image_IR,1);
% %         S = std2(image_IR);
%         sum_LPP = sum_LPP+En;
%         LPP(m) = En;
        S = func_evaluate_spatial_frequency(image_IR);
        sum_FPED = sum_FPED+S;
        FPED(m) = S;
    end
end 
% IFEVIP
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\实验结果\IFEVIP\';% 图像文件夹路径
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%获取该文件夹中所有bmp格式的图像
img_num = length(img_path_list1);%获取图像总数量?
I=cell(1,img_num);
sum_IFEVIP = 0;
IFEVIP = 1:17;
if img_num > 0 %有满足条件的图像
    for m = 1:17 %逐一读取图像   
        image_name1 = img_path_list1(m).name;% 图像名
        
        image_IR = imread(strcat(file_path1,image_name1));
%         En = entrCompute(image_IR,1);
% %         S = std2(image_IR);
%         sum_DTCWT = sum_DTCWT+En;
%         DTCWT(m) = En;
        S = func_evaluate_spatial_frequency(image_IR);
        sum_IFEVIP = sum_IFEVIP+S;
        IFEVIP(m) = S;
    end
end 

% 画图
sum_GTF=sum_GTF/17;
sum_0URS=sum_0URS/17;
sum_PMGI=sum_PMGI/17;
sum_FusionGan=sum_FusionGan/17;
sum_Densefuse=sum_Densefuse/17;
sum_DTCWT=sum_DTCWT/17;
sum_FPED=sum_FPED/17;
sum_IFEVIP=sum_IFEVIP/17;
x=1:1:17;%x轴上的数据，第一个值代表数据开始，第二个值代表间隔，第三个值代表终止

c1=plot(x,OURS,'-og',x,PMGI,'-+m',x,FusionGan,'-xc',x,Densefuse,'-pc','LineWidth',1.5);
hold on

c2=plot(x,IFEVIP,'-sk',x,FPED,'-dc',x,GTF,'-hr',x,DTCWT,'->b','LineWidth',1.5);
axis([1,17,2,12]); %确定x轴与y轴框图大小
set(gca,'XTick',[2:3:12],'LineWidth',1.5); %x轴范围1-6，间隔1
set(gca,'YTick',[2:3:12],'LineWidth',1.5); %y轴范围0-700，间隔100
xlabel('image pairs','FontSize',13,'FontWeight','bold');
ylabel('SF','FontSize',13,'FontWeight','bold');
l1=legend(c1,{'OURS:5.9262','PMGI:5.5250','FusionGAN:5.5206','DenseFuse:4.4230'},'Location','NorthWest');
set(l1,'Box','off','Fontname', 'Times New Roman','FontWeight','bold','FontSize',13);
ah=axes('position',get(gca,'position'),'visible','off');
l2=legend(ah,c2,{'IFEVIP:5.6340','FPED:4.9310','GTF:4.7622','DTCWT:5.3079'},'Location','NorthEast');
set(l2,'Box','off','Fontname', 'Times New Roman','FontWeight','bold','FontSize',13);