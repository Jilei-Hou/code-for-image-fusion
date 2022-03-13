function result = morph_filter(map, N, Iter)
%--------------------------------------------------------------------------    
% morph_filter is a filter to removing the small burs or connecting the
% close neibouring regions.
%
% Implemented by ZhangYu, Image Processing Center, BUAA
%--------------------------------------------------------------------------
% Input:
%     map: input decision map;
%       N: range of the map, which is the number of the source images here;
%    Iter: the Iteration Number of the morph filtering times;
% Output:
%      result: return the filtering result
%--------------------------------------------------------------------------

for ii = 1 : N
    Imap( : , : , ii) = (map == ii);
end

for ii = 1 : Iter
    for jj = 1 : N
        temp = Imap( : , : , jj);
        se = strel('disk', ii + 2);

        temp = imopen(temp, se);
        temp = imclose(temp,se);
        Imap( : , : , jj) = temp;
    end
end

% Equal map
sum_map = sum(Imap, 3);

% non_map = sum_map > 1 | sum_map < 1;
def_map = (sum_map == 1);

Fusion_map = zeros(size(map));
for ii = 1 : N
Fusion_map =  Fusion_map + Imap( : , : , ii) * ii;
end
result = Fusion_map .* def_map;