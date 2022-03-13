function fusion_map = refine_withmatching(img1,img2,initMap1,initMap2,norm_dsift1,norm_dsift2)

[h,w]=size(img1);

fusion_map=1*initMap1+0.5*(1-initMap1-initMap2);

r=3;
r2=3;
for j=1:h
    for i=1:w
        if fusion_map(j,i)==0.5 && j>r && j<h-r+1 && i>r && i<w-r+1 
            v1=norm_dsift1(j,i,:);
            v2=norm_dsift2(j,i,:);
            b1=norm_dsift1(j-r:j+r,i-r:i+r,:);
            b2=norm_dsift2(j-r:j+r,i-r:i+r,:);
            
            d1=b2-repmat(v1,2*r+1,2*r+1);
            d2=b1-repmat(v2,2*r+1,2*r+1);
            
            dis1=sum(d1.*d1,3); 
            dis2=sum(d2.*d2,3);
            
            [miny1, minx1]=find(dis1==min(min(dis1)));
            [miny2, minx2]=find(dis2==min(min(dis2)));
            
            p1_2_y=j-r+miny1-1; 
            p1_2_x=i-r+minx1-1;
            p2_1_y=j-r+miny2-1;
            p2_1_x=i-r+minx2-1;
            p1_2_y=p1_2_y(1);p1_2_x=p1_2_x(1);p2_1_y=p2_1_y(1);p2_1_x=p2_1_x(1);
            
            if p1_2_y>r2 && p1_2_y<h-r2+1 && p1_2_x>r2 && p1_2_x<w-r2+1 && p2_1_y>r2 && p2_1_y<h-r2+1 && p2_1_x>r2 && p2_1_x<w-r2+1
                fm1=SF(img1(j-r2:j+r2,i-r2:i+r2));
                fm1_2=SF(img2(p1_2_y-r2:p1_2_y+r2,p1_2_x-r2:p1_2_x+r2));
                fm2=SF(img2(j-r2:j+r2,i-r2:i+r2));
                fm2_1=SF(img1(p2_1_y-r2:p2_1_y+r2,p2_1_x-r2:p2_1_x+r2));
                if fm1>fm1_2 && fm2<fm2_1
                    fusion_map(j,i)=1;
                end
                if fm1<fm1_2 && fm2>fm2_1
                    fusion_map(j,i)=0;
                end
            end 
        end
    end
end
