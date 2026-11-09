function comparison = compareSegmentationResults(baselineFeatures, topHatFeatures, bottomHatFeatures, validPixelCount)


    methods = {
        baselineFeatures
        topHatFeatures
        bottomHatFeatures
    };

    methodNames = [
        "Baseline"
        "Top-Hat"
        "Bottom-Hat"
    ];


    numberOfMethods = length(methods);

    regionCount = zeros(numberOfMethods, 1);
    totalArea = zeros(numberOfMethods, 1);
    largestArea = zeros(numberOfMethods, 1);
    meanArea = zeros(numberOfMethods, 1);
    meanEccentricity = NaN(numberOfMethods, 1);
    foregroundFraction = zeros(numberOfMethods, 1);


    for k = 1:numberOfMethods

        currentFeatures = methods{k};

        regionCount(k) = currentFeatures.numRegions;

        totalArea(k) = currentFeatures.totalArea;

        largestArea(k) = currentFeatures.largestRegionArea;

        if regionCount(k) > 0

            meanArea(k) = totalArea(k) / regionCount(k);

            meanEccentricity(k) = ...
                mean([currentFeatures.regions.Eccentricity]);

        end

        if validPixelCount > 0

            foregroundFraction(k) = ...
                totalArea(k) / validPixelCount;

        end

    end


    comparison = table( ...
        methodNames, ...
        regionCount, ...
        totalArea, ...
        foregroundFraction, ...
        largestArea, ...
        meanArea, ...
        meanEccentricity, ...
        'VariableNames', { ...
        'Method', ...
        'NumberOfRegions', ...
        'TotalForegroundArea', ...
        'ForegroundFraction', ...
        'LargestRegionArea', ...
        'MeanRegionArea', ...
        'MeanEccentricity'});

end
