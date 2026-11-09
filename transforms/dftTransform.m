function [F, magnitude, spectrum] = dftTransform(image)

    % Compute 2-D DFT
    F = fft2(image);

    % Shift zero frequency component to the center
    F = fftshift(F);

    % Magnitude of the frequency components
    magnitude = abs(F);

    % Log scaling for visualization
    spectrum = log(1 + magnitude);

    % Normalize visualization spectrum to [0,1]
    spectrum = spectrum ./ max(spectrum(:));

end