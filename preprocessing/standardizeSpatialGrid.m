function standardizedImage = standardizeSpatialGrid(img, targetSize)

    % Check target size
    if numel(targetSize) ~= 2
        error("targetSize must contain [rows columns].");
    end

    % Resize image to target dimensions
    standardizedImage = imresize(img, targetSize);

end