function [out_params] = generate_reference_patches( img_seq_color, window, adaptive_lum, sigma_g, sigma_l )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The function extract the reference patch index, mu, sigma square, input                       %
% sequence mu, and input sequence sigma square                                                  %
%   input:  1. image sequences under multiple exposure level                                    %
%           2. window: sliding window (default 8x8 average window)                              %
%           3. adaptive_lum: whether to enable adaptive luminance                               %
%                                                                                               %
%   output struct:                                                                              %
%           1. patch_index: patch index of the patch with the maximum                           %
%           euclidean length                                                                    %
%           2. muY: selected patch means                                                        %
%           3. muY_sq: selected patch mean square                                               %
%           4. muY_seq: means of each input image                                               %
%           5. muY_sq_seq: mean square of each input image                                      %
%           6. sigmaY_sq: sigma square of the selected patch                                    %
%           7. sigmaY_sq_seq: sigma square of each input image                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    img_seq_color = double(img_seq_color);
    
    if (max(img_seq_color(:)) < 1)
        img_seq_color = img_seq_color * 255;
    end
    
    [H, W, ~, K] = size(img_seq_color);
    w_size = size(window,1);
    muY_seq = zeros(H-w_size+1, W-w_size+1, K);
    muY_sq_seq = zeros(H-w_size+1, W-w_size+1, K);
    sigmaY_sq_seq = zeros(H-w_size+1, W-w_size+1, K);
    


    if (adaptive_lum ~= 0)
        denom_g = 2 * sigma_g^2;
        denom_l = 2 * sigma_l^2;
        lY = zeros(K,1);
        LY = zeros(H-w_size+1, W-w_size+1, K);
        for k = 1:K
            img = squeeze(img_seq_color(:,:,:,k));
            muY_seq(:,:,k) = convn(img,window,'valid');
            lY(k) = mean(img(:));
            muY_sq_seq(:,:,k) = muY_seq(:,:,k) .* muY_seq(:,:,k);
            sigmaY_sq_seq(:,:,k) = convn(img.*img, window, 'valid') - muY_sq_seq(:,:,k);
        end

        [sigmaY_sq, patch_index] = max(sigmaY_sq_seq,[],3);

        muY = zeros(H-w_size+1, W-w_size+1);
        for k = 1:K
            LY(:,:,k) = exp( -((muY_seq(:,:,k)/255-.5).^2)/denom_g - ((lY(k)/255-0.5).^2)/denom_l );
            muY = muY + squeeze(muY_seq(:,:,k)) .* LY(:,:,k);
        end
        muY = muY ./ sum(LY,3);
    else
        for k = 1:K
            img = squeeze(img_seq_color(:,:,:,k));
            muY_seq(:,:,k) = convn(img,window,'valid');
            muY_sq_seq(:,:,k) = muY_seq(:,:,k) .* muY_seq(:,:,k);
            sigmaY_sq_seq(:,:,k) = convn(img.*img, window, 'valid') - muY_sq_seq(:,:,k);
        end

        [sigmaY_sq, patch_index] = max(sigmaY_sq_seq,[],3);

        muY = zeros(H-w_size+1, W-w_size+1);
        for k = 1:K
            index = double(patch_index == k);
            muY = muY + squeeze(muY_seq(:,:,k)) .* index;
        end
    end
    
    muY_sq = muY .* muY;
    
    out_params.patch_index = patch_index;
    out_params.muY = muY;
    out_params.muY_sq = muY_sq;
    out_params.muY_seq = muY_seq;
    out_params.muY_sq_seq = muY_sq_seq;
    out_params.sigmaY_sq = sigmaY_sq;
    out_params.sigmaY_sq_seq = sigmaY_sq_seq;
end