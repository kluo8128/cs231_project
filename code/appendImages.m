% [im] = appendImages(image1, image2)
%
% Returns a new image that appends the two images side-by-side if
% isHorizontal is true, otherwise top-to-bottom.
%
% Credits: Adapted from SIFT demo code by D. Lowe
function [im] = appendImages(image1, image2, isHorizontal)
if isHorizontal
    % Select the image with the fewest rows and fill in enough empty rows
    % to make it the same height as the other image.
    rows1 = size(image1, 1);
    rows2 = size(image2, 1);
    if (rows1 < rows2)
        image1(rows2,:,:) = 0;
    else
        image2(rows1,:,:) = 0;
    end
    % Now append both images side-by-side.
    im = [image1, image2];   
else
    % Select the image with the fewest columns and fill in enough empty
    % columns to make it the same width as the other image.
    cols1 = size(image1, 2);
    cols2 = size(image2, 2);
    if (cols1 < cols2)
        image1(:,cols2,:) = 0;
    else
        image2(:,cols1,:) = 0;
    end
    % Now append both images top-bottom.
    im = [image1; image2];   
end
end
