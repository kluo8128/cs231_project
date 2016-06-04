% [tform, status] = getTform(keypoints, allMatches, i, j)
%
% Returns the projective transformation tform matching image i to image j,
% given the corresponding keypoints and matching indices, as well as a
% binary status variable that is 0 if successful, and 1 otherwise.
function [tform, status] = getTform(keypoints, allMatches, i, j)
if i < j
    matches = allMatches{i,j};
else
    matches = allMatches{j,i};
    matches = [matches(2,:); matches(1,:)];
end
keypt_i = keypoints{i};
keypt_j = keypoints{j};
match_keypt_i = keypt_i(:,matches(1,:));
match_keypt_j = keypt_j(:,matches(2,:));
matchPoints_i = [match_keypt_i(2,:); match_keypt_i(1,:)]';
matchPoints_j = [match_keypt_j(2,:); match_keypt_j(1,:)]';

try
    tform = estimateGeometricTransform(matchPoints_i, matchPoints_j, ...
        'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);
    status = 0;
catch exception
    tform = projective2d(eye(3));
    status = 1;
end
end
