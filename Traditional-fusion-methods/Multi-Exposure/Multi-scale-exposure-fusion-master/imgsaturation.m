% saturation measure
function C = imgsaturation(I)
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