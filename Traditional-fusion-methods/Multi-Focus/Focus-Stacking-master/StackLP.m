function [LP] = StackLP(I, a)
% This function computes the laplacian pyramid of the image I with the parameter a for the kernel.
    [I, Levels]=PaddZeros(I);
    LP=Pyramid(Levels, 'Laplacian');
    for k=1:Levels
        clc;
        disp(['Pyramids level n°', num2str(k), '/', num2str(Levels)]);
        if(k==1)
            LP.G{1}=I;
        else
            LP.G{k-1}=[];
        end
        LP.G{k+1}=(Reduce(LP.G{k}, a));
        LP.L{k}=LP.G{k}-Expand(LP.G{k+1}, a);
    end
    LP.G{Levels}=[];
end
