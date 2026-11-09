
clear; clc;
close all;


dataDir = "Input Images Centaurus A/";

files = {
    %fullfile(dataDir, "Centaurus_A_DSS.fits")
    %fullfile(dataDir, "Centaurus_A_DSS2_R.fits")
    %fullfile(dataDir, "Centaurus_A_WISE12.fits")
    %fullfile(dataDir, "Crab_Nebula_DSS.fits")
    %fullfile(dataDir, "Whirlpool_DSS.fits")
    %fullfile(dataDir, "Orion_Nebula_DSS2.fits")
    %fullfile(dataDir, "Whirlpool_DSS2_Red.fits")
    %fullfile(dataDir, "Dumbbell_Nebula_DSS2.fits")
    fullfile(dataDir, "Andromeda_Galaxy_DSS2.fits")
};

names = {
    %"Centaurus A DSS"
    %"Centaurus A DSS2_R"
    %"Centaurus A WISE12"
    %"Crab DSS"
    %"Whirlpool DSS"
    %"Orion Nebula DSS2"
    %"Whirlpool DSS2 Red"
    %"Dumbbell Nebula DSS2"
    "Andromeda Galaxy DSS2"

};


outputRoot = fullfile(dataDir, "DIP_Results");

if ~exist(outputRoot, "dir")
    mkdir(outputRoot);
end


images = struct([]);

for k = 1:length(files)

    images(k).name = names{k};
    images(k).filename = files{k};

    % Create an individual output folder for each image.
    folderName = regexprep(char(images(k).name), '[^A-Za-z0-9_-]', '_');

    images(k).outputDir = fullfile(outputRoot, folderName);

    if ~exist(images(k).outputDir, "dir")
        mkdir(images(k).outputDir);
    end

    images(k).data = fitsread(files{k});
    images(k).info = fitsinfo(files{k});

    % Original image
    displayImage(images(k).data, images(k).name);

    saveCurrentFigure(images(k).outputDir, images(k).name + " - Original Input");

    %displayHistogram(images(k).data, images(k).name);

    % Get clean image and valid-pixel mask
    [images(k).cleanData, images(k).validMask] = createValidMask(images(k).data);

    % Resize image to 300 x 300
    images(k).standardizedImage = standardizeSpatialGrid(images(k).cleanData, [300 300]);

    % Resize validity mask
    images(k).validMask = imresize(double(images(k).validMask), [300 300], "nearest") > 0.5;

    % Normalize image
    images(k).normalizedData = normalizeImage(images(k).standardizedImage, "percentile");

end


gamma = 1.25;

gaussianSigma = 1.5;

cutoffFrequency = 30;

butterworthOrder = 2;

morphologyRadius = 5;

se = strel("disk", morphologyRadius, 0);

minimumObjectArea = 5;


for k = 1:length(images)

    inputImage = images(k).normalizedData;


    % Log transformation
    images(k).logData = logTransform(inputImage);

    outputTitle = images(k).name + " - Log Transform";

    displayImage(images(k).logData, outputTitle);

    saveCurrentFigure(images(k).outputDir, outputTitle);


    % Gamma transformation
    images(k).gammaData = gammaTransform(inputImage, gamma);

    outputTitle = images(k).name + " - Gamma Transform";

    displayImage(images(k).gammaData, outputTitle);

    saveCurrentFigure(images(k).outputDir, outputTitle);


    % Contrast stretching
    images(k).contrastData = contrastStretch(inputImage, 1, 99);

    outputTitle = images(k).name + " - Contrast Stretch";

    displayImage(images(k).contrastData, outputTitle);

    saveCurrentFigure(images(k).outputDir, outputTitle);


    % Gaussian filtering
    images(k).filteredGaussian = spatialFilter(inputImage, "gaussian", gaussianSigma);

    outputTitle = images(k).name + " - Filtered Gaussian Spatial";

    displayImage(images(k).filteredGaussian, outputTitle);

    saveCurrentFigure(images(k).outputDir, outputTitle);


    % Calculate Discrete Fourier Transform
    [images(k).DFT, images(k).frequencyMagnitude, images(k).frequencySpectrum] = dftTransform(inputImage);


    % Ideal filter
    images(k).FidealFiltered = frequencyFilter(images(k).DFT, "ideal", cutoffFrequency);

    outputTitle = images(k).name + " - Filtered Ideal";

    displayImage(images(k).FidealFiltered, outputTitle);

    saveCurrentFigure(images(k).outputDir, outputTitle);


    % Gaussian filter
    images(k).FgaussianFiltered = frequencyFilter(images(k).DFT, "gaussian", cutoffFrequency);

    outputTitle = images(k).name + " - Filtered Gaussian Frequency";

    displayImage(images(k).FgaussianFiltered, outputTitle);

    saveCurrentFigure(images(k).outputDir, outputTitle);


    % Butterworth filter
    images(k).FbutterworthFiltered = frequencyFilter(images(k).DFT, "butterworth", [cutoffFrequency, butterworthOrder]);

    outputTitle = images(k).name + " - Filtered Butterworth";

    displayImage(images(k).FbutterworthFiltered, outputTitle);

    saveCurrentFigure(images(k).outputDir, outputTitle);



    % Erosion
    images(k).eroded = morphologicalProcess(inputImage, "erosion", se);

    outputTitle = images(k).name + " - Erosion";

    displayImage(images(k).eroded, outputTitle);

    saveCurrentFigure(images(k).outputDir, outputTitle);


    % Dilation
    images(k).dilated = morphologicalProcess(inputImage, "dilation", se);

    outputTitle = images(k).name + " - Dilation";

    %displayImage(images(k).dilated, outputTitle);

    saveCurrentFigure(images(k).outputDir, outputTitle);


    % Opening
    images(k).opened = morphologicalProcess(inputImage, "opening", se);

    outputTitle = images(k).name + " - Opening";

    displayImage(images(k).opened, outputTitle);

    saveCurrentFigure(images(k).outputDir, outputTitle);


    % Closing
    images(k).closed = morphologicalProcess(inputImage, "closing", se);

    outputTitle = images(k).name + " - Closing";

    displayImage(images(k).closed, outputTitle);

    saveCurrentFigure(images(k).outputDir, outputTitle);


    % White Top-Hat
    images(k).topHat = morphologicalProcess(inputImage, "tophat", se);

    outputTitle = images(k).name + " - Top-Hat";

    displayImage(images(k).topHat, outputTitle);

    saveCurrentFigure(images(k).outputDir, outputTitle);


    % Black Bottom-Hat
    images(k).bottomHat = morphologicalProcess(inputImage, "bothat", se);

    outputTitle = images(k).name + " - Bottom-Hat";

    displayImage(images(k).bottomHat, outputTitle);

    saveCurrentFigure(images(k).outputDir, outputTitle);

