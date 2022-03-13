function fusion_map = refine_withoutmatching(img1,img2,initMap1,initMap2)

[h,w]=size(img1);

fusion_map=1*initMap1+0.5*(1-initMap1-initMap2);
r=3;
for j=1:h
    for i=1:w
        if fusion_map(j,i)==0.5 && j>r && j<h-r+1 && i>r && i<w-r+1
            fm1=SF(img1(j-r:j+r,i-r:i+r));
            fm2=SF(img2(j-r:j+r,i-r:i+r));
            if fm1>fm2
                fusion_map(j,i)=1;
            else
                fusion_map(j,i)=0;
            end               
        end
    end
end

