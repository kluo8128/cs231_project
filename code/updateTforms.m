% [tforms] = updateTforms(G, i, visited, keypoints, allMatches, tforms)
%
% Updates and returns the projective transformations for each image j that
% shares an edge with image i in the tree with adjacency matrix G, given
% the corresponding keypoints and matching indices. Recursively updates
% the tforms of the neighbors of each image j.
function [tforms] = updateTforms(G, i, visited, keypoints, allMatches, tforms)
    n = size(G, 1);
    visited(i) = 1;
    for j = 1:n
        if G(i,j) > 0 && ~visited(j)            
            if i < j
                tform = getTform(keypoints, allMatches, i, j); % i->j
                tform = invert(tform); % j->i
            else
                tform = getTform(keypoints, allMatches, j, i); % j->i
            end
            tform.T = tform.T * tforms(i).T;
            tforms(j).T = tform.T ./ tform.T(3,3);
            [tforms] = updateTforms(G, j, visited, keypoints, allMatches, tforms);
        end
    end
end
