function output = morphologicalProcess(image, method, structuringElement)

    switch lower(method)

        case "erosion"

            output = imerode(image, structuringElement);


        case "dilation"

            output = imdilate(image, structuringElement);


        case "opening"

            output = imopen(image, structuringElement);


        case "closing"

            output = imclose(image, structuringElement);


        case "tophat"

            output = imtophat(image, structuringElement);


        case "bothat"

            output = imbothat(image, structuringElement);


        otherwise

            error("Unknown morphological operation: %s", method);

    end

end