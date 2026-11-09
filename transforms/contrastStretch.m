function output = contrastStretch(image, lowPercentile, highPercentile)

    % Calculate intensity limits
    lowValue = prctile(image(:), lowPercentile);
    highValue = prctile(image(:), highPercentile);

    % Avoid division by zero
    if highValue <= lowValue
        output = zeros(size(image));
        return;
    end
    % Stretch intensity range
    output = (image - lowValue) ./ (highValue - lowValue);
    % Clip values outside the selected range
    output = max(min(output, 1), 0);

end