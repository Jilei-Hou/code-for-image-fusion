function [InfocusMaps] = In_focus_Maps(IBW, sigma, threshold_for_quantile, se_size)
% This function computes a map of the in-focus pixel for each image IBW by weighing the gaussian gradient of each image with the
% sum of the gaussian gradients, by doing a threshold of the weighs with the quantile and by dilating the threshold.
    
    [H, W, nbframe]=size(IBW); %size of the images

    %% Generating edges maps
    clc; disp('Generate Edges Maps');
    EdgesMaps=GoGFilter(IBW, sigma);
    WeigtingEdgesMaps=EdgesMaps.^2./repmat(sum(EdgesMaps.^2, 3), [1, 1, nbframe]);
    clear EdgesMaps;

    %% Generating binary maps with the quantile 
    BinaryMasks=zeros(H, W, nbframe, 'logical');
    for i=1:nbframe
        clc;
        disp(['Generating Binary Maps ', num2str(i), '/', num2str(nbframe)])
        threshold=quantile(sort(reshape(WeighingEdgesMaps(:,:,i), [1, H*W])), threshold_for_quantile);
        BinaryMasks(:,:,i)=WeighingEdgesMaps(:,:,i)>threshold;
    end
    clear WeighingEdgesMaps;

    %% Removing Island if necessary
    %BinaryMasks=RemoveIslands(BinaryMasks, 1, 4);

    %% Extending the in-focus pixel maps
    clc; disp('Extending In_focus_Maps');
    se=strel('diamond', se_size);   
    InfocusMaps=imdilate(BinaryMasks, se);
end

function [IOut] = RemoveIslands(I, N, P)
% This function allows to remove isolated point which has under P neighbours around the N circle of pixels surrounding it from
% the binary mask.
    IOut=I;
    [~, ~, nbframe]=size(I);
    for k=1:nbframe
        clc; disp(['Remove Island n°', num2str(k), '/', num2str(nbframe)]);
        [row, col]=find(I(:,:,k));
        NonZeroElts=length(row);
        Padd=padarray(I(:,:,k), [N, N], 'both');
        S=zeros(2*N+1, 2*N+1, NonZeroElts);
        for l=1:NonZeroElts
            S(:,:,l)=Padd(row(l):row(l)+2*N, col(l):col(l)+2*N);
        end
        temp=squeeze(sum(sum(S)));
        idx=find(temp<=P);
        if(~isempty(idx))
            for l=1:max(size(idx))
                IOut(row(idx(l)), col(idx(l)), k)=0;
            end
        end
    end
end
