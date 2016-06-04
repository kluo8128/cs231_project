% [imagePlot] = plotImages(images)
%
% Concatenates the input images into one large image and returns it.
function [imagePlot] = plotImages(images)
n = length(images);
% Calculate the total area of the images
area = 0;
for i = 1:length(images)
    h = size(images{i}, 1);
    w = size(images{i}, 2);
    area = area + h * w;
end
% If the total area is too large, rescale the images to be smaller
new_images = images(:);
maxArea = 3e6;
if area > maxArea
    for i = 1:n
        scale = sqrt(maxArea / area);
        new_images{i} = imresize(images{i}, scale);
    end
end
images = new_images;
% Append the images together, with m images per row
m = 8;
h = ceil(n / m);
imagePlot = [];
for index_i = 1:h
    rowPlot = [];
    for index_j = 1:m
        i = (index_i - 1) * m + index_j;
        if i <= n
            if isempty(rowPlot)
                rowPlot = images{i};
            else
                rowPlot = appendImages(rowPlot, images{i}, true);
            end
        else
            break;
        end
    end
    if isempty(imagePlot)
        imagePlot = rowPlot;
    else
        imagePlot = appendImages(imagePlot, rowPlot, false);
    end
end
end
