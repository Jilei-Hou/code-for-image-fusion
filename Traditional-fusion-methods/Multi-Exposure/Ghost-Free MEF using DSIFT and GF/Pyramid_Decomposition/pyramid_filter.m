% This is a 1-dimensional 5-tap low pass filter. It is used as a 2D separable low
% pass filter for constructing Gaussian and Laplacian pyramids.
%
% tom.mertens@gmail.com, August 2007
%

function f = pyramid_filter;
f = [.0625, .25, .375, .25, .0625];
%f = [.125, .1875, .375, .1875, .125];%%%Free Version
%f = [0, .25, .5, .25, 0];