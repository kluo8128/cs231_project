% [weight] = getWeight(size)
%
% Given the size of an RGB image, returns a weight matrix with the same
% dimensions, w(x, y) = w(x) * w(y), where w(x) and w(y) vary linearly from
% 1 at the center of the image to 0 at the edges.
function [weight] = getWeight(size)
h = size(1);
w = size(2);
c = size(3);
wx = ones(1, w);
wx(1:ceil(w/2)) = linspace(0, 1, ceil(w/2));
wx(floor(w/2 + 1):w) = linspace(1, 0, w - floor(w/2));
wx = repmat(wx, h, 1, c);
wy = ones(h, 1);
wy(1:ceil(h/2)) = linspace(0, 1, ceil(h/2));
wy(floor(h/2 + 1):h) = linspace(1, 0, h - floor(h/2));
wy = repmat(wy, 1, w, c);
weight = wx .* wy;
end
