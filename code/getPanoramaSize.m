% [height, width] = getPanoramaSize(images, tforms, ccs, cc)
%
% Returns the size of the panorama from applying projective transformations
% on the images in the connected component with index cc.
%
% Credits: Adapted from online MATLAB example "Feature Based Panoramic
% Image Stitching" at
% http://www.mathworks.com/examples/matlab-computer-vision/mw/vision_product-FeatureBasedPanoramicImageStitchingExample-feature-based-panoramic-image-stitching
function [height, width] = getPanoramaSize(images, tforms, ccs, cc)
n = length(tforms);
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
width = round(xMax - xMin);
height = round(yMax - yMin);
end
