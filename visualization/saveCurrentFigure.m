
function saveCurrentFigure(outputFolder, figureTitle)


    outputFolder = char(string(outputFolder));

    figureTitle = char(string(figureTitle));


    if ~exist(outputFolder, "dir")
        mkdir(outputFolder);
    end

    fig = gcf;


    % Replace Windows-invalid filename characters.
    safeName = regexprep(figureTitle, ...
        '[<>:"/\\|?*\x00-\x1F]', '_');

    % Replace spaces with underscores.
    safeName = regexprep(safeName, '\s+', '_');

    % Remove trailing dots and spaces.
    safeName = regexprep(safeName, '[. ]+$', '');

    % Handle empty filenames.
    if isempty(safeName)
        safeName = 'Figure';
    end

    % Avoid reserved Windows filenames.
    [~, baseName, ~] = fileparts(safeName);

    reservedNames = { ...
        'CON', 'PRN', 'AUX', 'NUL', ...
        'COM1', 'COM2', 'COM3', 'COM4', 'COM5', ...
        'COM6', 'COM7', 'COM8', 'COM9', ...
        'LPT1', 'LPT2', 'LPT3', 'LPT4', 'LPT5', ...
        'LPT6', 'LPT7', 'LPT8', 'LPT9'};

    if any(strcmpi(baseName, reservedNames))
        safeName = ['Figure_', safeName];
    end


    % Use character-array concatenation.
    fileName = [safeName, '.png'];

    outputPath = fullfile(outputFolder, fileName);


    try

        exportgraphics(fig, outputPath, 'Resolution', 300);

    catch

        try

            print(fig, outputPath, '-dpng', '-r300');

        catch ME

            error("saveCurrentFigure:SaveFailed", ...
                "Unable to save figure to:\n%s\n\nReason: %s", ...
                outputPath, ME.message);

        end

    end


    fprintf("Saved successfully: %s\n", outputPath);

end
