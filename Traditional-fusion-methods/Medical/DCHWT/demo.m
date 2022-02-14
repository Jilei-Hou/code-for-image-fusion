clear all
clc

path='C:\Users\HJL\Desktop\medical';
%%% Fusion Method Parameters.
detail_exponent=1; %%% Fusion Method2 (SIViP 2011), db8-> detail_exponent=1;
Nlevels=3;
NoOfBands=3*Nlevels+1;
wname='DCHWT'; %% DCHWT coif5 db16 db8 sym8 bior6.8

num=1:34;
for n=1:length(num)
    k=num(n)
    im1 = im2double(imread(strcat(path,'/Test_far/',num2str(k),'.png')));
    im2 = im2double(imread(strcat(path,'/Test_near_RGB/',num2str(k),'.png')));
    im2_ihs=rgb2ihs(im2);
    i=im2_ihs(:,:,1);
    v1=im2_ihs(:,:,2);
    v2=im2_ihs(:,:,3);
    
    I=imresize(i,size(i)*1);
    V1=imresize(v1,size(v1)*1);
    V2=imresize(v2,size(v2)*1);
    
%     figure(1);
%     subplot(131);imshow(im1);
%     subplot(132);imshow(I);
    
    tic
    x{1}=im1;
    x{2}=I;
    [M,N]=size(x{2});
    
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
         F_I=dchwt_fn2(yw,-Nlevels);
    else
        %%% General Wavelet Reconstruction.
        k=NoOfBands;
        xrtemp=reshape(yw{k},1,S(1,1)*S(1,2));
        k=k-1;
        for i=2:size(S,1)-1
            xrtemp=[xrtemp reshape(yw{k-1},1,S(i,1)*S(i,2)) reshape(yw{k},1,S(i,1)*S(i,2)) reshape(yw{k-2},1,S(i,1)*S(i,2))];
            k=k-3;
        end
        F_I=waverec2(xrtemp,S,wname);
    end
    
    time(n)=toc
    F_IHS=cat(3,F_I,V1,V2);
    F=ihs2rgb(F_IHS);
    imwrite(F,strcat('C:\Users\HJL\Desktop\medical\resul2\',num2str(k),'.png'));
end