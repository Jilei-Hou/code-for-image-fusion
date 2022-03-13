function [IP]= ILP(Pyr, a)
% This function does the inverse construction of the laplacian pyramid Pyr with the parameter a used for the gaussian kernel.
    [~, LvlMax]=size(Pyr.G);
    for i=LvlMax-1:-1:1
        clc;
        disp(['Collapse pyramid at level : ', num2str(i)]);
        Pyr.G{i}=Expand(Pyr.G{i+1}, a)+Pyr.L{i};
        Pyr.G{i+1}={};
    end
    IP=Pyr;
end
