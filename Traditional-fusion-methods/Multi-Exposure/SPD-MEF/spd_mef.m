function fI = spd_mef(imgSeqColor, varargin)
% ========================================================================
% Structural patch decomposition based multi-exposure image fusion (SPD-MEF)
% algorithm Version 1.0
% Copyright(c) 2016 Kede Ma, Hui Li, Hongwei Yong, Zhou Wang, Deyu Meng
% and Lei Zhang
% All Rights Reserved.
%
% ----------------------------------------------------------------------
% Permission to use, copy, or modify this software and its documentation
% for educational and research purposes only and without fee is hereby
% granted, provided that this copyright notice and the original authors'
% names appear on all copies and supporting documentation. This program
% shall not be used, rewritten, or adapted as the basis of a commercial
% software or hardware product without first obtaining permission of the
% authors. The authors make no representations about the suitability of
% this software for any purpose. It is provided "as is" without express
% or implied warranty.
%----------------------------------------------------------------------
% This is an implementation of SPD-MEF for producing ghost-free fused 
% images.
% Please refer to the following paper:
%
% K. Ma et al., "Robust Multi-Exposure Image Fusion:
% A Structural Patch Decomposition Approach" submitted to 
% IEEE Transactions on Image Processing.
%
%
% Kindly report any suggestions or corrections to k29ma@uwaterloo.ca
%
%----------------------------------------------------------------------
%
% Required Input : (1) imgSeqColor: source image sequence in [0-1] RGB.
% Optional Input : (2) p: the exponent parameter.  default value p = 4;
%                  (3) gSig: the spread of the global Gaussian. 
%                      defualt value: gSig = 0.2;
%                  (4) lSig: the spread of the local Gaussian. 
%                      defualt value: lSig = 0.5;
%                  (5) wSize: the patch size. defualt value: wSize = 21;
%                  (6) stepSize: the stride. 
%                      defualt value: stepSize = floor(wSize/10) = 2;
%                  (7) exposureThres: the exposure threshold to determine
%                      under- and over-exposed patches. defualt value:
%                      exposureThres = 0.01;
%                  (8) consistencyThres: the IMF threshold. defualt value:
%                      consistencyThres = 0.1 
%                  (9) structureThres: the structure consistency threshold.
%                      defualt value: structureThres = 0.8;
% Output:          (1) fI: The fused image.
%
% Basic Usage:
%   Given the input source image sequence imgColorSeq
%
%   fI = spd_mef(imgColorSeq);
%
% Advanced Usage:
%   
% fI = spd_mef(imgColorSeq, 'wSize', 25, 'consistencyThres', 0.07);
% 
%========================================================================
% input params parsing
    params = inputParser;
    
    default_p = 4;
    default_gSig = 0.2;
    default_lSig = 0.5;
    default_wSize = 21;
    default_stepSize = 2;
    default_exposureThres = 0.01;
    default_consistencyThres = 0.1;
    default_structureThres = 0.8;
    default_C = 0.03 ^ 2 / 2; % inherited from SSIM
    
    addRequired(params,'imgSeqColor');
    addParameter(params, 'p', default_p, @isnumeric);
    addParameter(params, 'gSig', default_gSig, @isnumeric);
    addParameter(params, 'lSig', default_lSig, @isnumeric);
    addParameter(params, 'wSize', default_wSize, @isnumeric);
    addParameter(params, 'stepSize', default_stepSize, @isnumeric);
    addParameter(params, 'exposureThres', default_exposureThres, @isnumeric);
    addParameter(params, 'consistencyThres', default_consistencyThres, @isnumeric);
    addParameter(params, 'structureThres', default_structureThres, @isnumeric);
    addParameter(params, 'C', default_C, @isnumeric);
    
    parse(params, imgSeqColor, varargin{:});
    
% initialization 
    p = params.Results.p;
    gSig = params.Results.gSig;
    lSig = params.Results.lSig;
    wSize = params.Results.wSize;
    stepSize = params.Results.stepSize;
    exposureThres = params.Results.exposureThres;
    consistencyThres = params.Results.consistencyThres;
    structureThres = params.Results.structureThres;
    C = params.Results.C;
    
    window = ones(wSize);
    window3D = repmat(window, [1, 1, 3]);
    window = window / sum(window(:));
    window3D = window3D / sum(window3D(:));
    
    imgSeqColor = double(imgSeqColor);
    [s1, s2, s3, s4] = size(imgSeqColor); 
    xIdxMax = s1-wSize+1;
    yIdxMax = s2-wSize+1;
    
    refIdx = selectRef(imgSeqColor);

% generating pseudo exposures
    numExd = 2*s4-1; 
    imgSeqColorExd = zeros(s1, s2, s3, numExd);
    imgSeqColorExd(:,:,:,1:s4) = imgSeqColor;
    clear imgSeqColor;
    count = 0;
    for i = 1 : s4
        if i ~= refIdx
            count = count + 1;
            temp = imhistmatch(imgSeqColorExd(:,:,:,refIdx),...
                imgSeqColorExd(:,:,:,i), 256);
            temp( temp<0 ) = 0;
            temp( temp>1 ) = 1;
            imgSeqColorExd(:,:,:,count+s4) = temp;          
        end
    end
    
    
