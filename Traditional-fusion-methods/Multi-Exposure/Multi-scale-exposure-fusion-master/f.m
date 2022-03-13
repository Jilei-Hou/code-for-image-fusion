function z = f(Y)
if Y <= 128
    z = Y+1;
else
    z = 257-Y;
end
end