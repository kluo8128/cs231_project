% [imagePlot, panoramas] = main(directory)
%
% Example: [imagePlot, panoramas] = main('data46');
function [imagePlot, panoramas] = main(directory)
% Get image filenames
listing = dir(directory);
j = 0;
imageFiles = cell(length(listing) - 2, 1);
for i = 1:length(listing)
    name = listing(i).name;
    if strcmp(name, '.') == 0 && strcmp(name, '..') == 0
        j = j + 1;
        imageFiles{j} = strcat(directory, '/', name);
    end
end

% Extract SIFT features
n = length(imageFiles);
images = cell(n, 1);
keypoints = cell(n, 1);
allDescriptors = cell(n, 1);
for i = 1:n
    imageFile = char(imageFiles(i));
    image = imread(imageFile);
    images{i} = image;
    [image, descriptors, locs] = sift(imageFile);
    keypoints{i} = locs'; % loc is [y, x, scale, orient]
    allDescriptors{i} = descriptors;
end

% Find matches
allMatches = cell(n);
numMatches = zeros(n);
for i = 1:n
    for j = i + 1:n
        [matches] = getMatches(allDescriptors{i}, allDescriptors{j});
        nf = size(matches, 2);
        % Filter matches using RANSAC (model maps keypt i to keypt j)
        if nf >= 4
            [inliers, model] = refineMatch(keypoints{i}, keypoints{j}, matches);
            ni = length(inliers);
            % Verify image matches using probabilistic model
            if ni > 5.9 + 0.22 * nf % accept as correct image match
                allMatches{i,j} = matches(:,inliers);
                numMatches(i,j) = ni;
            end
        end
    end
end

% Find connected components of image matches
[ccs, ccnum] = dfs(numMatches);
[tree] = getMST(numMatches);

% Display input images
imagePlot = plotImages(images);
figure;
imshow(imagePlot);

panoramas = cell(ccnum, 1);
p = 0;
options = optimoptions(@lsqnonlin, 'Algorithm', 'levenberg-marquardt', ...
    'FunctionTolerance', 1e-10, 'StepTolerance', 1e-10);
for cc = 1:ccnum
    indices = find(ccs == cc);
    k = length(indices);
    if k < 2 % Skip if only one image in connected component
        continue;
    end
    % Find the center image of the panorama that minimizes total area
    areas = zeros(k, 1);
    for index = 1:k
        i = indices(index);
        [tforms] = getTforms(tree, i, keypoints, allMatches);
        [height, width] = getPanoramaSize(images, tforms, ccs, cc);
        areas(index) = height * width;
    end
    [~, index] = min(areas);
    center = indices(index);
    [tforms] = getTforms(tree, center, keypoints, allMatches);
    % Get an ordering of the images in the panorama
    ordering = getOrdering(indices, tree);
    % Minimize the sum of squared projection error over all matches
    Hs = zeros(9, k);
    for index = 1:k
        i = indices(index);
        H = tforms(i).T';
        Hs(:,index) = reshape(H, [], 1);
    end
    for c = 2:k
        subordering = ordering(1:c);
        Phi = zeros(9, c);
        for j = 1:c
            Phi(:,j) = Hs(:,subordering(j));
        end
        Phi = reshape(Phi(1:8,:), [], 1); % last entry of each H is 1
        fxn = @(Phi)projectionError(Phi, indices(subordering), ...
            keypoints, allMatches, numMatches);
        Phi = lsqnonlin(fxn, Phi, [], [], options);
        Phi = [reshape(Phi, [], c); ones(1, c)];
        for j = 1:c
            Hs(:,subordering(j)) = Phi(:,j);
        end
    end
    % Update transforrmations
    for index = 1:k
        i = indices(index);
        H = reshape(Hs(:,index), [], 3);
        tforms(i).T = H';
    end
    % Create and display panorama
    panorama = getPanorama(images, tforms, ccs, cc);
    p = p + 1;
    panoramas{p} = panorama;
    figure;
    imshow(panorama);
end
panoramas = panoramas(1:p);

end
