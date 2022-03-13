clc, clear, close all;

%% change directory
prev_dir = pwd; file_dir = fileparts(mfilename('fullpath')); cd(file_dir);
addpath(genpath(pwd));

%% MEF-SSIM-based optimization
img_seq = uint8(load_images('./images/tower',1));
image = imread('./images/Tower_Mertens07.png');
figure;
[out_image, score] = MEFO(img_seq, image);