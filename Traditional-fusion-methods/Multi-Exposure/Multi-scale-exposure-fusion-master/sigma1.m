function S1 = sigma1(gradientX,gradientY)
% formula (12)
% note !! we use intermediate image's gradient here
if abs(gradientX) > abs(gradientY)
    S1 = gradientX;
else
    S1 = gradientY;
end
end