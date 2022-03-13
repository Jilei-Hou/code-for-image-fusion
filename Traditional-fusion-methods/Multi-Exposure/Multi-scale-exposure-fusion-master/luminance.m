% luminance measure
function Y = luminance(I)
N = size(I,4);
Y = zeros(size(I,1),size(I,2),N);
for i = 1:N
    Ycbcr = rgb2ycbcr(I(:,:,:,i));
    Y(:,:,i) = Ycbcr(:,:,1);
end