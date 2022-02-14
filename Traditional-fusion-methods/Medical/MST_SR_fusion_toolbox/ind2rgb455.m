path='C:\Users\HJL\Desktop\Dual-discriminator\Dataset\Medical';
for k=1:34
%             img1 = imread(strcat(path,'\Test_far\',num2str(k),'.png'));
%             img2 = imread(strcat(path,'\Test_near_RGB_ยาะ๒\1 (',num2str(k),').png'));
            [cdata,cmap] = imread(strcat(path,'\Test_near_RGB_ยาะ๒\1 (',num2str(k),').png'));
            img2 = ind2rgb(cdata,cmap)
            imwrite(img2,strcat('C:\Users\HJL\Desktop\Dual-discriminator\Dataset\Medical\Test_near_RGB\',num2str(k),'.png'));
end