% -------------------------------------------------------------------------
% Matlab demo code for "Quadtree-based multi-focus image fusion using a 
% weighted focus-measure, Information Fusion 22 (2015) 105-118". 
% Implemented by ZhangYu, Image Processing Center, BUAA
% Email: uzeful@163.com
% -------------------------------------------------------------------------

% Clear history and memory
clc; clear; close all;

%--------------------- Configurating the parameters -----------------------
% Initialise the maximum split level
for i=1:4
    
    level = 0;

    % image set name string, default: 'clock'. All image sets:
    % clock'|'lab'|'pepsi'|'OpenGL'|'flower'|'disk'|'toy'
    name = 'flower';

    % Set the image type.
    type = '.bmp';

    % Set the image number: the number of images in image set toy is 3, 
    % and the image number of the other sets is 2.
    num = 2; 

    %--------------------- Quadtree based image fusion -----------------------
    tic
    [fimg, decision_map] = Quadtree_Fusion(name, type, num, level,i);
    Time_QBMF(i)=toc;

    %------------------------- Show the fusion image -------------------------
%     figure,imshow(fimg);
    imwrite(fimg, strcat('C:\Users\HJL\Desktop\result\',num2str(i),'.jpg')); 

end