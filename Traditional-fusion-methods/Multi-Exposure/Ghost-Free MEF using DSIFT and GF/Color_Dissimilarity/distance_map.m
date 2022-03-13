function [ D ] = distance_map(I_eq,map,w,n1,n2)
%DISTANCE_MAP Summary of this function goes here
%   Detailed explanation goes here
[r c M N]=size(I_eq);
map=double(map);
for i=1:N
    dif(:,:,:)=I_eq(:,:,:,i)-map(:,:,:);
    difr=  dif(:,:,1);
    difr= difr/max(difr(:));
    difg=  dif(:,:,2);
    difg= difg/max(difg(:));
    difb=  dif(:,:,3);
    difb= difb/max(difb(:));
    dif=cat(3,difr,difg,difb);
    dif=dif+10^-25;
    sig=0.1;
    dif_r = exp(-1*((dif(:,:,1) - 0)).^2/sig.^2);
    dif_g = exp(-1*((dif(:,:,2) - 0)).^2/sig.^2);
    dif_b = exp(-1*((dif(:,:,3) - 0)).^2/sig.^2);
    Dir(:,:,i)=dif_r.*dif_g.*dif_b;
end
switch w
    case 1
D=Dir;
for i=1:N
se1=strel('disk',n1);
se2=strel('disk',n2);
D(:,:,i)=imdilate(D(:,:,i),se1);
D(:,:,i)=imerode(D(:,:,i),se2);
end
case 2
    D=double(Dir);
end
end