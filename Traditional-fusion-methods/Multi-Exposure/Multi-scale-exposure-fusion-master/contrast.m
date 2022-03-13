% contrast measure
function C = contrast(I)
h = [0 1 0; 1 -4 1; 0 1 0]; % laplacian filter
N = size(I,4); % we have 3 different exposure images
C = zeros(size(I,1),size(I,2),N);
for i = 1:N
    mono = rgb2gray(I(:,:,:,i));
    C(:,:,i) = abs(imfilter(mono,h,'replicate'));
end