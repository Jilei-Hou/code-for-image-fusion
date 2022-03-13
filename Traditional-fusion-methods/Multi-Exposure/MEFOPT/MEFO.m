function [opt_image, S] = MEFO(img_seq_color, fused_img, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ==========================================================================%
% Multi Exposure Image Fusion Based on MEF-SSIM_c Optimization, Version 1.0 %
% Copyright(c) 2014 Kede Ma, Zhengfang Duanmu, Hojat Yeganeh and Zhou Wang  %
% All Rights Reserved.                                                      %
%                                                                           %
% --------------------------------------------------------------------------%
% Permission to use, copy, or modify this software and its documentation    %
% for educational and research purposes only and without fee is hereby      %
% granted, provided that this copyright notice and the original authors'    %
% names appear on all copies and supporting documentation. This program     %
% shall not be used, rewritten, or adapted as the basis of a commercial     %
% software or hardware product without first obtaining permission of the    %
% authors. The authors make no representations about the suitability of     %
% this software for any purpose. It is provided "as is" without express     %
% or implied warranty.                                                      %
%---------------------------------------------------------------------------%
% This is an implementation of multi exposure image fusion based on         %   
% MEF-SSIM_c optimization.                                                  %
%                                                                           %
% Please refer to the following papers with suggested usage:                %
%                                                                           %
% K. Ma, Z. Duanmu, H. Yeganeh, and Z. Wang, "Multi-Exposure Image Fusion   %
% by Optimizing A Structural Similarity Index," submitted to IEEE           %
% Transactions on Computational Imaging.                                    %
%                                                                           %
% K. Ma, K. Zeng, and Z. Wang, "Perceptual Quality Assessment for           %
% Multi-Exposure Image Fusion," IEEE Transactios on Image Processing,       %
% Dec. 2014.                                                                %
%                                                                           %
% Kindly report any suggestions or corrections to k29ma@uwaterloo.ca,       %
% zduanmu@uwaterloo.ca, or zhouwang@ieee.org                                %
%                                                                           %
%---------------------------------------------------------------------------%
% MEF SSIM optimization                                                     %
%   input:  1. image sequences at multiple exposure levels [0-255]          %
%           2. fused image [0-255]                                          %
%   optional input:                                                         %
%           1. D1: constant D1 (default 0.01)                               %
%           2. D2: constant D2 (default 0.03)                               %
%           3. sigma_g: global sigma (default 0.2)                          %
%           4. sigma_l: local sigma (default 0.2)                           %
%           5. window: sliding window (default 8x8 average window)          %
%           6. adaptive_lum: whether luminance formula is adopted           % 
%              (default 1)                                                  %
%           7. max_iter: maximum number of iteration (defualt 100)          %
%           8. cvg_t: convergance threshold (default 5e-6)                  %
%           9. beta_inverse: step size (default 150)                        %
%           10. plot_prg: plot progress flag (default true)                 %
%           11. write_qmap: output quality map flag (default true)          %
%           12. write_progress: output update progress                      %
%           (default true)                                                  %
%           13. filename: input filename (write_image has to be set         %
%           14. algorithm: input fusion image algorithm                     % 
%                                                                           %
%   output:                                                                 %
%           1. opt_image: optimized image                                   %
% Basic Usage:                                                              %
%   Given multi exposure image sequence and fused image                     % 
%                                                                           %
%   [opt_image] = MEFO(img_seq_color, fused_img);                           %
%                                                                           %
% Advanced Usage:                                                           %
%   User defined parameters. For example                                    %
%   window = fspecial('gaussian', 11, 1.5);                                 %
%   [opt_image] = MEFO(img_seq_color, fused_img, 'window', window);         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% input params parsing
    p = inputParser;
    
    default_D1 = 0.01;
    default_D2 = 0.03;
    default_sigma_g = 0.2;
    default_sigma_l = 0.2;
    default_window = ones([8,8,3]) / 192;
    default_adaptive_lum = 1;
    default_max_iter = 100;
    default_cvg_t = 2e-6;
    default_beta_inverse = 150;
    default_plot_prg = 1;
    default_write_qmap = 0;
    default_write_progress = 0;
    default_filename = 'null';
    default_algorithm = 'null';
    
    addRequired(p,'img_seq_color');
    addRequired(p,'fused_img');
    addParameter(p, 'D1', default_D1, @isnumeric);
    addParameter(p, 'D2', default_D2, @isnumeric);
    addParameter(p, 'sigma_g', default_sigma_g, @isnumeric);
    addParameter(p, 'sigma_l', default_sigma_l, @isnumeric);
    addParameter(p, 'window', default_window, @isnumeric);
    addParameter(p, 'adaptive_lum', default_adaptive_lum, @isnumeric);
    addParameter(p, 'max_iter', default_max_iter, @isnumeric);
    addParameter(p, 'cvg_t', default_cvg_t, @isnumeric);
    addParameter(p, 'beta_inverse', default_beta_inverse, @isnumeric);
    addParameter(p, 'plot_prg', default_plot_prg, @isnumeric);
    addParameter(p, 'write_qmap', default_write_qmap, @isnumeric);
    addParameter(p, 'write_progress', default_write_progress, @isnumeric);
    addParameter(p, 'filename', default_filename);
    addParameter(p, 'algorithm', default_algorithm);
    parse(p, img_seq_color, fused_img, varargin{:});
    
    
    %% initialization
    max_iter = p.Results.max_iter;
    cvg_t = p.Results.cvg_t;
    beta_inverse = p.Results.beta_inverse;
    plot_prg = p.Results.plot_prg;
    write_qmap = p.Results.write_qmap;
    filename = p.Results.filename;
    algorithm = p.Results.algorithm;
    write_progress = p.Results.write_progress;
    
    if write_qmap
        if strcmp(filename, 'null')
            error('Fused image name needs to be specified.');
        end
        
        if strcmp(algorithm, 'null')
            error('Please specify the MEF algorithm.');
        end
    end
   
    % reference patch selection
    [out_params] = generate_reference_patches(img_seq_color, p.Results.window, p.Results.adaptive_lum, p.Results.sigma_g, p.Results.sigma_l);
    fused_img = double(fused_img);
    [H, W, C] = size(fused_img);
    
    iter = 0;
    params.D1 = p.Results.D1;
    params.D2 = p.Results.D2;
    params.img_seq_color = img_seq_color;
    params.window = p.Results.window;
    
    params.muY = out_params.muY;
    params.muY_sq = out_params.muY_sq;
    params.muY_seq = out_params.muY_seq;
    params.muY_sq_seq = out_params.muY_sq_seq;
    params.sigmaY_sq = out_params.sigmaY_sq;
    params.sigmaY_sq_seq = out_params.sigmaY_sq_seq;
    params.patch_index = out_params.patch_index;
    params.adaptive_lum = p.Results.adaptive_lum;
    
    lambda_old = 1;
    % fused image vector
    x_old = fused_img(:);
    y_old = x_old;
    % the number of over/underflow pixels in each iteration
    flow_num = zeros(max_iter,1);
    % MEF score in each iteration
    S = zeros(max_iter,1);
    % norm of grdt in each iteration
    G = zeros(max_iter,1);
    
    disp(['  iter        ','S             ','||Grad||        ', '||x_new - x_old||     ', ...
    ' FlowPixels  ',' TimeElapsed ']);
    
    [Q, grdt, init_qmap] = costFun(x_old, params);
    %out = gradientCheck(@(x) costFun(x,params), x_old,'DifferenceStep',1e-6,'DifferenceType','centered');
    if write_qmap
        init_qmap_path = '.\initial_qmap\';
        final_qmap_path = '.\final_qmap\';
        init_img_name = [init_qmap_path algorithm '\' filename '_qmap.png'];
        imwrite(init_qmap, init_img_name);
    end
    
    if write_progress
        progress_qmap_path = '.\progress\qmap\';
        progress_img_path = '.\progress\image\';
    end
    
    disp([sprintf('  %3d',iter), sprintf('     %.7f',Q)]);
    
    %% grdt acsent
    while iter < max_iter
        tic
        iter = iter + 1;
        
        % shrink the threshold (disabled)
%         if mod(iter,250) == 0
%             beta_inverse = beta_inverse / 2;
%         end
        
        % Nesterov's Accelerated Gradient Descent
        lambda_new = (1+sqrt(1+4*lambda_old.^2))/2;
        gamma = (1-lambda_old)/lambda_new;
        
        y_new = x_old + beta_inverse.*grdt;
        x_new = (1-gamma)*y_new + gamma*y_old;
        overflow_ind = x_new > 255;
        x_new(overflow_ind) = 255;
        underflow_ind = x_new < 0;
        x_new(underflow_ind) = 0;
        flow_num(iter) = sum(overflow_ind) + sum(underflow_ind);

        % MEF-SSIM quality score, grdt, qaulity map
        [Q, grdt, q_map] = costFun(x_new, params);
        S(iter) = Q;
        G(iter) = norm(grdt);
        elpsd_t = toc;
        
        % save the fused_imggure in some fused_imgxed steps (default: in every 5 steps)
        %if plot_prg && mod(iter,5) == 0 
        if plot_prg
            %fused_imglename = sprintf('%s/Iter_%d_S_%.4f',options.savePath, iter, S(iter));
            new_img = reshape(x_new, [H, W, C]);
            subplot(1,3,1), imshow(fused_img/255), title('Initial Image');
            subplot(1,3,2), imshow(new_img/255), title('Optimized Image');
            subplot(1,3,3), imshow(q_map), title('Quality Map');
            tit = ['iteration: ' num2str(iter)  '         score: ' num2str(Q)];
            suptitle(tit);
            pause(0.0001);
        end
        disp([sprintf('  %3d',iter), sprintf('     %.7f',S(iter)),...
            sprintf('       %11.7f',G(iter)), sprintf('        %11.7f',norm(x_new - x_old)), ...
            sprintf('          %4d',flow_num(iter)),sprintf('          %6.3f',elpsd_t)]);
 
        if (iter > 1)
            if abs(S(iter) - S(iter-1)) < cvg_t 
                break;
            end
            
            if write_progress && (mod(iter,20) == 0)
                image_name = [progress_qmap_path algorithm '\' filename '_iter_' num2str(iter) '.png'];
                imwrite(q_map, image_name);
                new_img = (reshape(x_new, [H, W, C]))/255;
                image_name = [progress_img_path algorithm '\' filename '_iter_' num2str(iter) '.png'];
                imwrite(new_img, image_name);
            end
        end
        x_old = x_new;
        lambda_old = lambda_new;
        y_old = y_new;
    end
    
    x = x_new;
    opt_image = uint8(reshape(x,[H, W, C]));
    
    if write_qmap
        final_qmap_name = [final_qmap_path algorithm '\' filename '.png'];
        imwrite(q_map, final_qmap_name);
    end
end

