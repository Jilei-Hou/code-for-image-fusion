clear; close all; clc; warning off

%% F = DSIFT_exposure_fusion(I,scale,mode)

%Inputs:
%I - a color multi-exposure image sequence

%scale - scale factor of dense SIFT, the default value is 16

%mode - controls the fusion mode, static fusion if it is set to 1 and dynamic otherwise

%Output: 
%F - the fused image

%% Static Scene
I=load_images('./Images/house');
figure;
no_of_images = size(I,4);
if no_of_images>2
    m = log2(no_of_images);
    for i = 1:no_of_images
        subplot(m,m,i); imshow(I(:,:,:,i));
    end
    suptitle('Static Images as Inputs');
elseif no_of_images == 2
    for i = 1:no_of_images
        subplot(2,1,i); imshow(I(:,:,:,i));
    end
    suptitle('Static Images as Inputs');
else
    return
end
F=DSIFT_exposure_fusion(I,16,0);
figure;
imshow(F);

% Dynamic Scene
I=load_images('./images/arch');
figure;
no_of_images = size(I,4);
if no_of_images>2
    m = ceil(log2(no_of_images));
    for i = 1:no_of_images
        subplot(m,m,i); imshow(I(:,:,:,i));
    end
    suptitle('Dynamic Images as Inputs');
elseif no_of_images == 2
    for i = 1:no_of_images
        subplot(2,1,i); imshow(I(:,:,:,i));
    end
    suptitle('Dynamic Images as Inputs');
else
    return
end
F=DSIFT_exposure_fusion(I,16,1);
figure; imshow(F);

%% Multi-focus Scene
I=load_images('./images/children');
figure;
no_of_images = size(I,4);
if no_of_images>2
    m = ceil(log2(no_of_images));
    for i = 1:no_of_images
        subplot(m,m,i); imshow(I(:,:,:,i));
    end
    suptitle('Multi Focus Images as Inputs');
elseif no_of_images == 2
    for i = 1:no_of_images
        subplot(2,1,i); imshow(I(:,:,:,i));
    end
    suptitle('Multi Focus Images as Inputs');
else
    return
end
F=DSIFT_exposure_fusion(I,16,0);
figure; imshow(F);

%% Flash Image
I=load_images('./images/flash');
figure;
no_of_images = size(I,4);
if no_of_images>2
    m = ceil(log2(no_of_images));
    for i = 1:no_of_images
        subplot(m,m,i); imshow(I(:,:,:,i));
    end
    suptitle('Flash Images as Inputs');
elseif no_of_images == 2
    for i = 1:no_of_images
        subplot(2,1,i); imshow(I(:,:,:,i));
    end
    suptitle('Flash Images as Inputs');
else
    return
end
F=DSIFT_exposure_fusion(I,16,0);
figure; imshow(F);




