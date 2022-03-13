function [IRGB, IBW, H, W, nbframe]=LoadingImg(directory, imgname, nostart, noend, imgext, imgsize)
% This function allows to load the images of a directory starting from nostart to noend and to resize the images if necessary for
% memory.
    nbframe=noend-nostart+1;
    imginfo=imfinfo([directory, imgname, num2str(nostart), imgext]); %lecture of the images' size
    ResizeImg=true;
    if (imgsize~=0 && imgsize~=1)
        H=ceil(imginfo.Height*imgsize); W=ceil(imginfo.Width*imgsize);
    else
        H=(imginfo.Height); W=(imginfo.Width);
        ResizeImg=false;
    end
    %% Allocating space for the images 
    IRGB=zeros(H, W, 3*nbframe, 'uint8');
    IBW=zeros(H, W, nbframe);
    idx=1:3;
    %% Loading images and computing grayed images 
    for i=1:nbframe
        clc;
        disp(['Loading Img n°',num2str(i),'/', num2str(nbframe)]);
        filename=[directory, imgname, num2str(nostart+i-1), imgext];
        if(ResizeImg)
            IRGB(:,:, idx)=imresize(imread(filename), imgsize);
        else
            IRGB(:,:,idx)=imread(filename);
        end
        IBW(:, :, i)=RGB2BW(IRGB(:,:, idx));
        idx=idx+3;
    end
end

function [gray]=  RGB2BW(rgb)
% This function allows to compute the gray version of a single RGB image.
  [~, ~, p]=size(rgb);
  if(p~=3)
    error('It is not a RGB image');
  end
  if(isa(rgb, 'uint8'))
    rgb=im2double(rgb);
  end
  gray=sum(rgb, 3)/3;
end