% computing statistics
    gMu = zeros(xIdxMax, yIdxMax, numExd); % global mean intensity
    for i = 1 : numExd
        img = imgSeqColorExd(:,:,:,i);
        gMu(:,:,i) = ones(xIdxMax, yIdxMax) * mean(img(:));
    end
   
    temp  = zeros(xIdxMax, yIdxMax, s3);
    lMu   = zeros(xIdxMax, yIdxMax, numExd); % local mean intensity
    lMuSq = zeros(xIdxMax, yIdxMax, numExd);
    for i = 1 : numExd
        for j = 1 : s3
            temp(:,:,j) = filter2(window, imgSeqColorExd(:, :, j, i), 'valid');
        end
        lMu(:,:,i) = mean(temp, 3); % (R + G + B) / 3;
        lMuSq(:,:,i) = lMu(:,:,i) .* lMu(:,:,i);
    end
    
    sigmaSq = zeros(xIdxMax, yIdxMax, numExd); % signal strength from variance
    for i = 1 : numExd
        for j = 1 : s3
            temp(:,:,j) = filter2(window, imgSeqColorExd(:, :, j, i).*...
                imgSeqColorExd(:, :, j, i), 'valid') - lMuSq(:,:,i);
        end
        sigmaSq(:,:,i) = mean(temp, 3);   
    end
    sigma = sqrt( max( sigmaSq, 0 ) );
    ed = sigma * sqrt( wSize^2 * s3 ) + 0.001; % signal strengh

% computing structural consistency map  
    sMap = zeros(xIdxMax, yIdxMax, s4, s4); 
    for i = 1 : s4
        for j = i+1 : s4
        crossMu = lMu(:,:,i) .* lMu(:,:,j);
        crossSigma = convn(imgSeqColorExd(:, :, :, i).*imgSeqColorExd(:, :, :, j)...
            , window3D, 'valid') - crossMu;
        sMap(:,:,i,j) = ( crossSigma + C) ./ (sigma(:,:,i).* sigma(:,:,j) + C); % the third term in SSIM
        end
    end
    sMap(sMap < 0) = 0;
    
    sRefMap = squeeze(sMap(:,:,refIdx,:)) + sMap(:,:,:,refIdx);
    sRefMap(:,:,refIdx) = ones(xIdxMax, yIdxMax); % add reference
    sRefMap(sRefMap <= structureThres) = 0;
    sRefMap(sRefMap > structureThres) = 1;
    muIdxMap = lMu(:,:,refIdx) < exposureThres | lMu(:,:,refIdx) > 1 - exposureThres;
    muIdxMap = repmat(muIdxMap, [1, 1, s4]);
    sRefMap(muIdxMap) = 1;
    se = strel('disk',wSize);
    for k = 1 : s4
        sRefMap(:,:,k) = imopen(sRefMap(:,:,k),se);
    end
    clear sMap;

    iRefMap = imfConsistency(lMu(:,:,1:s4), refIdx, consistencyThres); 
    
    cMap = sRefMap.*iRefMap;   

    cMapExd = zeros(xIdxMax, yIdxMax, 2*s4-1);
    cMapExd(:, :, 1:s4) = cMap;
    clear cMap;
    count = 0;
    for i = 1 : s4
        if i ~= refIdx
            count = count + 1;
            cMapExd(:, :, count+s4) = 1 - cMapExd(:,:,i);          
        end
    end
    
% computing weighing map 
    muMap =  exp( -.5 * ( (gMu - .5).^2 /gSig.^2 +  (lMu - .5).^2 /lSig.^2 ) ); % mean intensity weighting map
    muMap = muMap .* cMapExd; 
    normalizer = sum(muMap, 3);
    muMap = muMap ./ repmat(normalizer,[1, 1, numExd]);   

    sMap = ed.^p; % signal structure weighting map
    sMap = sMap .* cMapExd + 0.001;
    normalizer = sum(sMap,3);
    sMap = sMap ./ repmat(normalizer,[1, 1, numExd]);

    maxEd = ed .* cMapExd; %  desired signal strength
    maxEd = max(maxEd, [], 3); 

% computing index matrix for the main loop
    indM = zeros(xIdxMax, yIdxMax, s4);
    indM(:,:,refIdx) = refIdx;
    for i = 1 : s4
        if i < refIdx
            indM(:,:,i) = cMapExd(:, :, i) * i + cMapExd(:, :, i+s4) * (i+s4);
        elseif i > refIdx
            indM(:,:,i) = cMapExd(:, :, i) * i + cMapExd(:, :, i+s4-1) * (i+s4-1);
        end
    end
      
% main loop for spd-mef
    fI = zeros(s1, s2, s3); 
    countMap = zeros(s1, s2, s3); 
    countWindow = ones(wSize, wSize, s3);
    xIdx = 1 : stepSize : xIdxMax;
    xIdx = [xIdx xIdx(end)+1 : xIdxMax];
    yIdx = 1 : stepSize : yIdxMax;
    yIdx = [yIdx yIdx(end)+1 : yIdxMax];

    offset = wSize-1;
    for row = 1 : length(xIdx)
        for col = 1 : length(yIdx)
            i = xIdx(row);
            j = yIdx(col);
            blocks = imgSeqColorExd(i:i+offset, j:j+offset, :, indM(i,j,:));
            rBlock = zeros(wSize, wSize, s3);
            for k = 1 : s4
                rBlock = rBlock  + sMap(i, j, k) * ( blocks(:,:,:,k) - lMu(i, j, k) ) / ed(i, j, k);
            end
            if norm(rBlock(:)) > 0
                rBlock = rBlock / norm(rBlock(:)) * maxEd(i, j);
            end
            rBlock = rBlock + sum( muMap(i, j, :) .* lMu(i, j, :) ); 
            fI(i:i+offset, j:j+offset, :) = fI(i:i+offset, j:j+offset, :) + rBlock;
            countMap(i:i+offset, j:j+offset, :) = countMap(i:i+offset, j:j+offset, :) + countWindow;
        end
    end
    fI = fI ./ countMap;
    fI(fI > 1) = 1;
    fI(fI < 0) = 0;
end


