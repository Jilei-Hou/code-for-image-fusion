function F = DSIFT_Fusion(A,B,scale,blocksize,matching)

img1=double(A);
img2=double(B);

if size(A,3)>1
    img1_gray=double(rgb2gray(A));
    img2_gray=double(rgb2gray(B));
else
    img1_gray=img1;
    img2_gray=img2;
end

ext_img1=img_extend(img1_gray,scale/4-1);
ext_img2=img_extend(img2_gray,scale/4-1);
dsift1 = DenseSIFT(ext_img1, scale/2, 1);
dsift2 = DenseSIFT(ext_img2, scale/2, 1);

[initMap1,initMap2] = generate_initmap(dsift1,dsift2,blocksize);

if matching==1
    norm_dsift1=DSIFTNormalization(dsift1);
    clear dsift1;
    norm_dsift2=DSIFTNormalization(dsift2);
    clear dsift2;
    finalMap = refine_withmatching(img1_gray,img2_gray,initMap1,initMap2,norm_dsift1,norm_dsift2);
else
    finalMap = refine_withoutmatching(img1_gray,img2_gray,initMap1,initMap2);
end

if size(A,3)>1
    finalMap=repmat(finalMap,[1 1 3]); 
end

imgf=img1.*finalMap+img2.*(1-finalMap); 
F=uint8(imgf);