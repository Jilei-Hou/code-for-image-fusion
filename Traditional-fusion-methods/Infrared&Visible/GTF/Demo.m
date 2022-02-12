clc;
clear;
close all;
warning off;
addpath(genpath(cd));

file_path1 ='C:\Users\HJL\Desktop\demo\IR_VI\ir\';% path of source image1
file_path2 ='C:\Users\HJL\Desktop\demo\IR_VI\vi\';% path of source image2

img_path_list1 = dir(strcat(file_path1,'*.bmp'));
img_path_list2 = dir(strcat(file_path2,'*.bmp'));
img_num = 26;
time1=clock; 
if img_num > 0 
    for m = 1:img_num 
        image_name1 = img_path_list1(m).name;
        image_name2 = img_path_list2(m).name;
        I=double(imread(strcat(file_path1,image_name1)))/255;
        V=double(imread(strcat(file_path2,image_name2)))/255;
        image_size=size(I);
        dimension=numel(image_size);
        if dimension == 3
            I=double(rgb2gray(imread(strcat(file_path1,image_name1))))/255;
        end
        
        image_size2=size(V);
        dimension2=numel(image_size2);
        if dimension2 == 3
            V=double(rgb2gray(imread(strcat(file_path2,image_name2))))/255;
        end
        
        calc_metric = 1; 
        ind=findstr(image_name1,'.');
        list=image_name1(1:ind-1);
      
        %
        %The proposed GTF
         
        
        nmpdef;
        pars_irn = irntvInputPars('l1tv');

        pars_irn.adapt_epsR   = 1;
        pars_irn.epsR_cutoff  = 0.01;   % This is the percentage cutoff
        pars_irn.adapt_epsF   = 1;
        pars_irn.epsF_cutoff  = 0.05;   % This is the percentage cutoff
        pars_irn.pcgtol_ini = 1e-4;
        pars_irn.loops      = 5;
        pars_irn.U0         = I-V;
        pars_irn.variant       = NMP_TV_SUBSTITUTION;
        pars_irn.weight_scheme = NMP_WEIGHTS_THRESHOLD;
        pars_irn.pcgtol_ini    = 1e-2;
        pars_irn.adaptPCGtol   = 1;

        tic;
        U = irntv(I-V, {}, 4, pars_irn);
        time_GTF(m)=toc;

        X=U+V;
        X=im2gray(X);

        imwrite(X,['C:\Users\HJL\Desktop\demo\IR_VI\fusion\',list,'.bmp']);

        if calc_metric, Result = Metric(uint8(abs(I)*255),uint8(abs(V)*255),uint8(abs(X*255))); end
 
    end
end

time2=clock;  
T=etime(time2,time1);
disp(['Time:',num2str(T)]);


