function [initMap1,initMap2] = generate_initmap(dsift1,dsift2,blocksize)

s1=sum(dsift1,3);
s2=sum(dsift2,3);

[h,w]=size(s1);
scoreMat1=zeros(h,w);
cntMat=zeros(h,w);
scoreMat2=zeros(h,w);

overlap=blocksize-1;
gridx = 1:blocksize - overlap : w-blocksize+1;
gridy = 1:blocksize - overlap : h-blocksize+1;

for ii = 1:length(gridx)
    for jj = 1:length(gridy)
        xx = gridx(ii);
        yy = gridy(jj);
        
        block1 = s1(yy:yy+blocksize-1, xx:xx+blocksize-1);
        block2 = s2(yy:yy+blocksize-1, xx:xx+blocksize-1);
        
        a=sum(sum(block1));
        b=sum(sum(block2)); 

        if a>b
            score_block1=ones(blocksize,blocksize);
            scoreMat1(yy:yy+blocksize-1, xx:xx+blocksize-1) = scoreMat1(yy:yy+blocksize-1, xx:xx+blocksize-1) + score_block1;    
        end
        
        if b>a
            score_block2=ones(blocksize,blocksize);
            scoreMat2(yy:yy+blocksize-1, xx:xx+blocksize-1) = scoreMat2(yy:yy+blocksize-1, xx:xx+blocksize-1) + score_block2;
        end 
        cntMat(yy:yy+blocksize-1, xx:xx+blocksize-1) = cntMat(yy:yy+blocksize-1, xx:xx+blocksize-1) + 1;
    end
end

idx = (cntMat < 1);
cntMat(idx) = 1;

norm_scoreMat1 = scoreMat1./cntMat;
norm_scoreMat2 = scoreMat2./cntMat;
init_map1=zeros(h,w);
init_map2=zeros(h,w);

k=0.99;
init_map1(norm_scoreMat1>k)=1;
init_map2(norm_scoreMat2>k)=1;
area=3600;
tempMap1=bwareaopen(init_map1,area);
tempMap2=bwareaopen(init_map2,area);

tempMap1_1=1-tempMap1;
tempMap2_1=1-tempMap2;

tempMap1_2=bwareaopen(tempMap1_1,area);
tempMap2_2=bwareaopen(tempMap2_1,area);

initMap1=1-tempMap1_2;
initMap2=1-tempMap2_2;


