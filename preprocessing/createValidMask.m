function [cleanImage, validMask] = createValidMask(img)

    % Identify finite pixels
    validMask = isfinite(img);

    % Create a copy of the original image
    cleanImage = img;

    % Replace invalid values with zero
    cleanImage(~validMask) = 0;

end