function normalizedImage = normalizeImage(img, method)

    % Identify valid pixels
    validMask = isfinite(img);

    % Initialize output
    normalizedImage = zeros(size(img));

    % Extract valid pixel values
    validPixels = img(validMask);% uses validMask as a vector to get the image in pixels that have valid values

    switch lower(method)

        case "minmax"

            minValue = min(validPixels);
            maxValue = max(validPixels);

            if maxValue == minValue
                normalizedImage(validMask) = 0;
            else
                normalizedImage(validMask) = (validPixels - minValue) / (maxValue - minValue);
            end

        case "percentile"

            % Robust intensity limits
            lowValue = prctile(validPixels, 1);
            highValue = prctile(validPixels, 99);

            if highValue == lowValue
                normalizedImage(validMask) = 0;
            else

                normalizedPixels = ...
                    (validPixels - lowValue) / ...
                    (highValue - lowValue);

                % Clip values outside the selected range
                normalizedPixels = ...
                    max(min(normalizedPixels, 1), 0);

                normalizedImage(validMask) = normalizedPixels;
            end


        case "zscore"

            meanValue = mean(validPixels);
            stdValue = std(validPixels);

            if stdValue == 0
                normalizedImage(validMask) = 0;
            else
                normalizedImage(validMask) = (validPixels - meanValue) / stdValue;
            end

        otherwise

            error("Unknown normalization method: %s", method);

    end

end