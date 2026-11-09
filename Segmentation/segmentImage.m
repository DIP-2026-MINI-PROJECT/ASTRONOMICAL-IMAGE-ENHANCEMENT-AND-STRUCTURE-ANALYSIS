
function [binaryImage, threshold] = segmentImage(image)

    % Convert input to a normalized intensity range
    image = mat2gray(image);

    % Calculate the threshold
    threshold = graythresh(image);

    % Generate the binary mask
    binaryImage = imbinarize(image, threshold);

end
