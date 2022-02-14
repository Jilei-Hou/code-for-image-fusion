function[D] = DDCT(im,mode)
%compute different DDCT modes
% VPS Naidu, MSDF Lab, CSIR-NAL, March 2014
% Reference: "Hybrid DDCT-PCA base multi sensor image fusion”, 
%       Journal of Optics, Vol. 43, No.1, pp.48-61, March 2014.

[M,N] = size(im);
Mh=M/2; Nh=N/2;
if mode ==0
    D=DDCTmode0(im);
elseif mode==1
    D=DDCTmode0(im');
elseif mode==3
    D=DDCTmode3(im);
elseif mode==4
    D=DDCTmode3(fliplr(im));
elseif mode==5
    D = DDCTmode5(im);
elseif mode==6
    D=DDCTmode5(fliplr(im));
elseif mode==7
    D = DDCTmode5(im');
elseif mode==8
    D = DDCTmode5(fliplr(im'));
else
    disp('Mode request is not correct, it should be 0 to 8 except 2');
end


function[D] = DDCTmode0(im)
   [M,N]=size(im);
   DD=zeros(M,N);
   i=1:N;
   DD(i,:) = dct(im(:,i));
   D(i,:) = dct(DD(i,:));
 

function[D]=DDCTmode3(im)
% DDCT 
[N,N]=size(im);

k=1:2*N-1;

for y=1:length(k)
    z=1;
    for i=1:N
        for j=1:N
            if k(y)==i+j-1
                d(z,y)=im(i,j);
                z=z+1;
            end
        end
    end
end

Nk = [1:N N-1:-1:1];
DD = [];
for i=1:length(k)
    dd = d(1:Nk(i),i);
    DD(1:Nk(i),i)=dct(dd,Nk(i));
end
D=[];
for i=1:N
    dd = DD(i,i:2*N-i);
    D(i,1:length(dd))=dct(dd,length(dd));
end

function[D] = DDCTmode5(im)
    [M,N]=size(im);
    Mh=M/2; Nh=N/2;
    dd=zeros(M,N+1);
    du=im(1:Mh,:);
    dl=im(Mh+1:M,:);
    dd(1:Mh,2:N) = du(:,1:N-1);
    dd(Mh+1:M,2:N) = dl(:,2:N);
    dd(1:Mh,1)=dl(:,1);
    dd(1:Mh,N+1)=du(:,N);
    
    DD = zeros(size(dd));
    for i=1:N+1
        if i==1
            DD(1:Mh,1) = dct(dd(1:Mh,1));
        elseif i==N+1
            DD(1:Mh,N+1) = dct(dd(1:Mh,N+1));
        else
            DD(1:M,i) = dct(dd(1:M,i));
        end
    end
    
    for i=1:M
        if i<=Mh
            D(i,1:N+1) = dct(DD(i,:));
        else
            D(i,1:N-1) = dct(DD(i,2:N));
        end
    end