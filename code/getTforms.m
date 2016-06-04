% [tforms] = getTforms(G, i, keypoints, allMatches)
%
% Computes and returns the projective transformations for all images in the
% connected component of image i in the tree with adjacency matrix G, given
% the set of keypoints and matching indices. All tforms are calculated with
% respect to image i.
function [tforms] = getTforms(G, i, keypoints, allMatches)
    n = size(G, 1);
    visited = zeros(n, 1);
    tforms(n) = projective2d(eye(3));
    [tforms] = updateTforms(G, i, visited, keypoints, allMatches, tforms);
end
