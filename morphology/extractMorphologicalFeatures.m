function features = extractMorphologicalFeatures(binaryImage)
%EXTRACTMORPHOLOGICALFEATURES Extract properties of connected regions.
%
%   features = extractMorphologicalFeatures(binaryImage)
%
%   INPUT:
%       binaryImage - Binary image containing detected regions
%
%   OUTPUT:
%       features - Structure containing:
%                  numRegions
%                  regions
%                  totalArea
%                  largestRegionArea
%                  largestRegionIndex
%
%   Region properties extracted:
%       Area
%       Centroid
%       BoundingBox
%       MajorAxisLength
%       MinorAxisLength
%       Eccentricity
%       Perimeter
%       Extent
%       Solidity
%       EquivDiameter

    %% Find connected components

    connectedComponents = bwconncomp(binaryImage, 8);

    features.numRegions = ...
        connectedComponents.NumObjects;


    %% Handle case of no detected regions

    if connectedComponents.NumObjects == 0

        features.regions = struct([]);

        features.totalArea = 0;

        features.largestRegionArea = 0;

        features.largestRegionIndex = [];

        return;

    end


    %% Extract region properties

    features.regions = regionprops( ...
        connectedComponents, ...
        "Area", ...
        "Centroid", ...
        "BoundingBox", ...
        "MajorAxisLength", ...
        "MinorAxisLength", ...
        "Eccentricity", ...
        "Perimeter", ...
        "Extent", ...
        "Solidity", ...
        "EquivDiameter", ...
        "PixelIdxList");


    %% Total detected area

    areas = [features.regions.Area];

    features.totalArea = sum(areas);


    %% Largest detected region

    [features.largestRegionArea, ...
     features.largestRegionIndex] = max(areas);

end