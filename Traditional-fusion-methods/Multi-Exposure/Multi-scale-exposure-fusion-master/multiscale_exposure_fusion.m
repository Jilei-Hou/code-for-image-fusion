function [R,Lu] = multiscale_exposure_fusion(I)
% I: an image set, with 3 images(under/normal/over exposure images)

I_1R = I(:,:,1,1);
I_1G = I(:,:,2,1);
I_1B = I(:,:,3,1);
I_2R = I(:,:,1,2);
I_2G = I(:,:,2,2);
I_2B = I(:,:,3,2);
I_3R = I(:,:,1,3);
I_3G = I(:,:,2,3);
I_3B = I(:,:,3,3);

r = size(I,1);% width of image
c = size(I,2); % columns of image
N = size(I,4); % how many exposure images
m = [1 1 1];
W = ones(r,c,N);

% luminance evaluation
Lu = luminance(I);

%compute the measures and combines them into a weight map
contrast_parm = m(1);
sat_parm = m(2);
wexp_parm = m(3);

if (contrast_parm > 0)
    W = W.*contrast(I).^contrast_parm;
end
if (sat_parm > 0)
    W = W.*imgsaturation(I).^sat_parm;
end
if (wexp_parm > 0)
    W = W.*well_exposedness(I).^wexp_parm;
end

%normalize weights: make sure that weights sum to one for each pixel
W = W + 1e-12; %avoids division by zero
W = W./repmat(sum(W,3),[1 1 N]);

% create empty pyramid
nlev = floor(log(min(r,c)) / log(2)); % numbers of layers
pyr_1R = gaussian_pyramid(zeros(r,c),nlev); 
pyr_2R = gaussian_pyramid(zeros(r,c),nlev); 
pyr_3R = gaussian_pyramid(zeros(r,c),nlev); 
pyr_1G = gaussian_pyramid(zeros(r,c),nlev); 
pyr_2G = gaussian_pyramid(zeros(r,c),nlev); 
pyr_3G = gaussian_pyramid(zeros(r,c),nlev); 
pyr_1B = gaussian_pyramid(zeros(r,c),nlev); 
pyr_2B = gaussian_pyramid(zeros(r,c),nlev); 
pyr_3B = gaussian_pyramid(zeros(r,c),nlev); 
wgifW_1 = gaussian_pyramid(zeros(r,c),nlev); % WGIF weight map pyramid
wgifW_2 = gaussian_pyramid(zeros(r,c),nlev);
wgifW_3 = gaussian_pyramid(zeros(r,c),nlev);

%construct laplacian pyramid of input image
pyrI_1R = laplacian_pyramid(I_1R,nlev); 
pyrI_2R = laplacian_pyramid(I_2R,nlev); 
pyrI_3R = laplacian_pyramid(I_3R,nlev);  
pyrI_1G = laplacian_pyramid(I_1G,nlev); 
pyrI_2G = laplacian_pyramid(I_2G,nlev); 
pyrI_3G = laplacian_pyramid(I_3G,nlev);
pyrI_1B = laplacian_pyramid(I_1B,nlev); 
pyrI_2B = laplacian_pyramid(I_2B,nlev); 
pyrI_3B = laplacian_pyramid(I_3B,nlev);

pyrW_1 = gaussian_pyramid(W(:,:,1),nlev);
pyrW_2 = gaussian_pyramid(W(:,:,2),nlev);
pyrW_3 = gaussian_pyramid(W(:,:,3),nlev);
pyrY_1 = gaussian_pyramid(Lu(:,:,1),nlev);
pyrY_2 = gaussian_pyramid(Lu(:,:,2),nlev);
pyrY_3 = gaussian_pyramid(Lu(:,:,3),nlev);

for k = 1:nlev
    wgifW_1{k} = WGIF(pyrY_1{k},pyrW_1{k},4,1/1024); 
    wgifW_2{k} = WGIF(pyrY_2{k},pyrW_2{k},4,1/1024);
    wgifW_3{k} = WGIF(pyrY_3{k},pyrW_3{k},4,1/1024);
    
    pyr_1R{k} = pyr_1R{k} + wgifW_1{k}.*pyrI_1R{k};
    pyr_1G{k} = pyr_1G{k} + wgifW_1{k}.*pyrI_1G{k};
    pyr_1B{k} = pyr_1B{k} + wgifW_1{k}.*pyrI_1B{k};
    pyr_2R{k} = pyr_2R{k} + wgifW_2{k}.*pyrI_2R{k};
    pyr_2G{k} = pyr_2G{k} + wgifW_2{k}.*pyrI_2G{k};
    pyr_2B{k} = pyr_2B{k} + wgifW_2{k}.*pyrI_2B{k};
    pyr_3R{k} = pyr_3R{k} + wgifW_3{k}.*pyrI_3R{k};
    pyr_3G{k} = pyr_3G{k} + wgifW_3{k}.*pyrI_3G{k};
    pyr_3B{k} = pyr_3B{k} + wgifW_3{k}.*pyrI_3B{k};
     
end

% reconstruct
R = zeros(r,c,3);
pyr_R = cellfun(@plus,pyr_1R,pyr_2R,'Un',0);
pyr_R = cellfun(@plus,pyr_R,pyr_3R,'Un',0);
pyr_G = cellfun(@plus,pyr_1G,pyr_2G,'Un',0);
pyr_G = cellfun(@plus,pyr_G,pyr_3G,'Un',0);
pyr_B = cellfun(@plus,pyr_1B,pyr_2B,'Un',0);
pyr_B = cellfun(@plus,pyr_B,pyr_3B,'Un',0);

R(:,:,1) = reconstruct_laplacian_pyramid(pyr_R);
R(:,:,2) = reconstruct_laplacian_pyramid(pyr_G);
R(:,:,3) = reconstruct_laplacian_pyramid(pyr_B);
end
