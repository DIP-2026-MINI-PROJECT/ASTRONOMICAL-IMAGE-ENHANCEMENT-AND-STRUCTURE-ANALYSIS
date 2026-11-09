function output = spatialFilter(image, method, parameter)
%SPATIALFILTER Apply spatial-domain filtering to an image.
%
%   output = spatialFilter(image, method, parameter)
%
%   INPUT:
%       image     - input image
%       method    - filtering method:
%                   "gaussian"
%                   "average"
%                   "median"
%
%       parameter - filter parameter:
%                   Gaussian : sigma
%                   Average  : kernel size
%                   Median   : window size
%
%   OUTPUT:
%       output    - filtered image

    switch lower(method)

        case "gaussian"

            sigma = parameter;

            % Determine kernel size from sigma
            kernelSize = 2 * ceil(3 * sigma) + 1;

            % Create Gaussian kernel
            kernel = fspecial("gaussian", kernelSize, sigma);

            % Apply spatial convolution
            output = imfilter(image, kernel, "replicate");

        case "average"

            kernelSize = parameter;

            kernel = fspecial("average", kernelSize);

            output = imfilter(image, kernel, "replicate");

        case "median"

            windowSize = parameter;

            output = medfilt2(image, [windowSize windowSize]);

        otherwise

            error("Unknown spatial filtering method: %s", method);

    end

end