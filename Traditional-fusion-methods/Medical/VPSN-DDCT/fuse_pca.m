function[imf] = fuse_pca(im0,im1,im3,im4,im5,im6,im7,im8)
% PCA based image fusion
% VPS Naidu, MSDF Lab, CSIR-NAL, March 2014
% Reference: "Hybrid DDCT-PCA base multi sensor image fusion”, 
%       Journal of Optics, Vol. 43, No.1, pp.48-61, March 2014.

% compute, select & normalize eigenvalues 
[V, D] = eig(cov([im0(:) im1(:) im3(:) im4(:) im5(:) im6(:) im7(:) im8(:)]));
[max,ind] = sort(diag(D),'descend');
a = V(:,ind(1))./sum(V(:,ind(1)));
% fuse
imf = a(1)*im0 + a(2)*im1 + a(3)*im3 + a(4)*im4 + a(5)*im5 + a(6)*im6 + a(7)*im7 + a(8)*im8;