function amef_demo
% This set of matlab files implements the image dehazing method explained
% in:
% Galdran, A., "Artificial Multiple Exposure Image Dehazing", 2018
% which has been accepted publication in Elsevier's Signal Processing
% Journal.

% The fusion part relies heavily in the method presented in:
%   "Exposure Fusion"
%   Tom Mertens, Jan Kautz and Frank Van Reeth
%   In Proceedings of Pacific Graphics 2007
% If you find useful this method, please consider citing the original 
% paper. If you are only interested in the fusion part of the technique,
% please consider citing Mertens' work.

clc
clear all


% process a demo image
path = '../demo_images/';
% images shown in the paper
% im_name = [path, 'road_input.png']; % Fig. 10
% im_name = [path, '89.bmp']; % Fig. 7
% im_name = [path, '91.jpg']; % Fig. 9
% im_name = [path, '98.bmp']; % Fig. 1
% im_name = [path, 'HazyDay.png']; % Fig. 8
% im_name = [path, 'horses.jpg']; % Fig. 6
% im_name = [path, 'mumbai.jpg']; % Fig. 13
im_name = [path, 'landscape2-Tangkt.png']; % Fig. 11

% other examples
% im_name = [path, '2.jpg'];
% im_name = [path, '51.jpg'];
% im_name = [path, '88.jpg'];
% im_name = [path, '99.png'];
% im_name = [path, '100.png'];
% im_name = [path, 'fc7.jpg'];
% im_name = [path, 'IMG_4681_resize.jpg'];
% im_name = [path, 'Bu_Wf_D_L_040.jpg'];
% im_name = [path, '40.jpg'];
% im_name = [path, 'beijing3.png'];





I_hazy = imread(im_name);

% Increase clip_range to remove more haze - at the risk of overenhancement
clip_range = 0.010;

tic
amef_im = amef(im2double(I_hazy), clip_range);
time = toc;


[m, n, ~] = size(I_hazy);
disp(['Resolution: ', num2str(m), ' x ', num2str(n)])
disp(['Processing time: ', num2str(time)])


figure(1), imshow(I_hazy)
figure(2), imshow(amef_im)

end