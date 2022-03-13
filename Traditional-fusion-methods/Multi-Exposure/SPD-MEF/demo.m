clc, clear, close all;

%% change directory
prev_dir = pwd; file_dir = fileparts(mfilename('fullpath')); cd(file_dir);
addpath(genpath(pwd));
for i=1:60
    I1=imread(strcat('C:\Users\Train_ir\',num2str(i),'.jpg'));
    I2=imread(strcat('C:\Users\Train_vi\',num2str(i),'.jpg'));
    imwrite(I1,strcat('C:\Users\SPD-MEF\source\1.jpg'))
    imwrite(I2,strcat('C:\Users\SPD-MEF\source\2.jpg'))
    %% read source image sequence
    imagePath = strcat('.\source');
    imgSeqColor = loadImg(imagePath); % use im2double
    imgSeqColor = reorderByLum(imgSeqColor);
%     imgSeqColor = downSample(imgSeqColor, 1024);

    %% structural patch decomposition based multi-exposure image fusion (SPD-MEF)
    tic
    fI = spd_mef(imgSeqColor);
    time(i)=toc;
%     figure, imshow(fI);

     imwrite(fI,strcat('C:\Users\SPD-MEF\result\',num2str(i),'.jpg'))
end
