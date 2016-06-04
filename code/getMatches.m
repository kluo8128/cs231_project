% [matches] = getMatches(des1, des2)
%
% Given the SIFT feature descriptors of two images, this function returns
% the indices corresponding to the matched keypoints. A match is accepted
% only if its distance is less than distRatio times the distance to the
% second closest match.
%
% Credits: Adapted from SIFT demo code by D. Lowe
function [matches] = getMatches(des1, des2)
n = size(des1, 1);
matches = zeros(1, n);

% For efficiency in Matlab, it is cheaper to compute dot products between
% unit vectors rather than Euclidean distances.  Note that the ratio of 
% angles (acos of dot products of unit vectors) is a close approximation
% to the ratio of Euclidean distances for small angles.
%
% distRatio: Only keep matches in which the ratio of vector angles from the
% nearest to second nearest neighbor is less than distRatio.
distRatio = 0.6;   

% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
for i = 1 : n
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals, indx] = sort(acos(dotprods)); % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if vals(1) < distRatio * vals(2)
      matches(i) = indx(1);
   else
      matches(i) = 0;
   end
end

% Convert to the indices corresponding to the matched keypoints
indices = find(matches > 0);
matches = [indices; matches(indices)];
num = size(matches, 2);
fprintf('Found %d matches.\n', num);
end
