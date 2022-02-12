% %SSIM---------------------------------------------------------------------------------------------------------------------------
% OURS
clear;
file_pathIR ='D:\ZhuoMian\research\NEW_PAPER\ʵ����\testimage\Test_ir\';% ͼ���ļ���·��
img_path_listIR = dir(strcat(file_pathIR,'*.bmp'));%��ȡ���ļ���������bmp��ʽ��ͼ��
file_pathVI ='D:\ZhuoMian\research\NEW_PAPER\ʵ����\testimage\Test_vi\';% ͼ���ļ���·��
img_path_listVI = dir(strcat(file_pathVI,'*.bmp'));%��ȡ���ļ���������bmp��ʽ��ͼ��
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\ʵ����\ours\C_12_5_3_0.5_0.5_6_3_1_1.5_2\epoch8\';% ͼ���ļ���·��
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%��ȡ���ļ���������bmp��ʽ��ͼ��
img_num = length(img_path_list1);%��ȡͼ��������?
I=cell(1,img_num);
OURS = 1:17;
sum_0URS = 0;
if img_num > 0 %������������ͼ��
    for m = 1:17 %��һ��ȡͼ��   
%         image_name1 = img_path_list1(m).name;% ͼ����        
%         image_IR = imread(strcat(file_path1,image_name1));
%         S = std2(image_IR);
%         sum_0URS = sum_0URS+S;
%         OURS(m) = S;
        
        image_name1 = img_path_list1(m).name;% ͼ����     
        image_ours = imread(strcat(file_path1,image_name1));
        image_name2 = img_path_listIR(m).name;% ͼ����     
        IR = imread(strcat(file_pathIR,image_name2));
        image_size=size(IR);
        dimension=numel(image_size);
        if dimension == 3
            IR=rgb2gray(IR);
        end
%         IR=rgb2gray(IR);
        image_name3 = img_path_listVI(m).name;% ͼ����     
        VI = imread(strcat(file_pathVI,image_name3));
%         VI=rgb2gray(VI);
        image_size=size(VI);
        dimension=numel(image_size);
        if dimension == 3
            VI=rgb2gray(VI);
        end
        
%         o = ssim(image_ours, IR);
%         p = ssim(image_ours, VI);
        ssim = Qp_ABF(IR, VI, image_ours);
%         S = std2(image_IR);
        sum_0URS = sum_0URS+ssim;
        OURS(m) = ssim;
        clear ssim;
        
        
    end
end
% PMGI   
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\ʵ����\PMGI\epoch6\';% ͼ���ļ���·��
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%��ȡ���ļ���������bmp��ʽ��ͼ��
img_num = length(img_path_list1);%��ȡͼ��������?
I=cell(1,img_num);
sum_PMGI = 0;
PMGI = 1:17;
if img_num > 0 %������������ͼ��
    for m = 1:17 %��һ��ȡͼ��   
        image_name1 = img_path_list1(m).name;% ͼ����     
        image_pmgi = imread(strcat(file_path1,image_name1));
        image_name2 = img_path_listIR(m).name;% ͼ����     
        IR = imread(strcat(file_pathIR,image_name2));
        image_size=size(IR);
        dimension=numel(image_size);
        if dimension == 3
            IR=rgb2gray(IR);
        end
%         IR=rgb2gray(IR);
        image_name3 = img_path_listVI(m).name;% ͼ����     
        VI = imread(strcat(file_pathVI,image_name3));
%         VI=rgb2gray(VI);
        image_size=size(VI);
        dimension=numel(image_size);
        if dimension == 3
            VI=rgb2gray(VI);
        end
        
%         o = ssim(image_pmgi, IR);
%         p = ssim(image_pmgi, VI);
        ssim = Qp_ABF(IR, VI, image_pmgi);
%         S = std2(image_IR);
        sum_PMGI = sum_PMGI+ssim;
        PMGI(m) = ssim;
        clear ssim;
    end
