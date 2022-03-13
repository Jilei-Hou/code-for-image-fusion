clear all;close all;clc;

%static fusion
I=load_images('images\garage\',1);   
F=DSIFT_fusion(I,16,2,1);
figure,imshow(F);

%dynamic fusion
I=load_images('images\ForrestSequence\',1);
F=DSIFT_fusion(I,16,1,2);
figure,imshow(F);

%flash and no-flash
I=load_images('images\flash\',1);
F=DSIFT_fusion(I,16,2,1);
figure,imshow(F);
















