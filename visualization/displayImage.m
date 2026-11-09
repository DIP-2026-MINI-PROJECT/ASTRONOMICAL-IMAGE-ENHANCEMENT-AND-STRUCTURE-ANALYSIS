function displayImage(img, titleText)

    figure;

    imagesc(img);
    axis image;

    colormap gray;
    colorbar;

    title(titleText);

end