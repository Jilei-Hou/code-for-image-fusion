%%% Image Fusion using Wavelets/DCHWT.

%%% Author : B. K. SHREYAMSHA KUMAR 
%%% Created on 12-10-2011.
%%% Updated on 16-11-2011.  dwtmode('per');

close all;
clear all;
clc;

%%% Fusion Method Parameters.
detail_exponent=1; %%% Fusion Method2 (SIViP 2011), db8-> detail_exponent=1;
Nlevels=3;
NoOfBands=3*Nlevels+1;
wname='DCHWT'; %% DCHWT coif5 db16 db8 sym8 bior6.8


arr=['A';'B'];
for m=1:2
   string=arr(m);
   inp_image=strcat('med256',string,'.jpg');
%    inp_image=strcat('disk512',string,'.gif');
%    inp_image=strcat('kayak',string,'.jpg');
%    inp_image=strcat('gun',string,'.gif');

   x{m}=imread(inp_image);
   if(size(x{m},3)==3)
      x{m}=rgb2gray(x{m});
   end
end
[M,N]=size(x{m});

%%% To make square image
if(strncmp(inp_image,'kayak',5))
   x{1}=x{1}(4:M,:);
   x{2}=x{2}(4:M,:);
end
[M,N]=size(x{m});

%%% Wavelet Decomposition.
tic
if(isequal(wname,'DCHWT'))
   %%% Discrete Cosine Harmonic Wavelet Decomposition.
   for m=1:2
      xin=double(x{m});
      CW=dchwt_fn2(xin,Nlevels);
      inp_wt{m}=CW;      
   end
else
   %%% General Wavelet Decomposition.
   for m=1:2
      xin=double(x{m});
      dwtmode('per');
      [C,S]=wavedec2(xin,Nlevels,wname);
      k=NoOfBands;
      CW{k}=reshape(C(1:S(1,1)*S(1,2)),S(1,1),S(1,2));
      k=k-1;
      st_pt=S(1,1)*S(1,2);
      for i=2:size(S,1)-1
          slen=S(i,1)*S(i,2);
          CW{k}=reshape(C(st_pt+slen+1:st_pt+2*slen),S(i,1),S(i,2));     %% Vertical
          CW{k-1}=reshape(C(st_pt+1:st_pt+slen),S(i,1),S(i,2));          %% Horizontal
          CW{k-2}=reshape(C(st_pt+2*slen+1:st_pt+3*slen),S(i,1),S(i,2)); %% Diagonal
          st_pt=st_pt+3*slen;
          k=k-3;
      end
      inp_wt{m}=CW;
   end
end
clear CW

%%% Fusion Method (SIViP 2011)
fuse_im=method2_sivip2011_fn(inp_wt,Nlevels,detail_exponent);

%%% Wavelet Reconstruction.
yw=fuse_im; clear fuse_im
if(isequal(wname,'DCHWT'))
   %%% Discrete Cosine Harmonic Wavelet Reconstruction
   xrcw=uint8(dchwt_fn2(yw,-Nlevels));
else
   %%% General Wavelet Reconstruction.
   k=NoOfBands;
   xrtemp=reshape(yw{k},1,S(1,1)*S(1,2));
   k=k-1;
   for i=2:size(S,1)-1
       xrtemp=[xrtemp reshape(yw{k-1},1,S(i,1)*S(i,2)) reshape(yw{k},1,S(i,1)*S(i,2)) reshape(yw{k-2},1,S(i,1)*S(i,2))];
       k=k-3;
   end
   xrcw=uint8(waverec2(xrtemp,S,wname));
end

toc

clear yw xrtemp C S

if(strncmp(inp_image,'gun',3))
   figure,imagesc(x{1}),colormap gray
   figure,imagesc(x{2}),colormap gray
   figure,imagesc(xrcw),colormap gray
else
    figure,imshow(x{1})
    figure,imshow(x{2})
    figure,imshow(xrcw)
end

% axis([248 434 211 350]) %%% Disk.

fusion_perform_fn(xrcw,x);
