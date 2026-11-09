function output = logTransform(image)

    % Ensure numerical stability
    image = max(image, 0);
    % Logarithmic transformation
    output = log(1 + image);
    % Normalize output to [0,1]
    output = output ./ max(output(:));

end