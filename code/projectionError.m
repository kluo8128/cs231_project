% [error] = projectionError(Phi, indices, keypoints, allMatches, numMatches)
%
% Returns the projection error, given the homography values in the vector
% Phi, the keypoints, matching indices, and number of matches. Only
% considers the specified indices when computing the error.
function [error] = projectionError(Phi, indices, keypoints, allMatches, numMatches)
error = 0;
m = length(indices);
% extract homography transformations from Phi
Hs = [reshape(Phi, 8, []); ones(1,m)];
for index_i = 1:m
    i = indices(index_i);
    keypt_i = keypoints{i};
    H_i = reshape(Hs(:,index_i), [], 3); % i->c
    for index_j = index_i + 1:m
        j = indices(index_j);
        if numMatches(i,j) > 0 || numMatches(j,i) > 0
            keypt_j = keypoints{j};
            if i < j
                matches = allMatches{i,j};
            else
                matches = allMatches{j,i};
                matches = [matches(2,:); matches(1,:)];
            end
            %matches = allMatches{i,j};
            H_j = reshape(Hs(:,index_j), [], 3); % j->c
            H = H_i \ H_j; % j->i = (c->i) * (j->c)
            H_inv = H_j \ H_i; % i->j = (c->j) * (i->c)
            
            for k = 1:size(matches,2)
                u_i = [keypt_i(2,matches(1,k)); keypt_i(1,matches(1,k)); 1];
                u_j = [keypt_j(2,matches(2,k)); keypt_j(1,matches(2,k)); 1];
                % Matching error from image j to i
                p_ij = H * u_j;
                r_ij = (u_i(1:2) ./ u_i(3)) - (p_ij(1:2) ./ p_ij(3));
                error = error + norm(r_ij) ^ 2;
                % Matching error from image i to j
                p_ji = H_inv * u_i;
                r_ji = (u_j(1:2) ./ u_j(3)) - (p_ji(1:2) ./ p_ji(3));
                error = error + norm(r_ji) ^ 2;
            end
        end
    end
end
end
