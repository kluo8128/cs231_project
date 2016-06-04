% plotMatches(images, keypoints, allMatches, i, j)
%
% Plots the matches corresponding to images i and j, given the keypoints
% and matching indices.
%
% Credits: Adapted from SIFT demo code by D. Lowe
function [] = plotMatches(images, keypoints, allMatches, i, j)
im1 = images{i};
im2 = images{j};
loc1 = keypoints{i};
loc2 = keypoints{j};
if i < j
    matches = allMatches{i,j};
else
    matches = allMatches{j,i};
    matches = [matches(2,:); matches(1,:)];
end
im3 = appendImages(im1, im2, true);
% Show a figure with lines joining the accepted matches.
figure('Position', [100, 100, size(im3, 2), size(im3, 1)]);
colormap('gray');
imagesc(im3);
hold on;
cols1 = size(im1, 2);
for i = 1:size(matches, 2)
    line([loc1(2,matches(1,i)) loc2(2,matches(2,i)) + cols1], ...
         [loc1(1,matches(1,i)) loc2(1,matches(2,i))], 'Color', 'c');
end
hold off;

end