end   
% FusionGan
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\ʵ����\FusionGAN\epoch12\';% ͼ���ļ���·��
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%��ȡ���ļ���������bmp��ʽ��ͼ��
img_num = length(img_path_list1);%��ȡͼ��������?
I=cell(1,img_num);
sum_FusionGan = 0;
FusionGan = 1:17;
if img_num > 0 %������������ͼ��
    for m = 1:17 %��һ��ȡͼ��   
        image_name1 = img_path_list1(m).name;% ͼ����     
        image_FusionGAN = imread(strcat(file_path1,image_name1));
        image_name2 = img_path_listIR(m).name;% ͼ����     
        IR = imread(strcat(file_pathIR,image_name2));
        image_size=size(IR);
        dimension=numel(image_size);
        if dimension == 3
            IR=rgb2gray(IR);
        end
%         IR=rgb2gray(IR);
        image_name3 = img_path_listVI(m).name;% ͼ����     
        VI = imread(strcat(file_pathVI,image_name3));
%         VI=rgb2gray(VI);
        image_size=size(VI);
        dimension=numel(image_size);
        if dimension == 3
            VI=rgb2gray(VI);
        end
        
%         o = ssim(image_FusionGAN, IR);
%         p = ssim(image_FusionGAN, VI);
        ssim = Qp_ABF(IR, VI, image_FusionGAN);
%         S = std2(image_IR);
        sum_FusionGan = sum_FusionGan+ssim;
        FusionGan(m) = ssim;
        clear ssim;
    end
end 
% GTF
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\ʵ����\GTF\';% ͼ���ļ���·��
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%��ȡ���ļ���������bmp��ʽ��ͼ��
img_num = length(img_path_list1);%��ȡͼ��������?
I=cell(1,img_num);
sum_GTF = 0;
GTF = 1:17;
if img_num > 0 %������������ͼ��
    for m = 1:17 %��һ��ȡͼ��   
        image_name1 = img_path_list1(m).name;% ͼ����     
        image_GTF = imread(strcat(file_path1,image_name1));
        image_name2 = img_path_listIR(m).name;% ͼ����     
        IR = imread(strcat(file_pathIR,image_name2));
        image_size=size(IR);
        dimension=numel(image_size);
        if dimension == 3
            IR=rgb2gray(IR);
        end
%         IR=rgb2gray(IR);
        image_name3 = img_path_listVI(m).name;% ͼ����     
        VI = imread(strcat(file_pathVI,image_name3));
%         VI=rgb2gray(VI);
        image_size=size(VI);
        dimension=numel(image_size);
        if dimension == 3
            VI=rgb2gray(VI);
        end
        
%         o = ssim(image_GTF, IR);
%         p = ssim(image_GTF, VI);
        ssim = Qp_ABF(IR, VI, image_GTF);
%         S = std2(image_IR);
        sum_GTF = sum_GTF+ssim;
        GTF(m) = ssim;
        clear ssim;
    end
end 
% Densefuse
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\ʵ����\Densefuse\';% ͼ���ļ���·��
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%��ȡ���ļ���������bmp��ʽ��ͼ��
img_num = length(img_path_list1);%��ȡͼ��������?
I=cell(1,img_num);
sum_Densefuse = 0;
Densefuse = 1:17;
if img_num > 0 %������������ͼ��
    for m = 1:17 %��һ��ȡͼ��   
        image_name1 = img_path_list1(m).name;% ͼ����     
        image_LPP = imread(strcat(file_path1,image_name1));
        image_size=size(image_LPP);
        dimension=numel(image_size);
        if dimension == 3
            image_LPP=rgb2gray(image_LPP);
        end
        
        image_name2 = img_path_listIR(m).name;% ͼ����     
        IR = imread(strcat(file_pathIR,image_name2));
        image_size=size(IR);
        dimension=numel(image_size);
        if dimension == 3
            IR=rgb2gray(IR);
        end
