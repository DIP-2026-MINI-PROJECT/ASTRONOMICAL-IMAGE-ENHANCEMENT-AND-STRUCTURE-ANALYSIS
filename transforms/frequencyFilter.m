function output = frequencyFilter(image, method, parameter)

    [rows, cols] = size(image);

    [u, v] = meshgrid((-floor(cols/2)):(ceil(cols/2)-1),(-floor(rows/2)):(ceil(rows/2)-1));

    % Distance from centre of frequency domain
    D = sqrt(u.^2 + v.^2);

    switch lower(method)

        case "ideal"

            D0 = parameter;
            % Ideal low-pass filter
            H = double(D <= D0);


        case "butterworth"

            D0 = parameter(1);
            order = parameter(2);
            H = 1 ./ (1 + (D ./ D0).^(2 * order));


        case "gaussian"

            D0 = parameter;
            % Gaussian low-pass filter
            H = exp(-(D.^2) / (2 * D0^2));


        otherwise

            error("Unknown frequency filter: %s", method);

    end

    G = image .* H;
    G = ifftshift(G); %IDFT
    output = real(ifft2(G));

end