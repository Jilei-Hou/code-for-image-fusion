function[imf] = DDCTIFek(im1,im2,bs,mode)
% DDCT based image fusion with energy
% VPS Naidu, MSDF Lab, CSIR-NAL, March 2014
% Reference: "Hybrid DDCT-PCA base multi sensor image fusion”, 
%       Journal of Optics, Vol. 43, No.1, pp.48-61, March 2014.

[m,n] = size(im1);
for i=1:bs:m
    for j=1:bs:n
        cb1 = im1(i:i+bs-1,j:j+bs-1);
        cb2 = im2(i:i+bs-1,j:j+bs-1);
        CB1 = DDCT(cb1,mode);
        CB2 = DDCT(cb2,mode);
        Ekcb1 = Ek(CB1);
        Ekcb2 = Ek(CB2);
        [mi,nj] = size(CB1);
        for ii=1:mi
            for jj=1:nj
                k=ii-1+jj-1;
                if Ekcb1(k+1)>=Ekcb2(k+1)
                    CBF(ii,jj)=CB1(ii,jj);
                else
                    CBF(ii,jj)=CB2(ii,jj);
                end
            end
        end                        
        CBF(1,1)=0.5*(CB1(1,1)+CB2(1,1));
        cbf = IDDCT(CBF,mode);
        imf(i:i+bs-1,j:j+bs-1)=cbf;
    end
end

function[E] = Ek(I)
% Compute average amplitude

[m,n] = size(I);
M=m+n-1;
for k=1:M
    in=0;
    for i=1:m
        for j=1:n
            kk=i-1+j-1;
            if (k-1)==kk
                in=in+1;
                EE(k,in)=I(i,j);
            end
        end
    end
end
for k=1:M
    if (k-1)<m
        N=k;
    else
        N=M-k+1;
    end
    E(k)=mean(abs(EE(k,:)));
end