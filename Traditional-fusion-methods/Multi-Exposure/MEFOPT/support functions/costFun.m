function [cost, grad, qmap] = costFun(x,params)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The function calculate the MEF-SSIM index, its gradient and its quality map                   %
%   input:  1. x: vectorized image                                                              %
%           2. img_seq_color: colored image                                                     %
%           3. D1                                                                               %
%           4. D2                                                                               %
%           5. window: sliding window (default 8x8 average window)                              %
%           6. muY: selected patch means                                                        %
%           7. muY_sq: selected patch mean square                                               %
%           8. muY_seq: means of each input image                                               %
%           9. muY_sq_seq: mean square of each input image                                      %
%           10. sigmaY_sq: sigma square of the selected patch                                   %
%           11. sigmaY_sq_seq: sigma square of each input image                                 %
%           12. adaptive_lum: whether to enable adaptive luminance                              %
%                                                                                               %
%   output struct:                                                                              %
%           1. cost: MEF-SSIM index                                                             %
%           2. grad: MEF-SSIM gradient                                                          %
%           3. qmap: MEF-SSIM quality map                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % image vectors
    x = double(x); 
    img_seq_color = double(params.img_seq_color);
    
    D1 = params.D1;
    D2 = params.D2;
    window = params.window;

    muY_seq = params.muY_seq;
    muY_sq_seq = params.muY_sq_seq;
    patch_index = params.patch_index;
    sigmaY_sq = params.sigmaY_sq;
    sigmaY_sq_seq = params.sigmaY_sq_seq;
    adaptive_lum = params.adaptive_lum;
    
    % dimension
    [M, N, C, K] = size(img_seq_color);
    w_size = size(window,1);
    
    image = reshape(x,M,N,C);
    
    %----------------------------------------------------------------
    C1 = (D1*255)^2;
    C2 = (D2*255)^2;
    Nw = w_size * w_size * C;
    
    muY = params.muY;
    muY_sq = params.muY_sq;
    [H, W] = size(muY);
    
    muX = convn(image, window, 'valid');
    muX_sq = muX.*muX;
    sigmaX_sq = convn(image.*image, window, 'valid') - muX_sq;
    
    A1_patches = 2 * muX .* muY + C1;
    B1_patches = muX_sq + muY_sq + C1;
    B2_patches = sigmaX_sq + sigmaY_sq + C2;
    B1B2_patches = B1_patches .* B2_patches;
    B1B2_sq_patches = B1B2_patches .* B1B2_patches;
    
    qmap_int = zeros(H, W, K);
    sigmaXY = zeros(H, W, K);
    qmap = zeros(H, W);
    if (adaptive_lum ~=0 )
        for k = 1:K
            sigmaXY(:,:,k) = convn(image.*squeeze(img_seq_color(:,:,:,k)), window, 'valid') - muX .* muY_seq(:,:,k);
            qmap_int(:,:,k) = (2 * muX .* muY + C1) .* ( 2 * sigmaXY(:,:,k) + C2 ) ./ ...
                              ( (muX_sq + muY_sq + C1) .* (sigmaX_sq + sigmaY_sq_seq(:,:,k) + C2) );
        end
    else
        for k = 1:K
            sigmaXY(:,:,k) = convn(image.*squeeze(img_seq_color(:,:,:,k)), window, 'valid') - muX .* muY_seq(:,:,k);
            qmap_int(:,:,k) = (2 * muX .* muY_seq(:,:,k) + C1) .* ( 2 * sigmaXY(:,:,k) + C2 ) ./ ...
                              ( (muX_sq + muY_sq_seq(:,:,k) + C1) .* (sigmaX_sq + sigmaY_sq_seq(:,:,k) + C2) );
        end
    end

    
    for k = 1:K
        index = (patch_index == k);
        qmap = qmap + qmap_int(:,:,k) .* double(index);
    end
    
    %----------------------------------------------------------------
    cost = mean2(qmap);
    %----------------------------------------------------------------
    % calculate MEF-SSIM gradient
    if nargout > 1
        grad_mat = zeros(M,N,C);
        for i=1:M-w_size+1
           for j=1:N-w_size+1
              X = image(i:i+w_size-1, j:j+w_size-1,:);
              Y = img_seq_color(i:i+w_size-1, j:j+w_size-1, :, patch_index(i,j));
              
              A1 = A1_patches(i,j);
              A1p = 2 * muY(i,j) * ones(w_size, w_size, C) / Nw;
              B1 = B1_patches(i,j);
              B1p = 2 * muX(i,j) * ones(w_size, w_size, C) / Nw;
              A2 = 2 * sigmaXY(i,j,patch_index(i,j))+ C2;
              A2p = 2 * (Y - muY_seq(i,j,patch_index(i,j))) / Nw;
              B2 = B2_patches(i,j);
              B2p = 2 * (X - muX(i,j)) / Nw;
              %----------- 
              local_score = (A1p * A2 + A1 * A2p) / B1B2_patches(i,j) - (B1p * B2 + B1 * B2p) * A1 * A2 / B1B2_sq_patches(i,j);    
              grad_mat(i:i+w_size-1, j:j+w_size-1, :) = grad_mat(i:i+w_size-1, j:j+w_size-1, :) + local_score; 
           end
        end
        grad = grad_mat(:);
    end
end