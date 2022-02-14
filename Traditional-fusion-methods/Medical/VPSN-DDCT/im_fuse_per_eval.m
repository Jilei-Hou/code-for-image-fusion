function[RMSE,SF] = im_fuse_per_eval(imt,imf)
% DDCT (Directional Discrete Cosine Transform) based image fusion - demo
% VPS Naidu, MSDF Lab, CSIR-NAL, March 2014
% Reference: "Hybrid DDCT-PCA base multi sensor image fusion”, 
%       Journal of Optics, Vol. 43, No.1, pp.48-61, March 2014.

%% Root mean square error (RMSE)
[m,n] = size(imt);
RMSE = sqrt(sum((imt(:)-imf(:)).^2)/(m*n));

%% spatial frequency criteria SF
[M,N] = size(imf);

RF = 0;
for m=1:M
    for n=2:N
        RF = RF + (imf(m,n)-imf(m,n-1))^2;
    end
end
RF = sqrt(RF/(M*N));

CF = 0;
for n=1:N
    for m=2:M
        CF = CF + (imf(m,n)-imf(m-1,n))^2;
    end
end
CF = sqrt(CF/(M*N));
SF = sqrt(RF^2 + CF^2);
