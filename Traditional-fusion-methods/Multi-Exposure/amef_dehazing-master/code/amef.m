function R = amef(I_hazy, clip_range)
I_hazy = im2double(I_hazy);
I = zeros(size(I_hazy,1),size(I_hazy,2),size(I_hazy,3),6);

I(:,:,:,1) = I_hazy;
range = linspace(1,6,6);
for i=2:5
    gamma = range(i);
    for c=1:3
        I(:,:,c,i) = I_hazy(:,:,c).^gamma;
    end
end


for c=1:3
    I(:,:,c,6) = adapthisteq(I_hazy(:,:,c),'clipLimit',clip_range);
end


R = exposure_fusion(I);

end



function R = exposure_fusion(I)
% Simplification of the implementation of Exposure Fusion
% written by Tom Mertens, Hasselt University, August 2007
% If you are interested only in the image fusion part, 
% please refer to:

% and cite Merten's work if appropriate:
%   "Exposure Fusion"
%   Tom Mertens, Jan Kautz and Frank Van Reeth
%   In Proceedings of Pacific Graphics 2007

r = size(I,1);
c = size(I,2);
N = size(I,4);

%combine contrast and saturation into a weight map
W = ones(r,c,N).*contrast(I).*saturation(I);

% normalize weights:
% weights need to sum to one for each pixel
% avoids division by zero
W = W + 1e-12;
W = W./repmat(sum(W,3),[1 1 N]);

% create empty pyramid
pyr = gaussian_pyramid(zeros(r,c,3));
nlev = length(pyr);

% multiresolution blending
for i = 1:N
    % construct pyramid from each input image
    pyrW = gaussian_pyramid(W(:,:,i));
    pyrI = laplacian_pyramid(I(:,:,:,i));
    
    % blend
    for l = 1:nlev
        w = repmat(pyrW{l},[1 1 3]);
        pyr{l} = pyr{l} + w.*pyrI{l};
    end
end

% reconstruct
R = reconstruct_laplacian_pyramid(pyr);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% contrast measure
function C = contrast(I)
h = [0 1 0; 1 -4 1; 0 1 0]; % laplacian filter
N = size(I,4);
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    mono = rgb2gray(I(:,:,:,i));
    C(:,:,i) = abs(imfilter(mono,h,'replicate'));
end
end
% saturation measure
function C = saturation(I)
N = size(I,4);
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    % saturation is computed as the standard deviation of the color channels
    R = I(:,:,1,i);
    G = I(:,:,2,i);
    B = I(:,:,3,i);
    mu = (R + G + B)/3;
    C(:,:,i) = sqrt(((R - mu).^2 + (G - mu).^2 + (B - mu).^2)/3);
end
end
