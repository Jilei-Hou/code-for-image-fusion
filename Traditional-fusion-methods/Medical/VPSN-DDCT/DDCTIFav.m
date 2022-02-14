function[imf] = DDCTIFav(im1,im2,bs,mode)
% DDCT based image fusion by averaging
% VPS Naidu, MSDF Lab, CSIR-NAL, March 2014
% Reference: "Hybrid DDCT-PCA base multi sensor image fusion? 
%       Journal of Optics, Vol. 43, No.1, pp.48-61, March 2014.

[m,n] = size(im1);
for i=1:bs:floor(m/bs)*bs
    for j=1:bs:floor(n/bs)*bs
        cb1 = im1(i:i+bs-1,j:j+bs-1);
        cb2 = im2(i:i+bs-1,j:j+bs-1);
        CB1 = DDCT(cb1,mode);
        CB2 = DDCT(cb2,mode);
        CBF = 0.5*(CB1+CB2);
        CBF(1,1)=0.5*(CB1(1,1)+CB2(1,1));
        cbf = IDDCT(CBF,mode);
        imf(i:i+bs-1,j:j+bs-1)=cbf;
    end
end