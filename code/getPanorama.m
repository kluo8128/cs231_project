% [height, width] = getPanoramaSize(images, tforms, ccs, cc)
%
% Creates and returns the panorama from applying projective transformations
% on the images in the connected component with index cc.
%
% Credits: Adapted from online MATLAB example "Feature Based Panoramic
% Image Stitching" at
% http://www.mathworks.com/examples/matlab-computer-vision/mw/vision_product-FeatureBasedPanoramicImageStitchingExample-feature-based-panoramic-image-stitching
function [panorama] = getPanorama(images, tforms, ccs, cc)
n = length(tforms);
% If the total area is too large, rescale the images to be smaller
[height, width] = getPanoramaSize(images, tforms, ccs, cc);
area = height * width;
maxArea = 3e6;
if area > maxArea
    f = sqrt(area / maxArea);
    S_inv = inv(diag([f; f; 1]));
    for i = 1:n
        tforms(i).T = tforms(i).T * S_inv;
    end
end

xlim = zeros(n,2);
ylim = zeros(n,2);
hMax = 0;
wMax = 0;
indices = find(ccs == cc);
for index = 1:length(indices)
    i = indices(index);
    h = size(images{i}, 1);
    w = size(images{i}, 2);
    hMax = max(h, hMax);
    wMax = max(w, wMax);
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1, w], [1, h]);
end
% Find the minimum and maximum output limits
xMin = min(xlim(indices,1));
xMax = max(xlim(indices,2));
yMin = min(ylim(indices,1));
yMax = max(ylim(indices,2));
% Width and height of panorama
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin, xMax];
yLimits = [yMin, yMax];
panoramaView = imref2d([height, width], xLimits, yLimits);

% Apply multi-band blending
k = length(indices);
warpedImages = cell(k, 1);
warpedWeights = cell(k, 1);
for index = 1:k
    i = indices(index);
    warpedImage = imwarp(images{i}, tforms(i), 'OutputView', panoramaView);
    warpedImages{index} = warpedImage;
    weight = getWeight(size(images{i}));
    warpedWeight = imwarp(weight, tforms(i), 'OutputView', panoramaView);
    warpedWeights{index} = warpedWeight;
end
panorama = getMultiBand(warpedImages, warpedWeights);
end