%         IR=rgb2gray(IR);
        image_name3 = img_path_listVI(m).name;% ͼ����     
        VI = imread(strcat(file_pathVI,image_name3));
%         VI=rgb2gray(VI);
        image_size=size(VI);
        dimension=numel(image_size);
        if dimension == 3
            VI=rgb2gray(VI);
        end
        
%         o = ssim(image_LPP, IR);
%         p = ssim(image_LPP, VI);
        ssim = Qp_ABF(IR, VI, image_LPP);
%         S = std2(image_IR);
        sum_Densefuse = sum_Densefuse+ssim;
        Densefuse(m) = ssim;
        clear ssim;
    end
end 
% DTCWT
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\ʵ����\DTCWT\';% ͼ���ļ���·��
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%��ȡ���ļ���������bmp��ʽ��ͼ��
img_num = length(img_path_list1);%��ȡͼ��������?
I=cell(1,img_num);
sum_DTCWT = 0;
DTCWT = 1:17;
if img_num > 0 %������������ͼ��
    for m = 1:17 %��һ��ȡͼ��   
        image_name1 = img_path_list1(m).name;% ͼ����     
        image_DTCWT = imread(strcat(file_path1,image_name1));
        image_size=size(image_DTCWT);
        dimension=numel(image_size);
        if dimension == 3
            image_DTCWT=rgb2gray(image_DTCWT);
        end
        image_name2 = img_path_listIR(m).name;% ͼ����     
        IR = imread(strcat(file_pathIR,image_name2));
        image_size=size(IR);
        dimension=numel(image_size);
        if dimension == 3
            IR=rgb2gray(IR);
        end
%         IR=rgb2gray(IR);
        image_name3 = img_path_listVI(m).name;% ͼ����     
        VI = imread(strcat(file_pathVI,image_name3));
%         VI=rgb2gray(VI);
        image_size=size(VI);
        dimension=numel(image_size);
        if dimension == 3
            VI=rgb2gray(VI);
        end
        
%         o = ssim(image_DTCWT, IR);
%         p = ssim(image_DTCWT, VI);
        ssim = Qp_ABF(IR, VI, image_DTCWT);
%         S = std2(image_IR);
        sum_DTCWT = sum_DTCWT+ssim;
        DTCWT(m) = ssim;
        clear ssim;
    end
end 
% FPED
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\ʵ����\FPED\';% ͼ���ļ���·��
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%��ȡ���ļ���������bmp��ʽ��ͼ��
img_num = length(img_path_list1);%��ȡͼ��������?
I=cell(1,img_num);
sum_FPED = 0;
FPED = 1:17;
if img_num > 0 %������������ͼ��
    for m = 1:17 %��һ��ȡͼ��   
        image_name1 = img_path_list1(m).name;% ͼ����     
        image_LPP = imread(strcat(file_path1,image_name1));
        image_size=size(image_LPP);
        dimension=numel(image_size);
        if dimension == 3
            image_LPP=rgb2gray(image_LPP);
        end
        
        image_name2 = img_path_listIR(m).name;% ͼ����     
        IR = imread(strcat(file_pathIR,image_name2));
        image_size=size(IR);
        dimension=numel(image_size);
        if dimension == 3
            IR=rgb2gray(IR);
        end
%         IR=rgb2gray(IR);
        image_name3 = img_path_listVI(m).name;% ͼ����     
        VI = imread(strcat(file_pathVI,image_name3));
%         VI=rgb2gray(VI);
        image_size=size(VI);
        dimension=numel(image_size);
        if dimension == 3
            VI=rgb2gray(VI);
        end
        
%         o = ssim(image_LPP, IR);
%         p = ssim(image_LPP, VI);
        ssim = Qp_ABF(IR, VI, image_LPP);
