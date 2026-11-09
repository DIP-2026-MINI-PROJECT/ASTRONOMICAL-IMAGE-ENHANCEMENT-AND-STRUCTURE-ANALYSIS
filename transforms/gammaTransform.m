function output = gammaTransform(image, gamma)

    % Ensure non-negative input
    image = max(image, 0);
    % Apply gamma transformation
    output = image .^ gamma;
    % Ensure output remains within [0, 1]
    output = min(max(output, 0), 1);

end