function [FusPyr] = PyramidFusion(Pyrs, a)
% This function computes the fusion of the pyramids at each level according to the local region energy for all the levels excepting
% the top for which we use a criteria of entropy and standard deviation.

[~, LvlMax]=size(Pyrs.G);
FusPyr=Pyramid(Level, 'Laplacian'); %Retrieve the type of the pyramid

%% Applying the criteria of maximal local region energy
w=Kernel(a);
for lvl=1:LvlMax-1
    clc;
    disp(['Fusing pyramids at lvl ', num2str(lvl)]);
    LocalRegionEnergy=abs(convn(Pyrs.L{lvl}.^2, w, 'same'));
    [~, idx]=max(LocalRegionEnergy, [], 3);
    [r, c, ~]=size(Pyrs.L{lvl});
    N =r*c;
    idx  = [1:N]+(idx(1:N)-1)*N;
    FusPyr.L{lvl} = reshape(Pyrs.L{lvl}(idx), r, c);
end
clear LocalRegionEnergy; 

%% Applying the criteria of maximal entropy and standard deviation
[~, idxE]=max((entropyfilt(Pyrs.G{end})), [], 3);
[~, idxD]=max((stdfilt(Pyrs.G{end})), [], 3);
[r, c, ~]=size(Pyrs.G{end});
N =r*c;
idx  = [1:N]+(idxE(1:N)-1)*N;
GendE= reshape(Pyrs.G{end}(idx), r, c);
idx  = [1:N]+(idxD(1:N)-1)*N;
GendD = reshape(Pyrs.G{end}(idx), r, c);
FusPyr.G{end}=(GendE+GendD)/2;
end