%         S = std2(image_IR);
        sum_FPED = sum_FPED+ssim;
        FPED(m) = ssim;
        clear ssim;
    end
end 
% IFEVIP
file_path1 ='D:\ZhuoMian\research\NEW_PAPER\ʵ����\IFEVIP\';% ͼ���ļ���·��
img_path_list1 = dir(strcat(file_path1,'*.bmp'));%��ȡ���ļ���������bmp��ʽ��ͼ��
img_num = length(img_path_list1);%��ȡͼ��������?
I=cell(1,img_num);
sum_IFEVIP = 0;
IFEVIP = 1:17;
if img_num > 0 %������������ͼ��
    for m = 1:17 %��һ��ȡͼ��   
        image_name1 = img_path_list1(m).name;% ͼ����     
        image_DTCWT = imread(strcat(file_path1,image_name1));
        image_size=size(image_DTCWT);
        dimension=numel(image_size);
        if dimension == 3
            image_DTCWT=rgb2gray(image_DTCWT);
        end
        image_name2 = img_path_listIR(m).name;% ͼ����     
        IR = imread(strcat(file_pathIR,image_name2));
        image_size=size(IR);
        dimension=numel(image_size);
        if dimension == 3
            IR=rgb2gray(IR);
        end
%         IR=rgb2gray(IR);
        image_name3 = img_path_listVI(m).name;% ͼ����     
        VI = imread(strcat(file_pathVI,image_name3));
%         VI=rgb2gray(VI);
        image_size=size(VI);
        dimension=numel(image_size);
        if dimension == 3
            VI=rgb2gray(VI);
        end
        
%         o = ssim(image_DTCWT, IR);
%         p = ssim(image_DTCWT, VI);
        ssim = Qp_ABF(IR, VI, image_DTCWT);
%         S = std2(image_IR);
        sum_IFEVIP = sum_IFEVIP+ssim;
        IFEVIP(m) = ssim;
        clear ssim;
    end
end 



% ��ͼ
sum_GTF=sum_GTF/17;
sum_0URS=sum_0URS/17;
sum_PMGI=sum_PMGI/17;
sum_FusionGan=sum_FusionGan/17;
sum_Densefuse=sum_Densefuse/17;
sum_DTCWT=sum_DTCWT/17;
sum_FPED=sum_FPED/17;
sum_IFEVIP=sum_IFEVIP/17;
x=1:1:17;%x���ϵ����ݣ���һ��ֵ�������ݿ�ʼ���ڶ���ֵ��������������ֵ������ֹ

c1=plot(x,OURS,'-og',x,PMGI,'-+m',x,FusionGan,'-xc',x,Densefuse,'-pc','LineWidth',1.5);
hold on

c2=plot(x,IFEVIP,'-sk',x,FPED,'-dc',x,GTF,'-hr',x,DTCWT,'->b','LineWidth',1.5);
axis([1,17,0,0.48]); %ȷ��x����y���ͼ��С
set(gca,'XTick',[1:5:17],'LineWidth',1.5); %x�᷶Χ1-6�����1
set(gca,'YTick',[0:0.1:0.48],'LineWidth',1.5); %y�᷶Χ0-700�����100
xlabel('image pairs','FontSize',13,'FontWeight','bold');
ylabel('QG','FontSize',13,'FontWeight','bold');
l1=legend(c1,{'OURS:0.0920','PMGI:0.0695','FusionGAN:0.0.0283','DenseFuse:0.0.0283'},'Location','NorthWest');
set(l1,'Box','off','Fontname', 'Times New Roman','FontWeight','bold','FontSize',13);
ah=axes('position',get(gca,'position'),'visible','off');
l2=legend(ah,c2,{'IFEVIP:0.0541','FPWD:0.0.0283','GTF:0.0101','DTCWT:0.0220'},'Location','NorthEast');
set(l2,'Box','off','Fontname', 'Times New Roman','FontWeight','bold','FontSize',13);