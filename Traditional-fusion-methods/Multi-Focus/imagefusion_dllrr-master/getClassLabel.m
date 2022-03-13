function c = getClassLabel(im, num, Th)
    % HOG features
    H = HOG(im, num-1);
    
%     H_re = reshape(H,[6,9]);
%     H_v = sum(H_re');
    H_v = H;
    
    [value_max, position_max] = max(H_v);
    hog_sum = sum(H_v);
    
    if (value_max/hog_sum)>=Th
        c = position_max;
    else
        c = 0;
    end
end