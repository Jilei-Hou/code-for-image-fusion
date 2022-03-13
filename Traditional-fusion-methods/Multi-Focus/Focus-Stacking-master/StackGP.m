function [GP] = StackGP(I, a)
% This function computes the gaussian pyramid of image I with the parameter a for the gaussian-like kernel.
    [I, Levels]=PaddZeros(I);
    GP=Pyramid(Levels, 'Gaussian');
    for k=1:Levels
        clc;
        disp(['Gaussian Pyramids level ', num2str(k), '/', num2str(Levels)]);
        if(k==1)
            GP.G{1}=I;
        else
            GP.G{k}=Reduce(GP.G{k-1}, a);        
        end    
    end
end
