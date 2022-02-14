function[d] = IDDCT(IM,mode)
%compute different IDDCT modes
% VPS Naidu, MSDF Lab, CSIR-NAL, March 2014
% Reference: "Hybrid DDCT-PCA base multi sensor image fusion”, 
%       Journal of Optics, Vol. 43, No.1, pp.48-61, March 2014.

if mode ==0
    d= IDDCTmode0(IM);
elseif mode==1
    d= IDDCTmode0(IM)';
elseif mode==3
    d= IDDCTmode3(IM);
elseif mode==4
    dd=IDDCTmode3(IM);
    d = fliplr(dd);
elseif mode==5
   d= IDDCTmode5(IM);
elseif mode==6
    d= IDDCTmode5(IM);
    d = fliplr(d);
elseif mode==7
    d= IDDCTmode5(IM);
    d = d';
elseif mode==8
    d= IDDCTmode5(IM);
    d = fliplr(d)';
else
    disp('Mode request is not correct, it should be 0 to 8 except 2');
end


function[d] = IDDCTmode0(D)
   [M,N] = size(D);
   dd=zeros(M,N);
   i=1:N;
   dd(i,:) = idct(D(i,:));
   d(:,i) = idct(dd(i,:));


function[im]= IDDCTmode3(D)
[M,N] = size(D);
Nk = [1:M M-1:-1:1];
dd=[];
for i=1:M
    xx = D(i,1:N-2*(i-1));
    dd(i,i:N-i+1)=idct(xx,length(xx));
end

id=[];
for i=1:N
    x=dd(1:Nk(i),i);
    d(1:Nk(i),i) = idct(x,length(x));
end

im=[];
k=1:2*M-1;

for y=1:length(k)
    z=1;
    for i=1:M
        for j=1:M
            if k(y)==i+j-1
                im(i,j)=d(z,y);
                z=z+1;
            end
        end
    end
end        


function[d] = IDDCTmode5(D)
[M,N] = size(D);
    N = N-1;
    Mh = M/2; Nh = (N-1)/2;
    DD = zeros(M,N+1);
    for i=1:M
        if i<=Mh
            DD(i,1:N+1)= idct(D(i,1:N+1));
        else
            DD(i,2:N)= idct(D(i,1:N-1));
        end
    end
    
    for i=1:N+1
        if i==1
            dd(1:Mh,1) = idct(DD(1:Mh,1));
        elseif i==N+1
            dd(1:Mh,N+1) = idct(DD(1:Mh,N+1));
        else
            dd(1:M,i) = idct(DD(1:M,i));
        end
    end
    
    du(1:Mh,N) = dd(1:Mh,N+1);
    dl(1:Mh,1) = dd(1:Mh,1);
    dl(1:Mh,2:N) = dd(Mh+1:M,2:N);
    du(1:Mh,1:N-1) = dd(1:Mh,2:N);
    d(Mh+1:M,:) = dl;
    d(1:Mh,:) = du;