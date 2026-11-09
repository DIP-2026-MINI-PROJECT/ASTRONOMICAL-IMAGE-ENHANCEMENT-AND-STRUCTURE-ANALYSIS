function displayHistogram(img, titleText)

    figure;

    histogram(img(:), 100);

    xlabel("Pixel Intensity");
    ylabel("Number of Pixels");

    title(titleText);
    grid on;

end