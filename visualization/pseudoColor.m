function output = pseudoColor(image, colormapName)

    % Keep image in valid range
    image = max(min(image,1),0);

    % Default colormap
    if nargin < 2
        colormapName = "parula";
    end

    % Convert grayscale intensities to indexed values
    indexedImage = gray2ind(image,256);

    % Generate selected colormap
    colorMap = feval(colormapName,256);

    % Convert indexed image to RGB
    output = ind2rgb(indexedImage,colorMap);
end