end


for k = 1:length(images)


    % Baseline segmentation
    [images(k).baselineMask, images(k).baselineThreshold] = segmentImage(images(k).normalizedData);


    % Top-Hat segmentation
    [images(k).topHatMask, images(k).topHatThreshold] = segmentImage(images(k).topHat);


    % Bottom-Hat segmentation
    [images(k).bottomHatMask, images(k).bottomHatThreshold] = segmentImage(images(k).bottomHat);


    % Convert masks to logical format
    images(k).baselineMask = logical(images(k).baselineMask);

    images(k).topHatMask = logical(images(k).topHatMask);

    images(k).bottomHatMask = logical(images(k).bottomHatMask);


    % Exclude invalid pixels
    images(k).baselineMask = images(k).baselineMask & images(k).validMask;

    images(k).topHatMask = images(k).topHatMask & images(k).validMask;

    images(k).bottomHatMask = images(k).bottomHatMask & images(k).validMask;


    % Baseline mask cleanup
    images(k).baselineCleanMask = bwareaopen(images(k).baselineMask, minimumObjectArea, 8);


    % Top-Hat mask cleanup
    images(k).topHatCleanMask = bwareaopen(images(k).topHatMask, minimumObjectArea, 8);


    % Bottom-Hat mask cleanup
    images(k).bottomHatCleanMask = bwareaopen(images(k).bottomHatMask, minimumObjectArea, 8);


    % Baseline features
    images(k).baselineFeatures = extractMorphologicalFeatures(images(k).baselineCleanMask);


    % Top-Hat features
    images(k).topHatFeatures = extractMorphologicalFeatures(images(k).topHatCleanMask);


    % Bottom-Hat features
    images(k).bottomHatFeatures = extractMorphologicalFeatures(images(k).bottomHatCleanMask);

end


for k = 1:length(images)


    % Number of valid pixels
    validPixelCount = nnz(images(k).validMask);


    % Compare all three segmentation methods
    images(k).segmentationComparison = compareSegmentationResults(images(k).baselineFeatures, images(k).topHatFeatures, images(k).bottomHatFeatures, validPixelCount);


    % Display comparison
    fprintf("\nResults for %s:\n", images(k).name);

    disp(images(k).segmentationComparison);


    % Baseline overlay
    displaySegmentationOverlay(images(k).normalizedData, images(k).baselineCleanMask);

    outputTitle = images(k).name + " - Baseline Segmentation Overlay";

    title(outputTitle, "Interpreter", "none");

    saveCurrentFigure(images(k).outputDir, outputTitle);


    % Top-Hat overlay
    displaySegmentationOverlay(images(k).normalizedData, images(k).topHatCleanMask);

    outputTitle = images(k).name + " - Top-Hat Segmentation Overlay";

    title(outputTitle, "Interpreter", "none");

    saveCurrentFigure(images(k).outputDir, outputTitle);


    % Bottom-Hat overlay
    displaySegmentationOverlay(images(k).normalizedData, images(k).bottomHatCleanMask);

    outputTitle = images(k).name + " - Bottom-Hat Segmentation Overlay";

    title(outputTitle, "Interpreter", "none");

    saveCurrentFigure(images(k).outputDir, outputTitle);


    % Pseudo-colour transformation
    images(k).pseudoColor = pseudoColor(images(k).normalizedData, "jet");


    % Display pseudo-colour image
    outputTitle = images(k).name + " - Pseudo Colour";

    displayImage(images(k).pseudoColor, outputTitle);

    saveCurrentFigure(images(k).outputDir, outputTitle);

end
