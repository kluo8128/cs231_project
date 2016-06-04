% [inliers, model] = refineMatch(P1, P2, matches)
%
% Returns the set of inliers and corresponding homography that maps matched
% points from P1 to P2.
%
% Adapted from Problem 3 of PS3
function [inliers, model] = refineMatch(P1, P2, matches)
N = length(matches);
X = [P1(2,matches(1,:)); P1(1,matches(1,:)); ones(size(P2(2,matches(2,:))))];
Xp = [P2(2,matches(2,:)); P2(1,matches(2,:)); ones(size(P2(2,matches(2,:))))];

% Parameters
iter = 1000;
pixelThresh = 5;
inliers = zeros(1, length(matches(1,:)));
model = eye(3);

% X is a N x 3 matrix where each row is the homogeneous coordinates of a
% keypoint in image1, while Xp is the corresponding points in image2.

% Main loop, selects a set of 4 random points, calculates homography,
% calculates inliers.
for interation = 1:iter
    % Choose a random set of matches
    perm = randperm(N, 4);
    x = X(:,perm);
    xp = Xp(:,perm);
    
    % Calculate model
    A = [x', zeros(4, 9), x', zeros(4, 9), x'];
    A = reshape(A', 9, [])';
    b = reshape(xp, [], 1);
    h = A \ b;
    H = reshape(h, 3, [])';
    
    % Calculate reprojection error
    error = norms(Xp - H * X);

    % Calculate inliers
    new_inliers = find(error < pixelThresh);
    
    % Keep track of best model
    if sum(inliers) == 0 || size(new_inliers, 2) > size(inliers, 2)
        inliers = new_inliers;
        model = H;
    end
    
end
end
