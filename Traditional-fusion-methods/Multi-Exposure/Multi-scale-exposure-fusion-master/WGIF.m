function q = WGIF(I, p, r, eps)
%   GUIDEDFILTER   O(1) time implementation of guided filter.
%
%   - guidance image: I (should be a gray-scale/single channel image)
%   - filtering input image: p (should be a gray-scale/single channel image)
%   - local window radius: r
%   - regularization parameter: eps

[hei, wid] = size(I);
%N=(2*r+1)^2
N = boxfilter(ones(hei, wid), r); % the size of each local patch; N=(2r+1)^2 except for boundary pixels.

mean_I = boxfilter(I, r) ./ N;
mean_p = boxfilter(p, r) ./ N;
mean_Ip = boxfilter(I.*p, r) ./ N;
cov_Ip = mean_Ip - mean_I .* mean_p; % this is the covariance of (I, p) in each local patch.

mean_II = boxfilter(I.*I, r) ./ N;
var_I = mean_II - mean_I .* mean_I;


% weight coefficient
sigma = zeros(hei,wid);
denomin = 0;
eps2 = 0.001*256*256;
for i = 1:hei
    for j = 1:wid
        denomin = denomin + (1/(var_I(i,j)+eps2));
    end
end
for i = 1:hei
    for j = 1:wid
        sigma(i,j) = (var_I(i,j)+eps2) * (denomin) / (hei*wid);
    end
end

a = cov_Ip ./ (var_I + (eps./sigma)); % Eqn. (5) in the paper;
b = mean_p - a .* mean_I; % Eqn. (6) in the paper;

mean_a = boxfilter(a, r) ./ N;
mean_b = boxfilter(b, r) ./ N;

q = mean_a .* I + mean_b; % Eqn. (8) in the paper;
end