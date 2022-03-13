% well-exposedness measure
function C = well_exposedness(I)
sig = .2;
N = size(I,4); % we have 3 different exposure images
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    R = exp(-.5*(I(:,:,1,i) - .5).^2/sig.^2);
    G = exp(-.5*(I(:,:,2,i) - .5).^2/sig.^2);
    B = exp(-.5*(I(:,:,3,i) - .5).^2/sig.^2);
    C(:,:,i) = R.*G.*B;
end