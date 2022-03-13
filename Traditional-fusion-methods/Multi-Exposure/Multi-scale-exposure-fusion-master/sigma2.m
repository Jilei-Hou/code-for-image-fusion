function S2 = sigma2(gradientX,gradientY)
% formula (13)
% note !! we use intermediate image's gradient here
if abs(gradientX) > abs(gradientY)
    S2 = gradientY;
else
    S2 = gradientX;
end
end