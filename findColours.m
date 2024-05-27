function [finalImage] = findColours(filename)
    % findColours - Process an image to recognize colors.
    % Inputs:
    %   filename - A string containing the file path to an image.
    % Outputs:
    %   finalImage - A cell array containing recognized colors or 'unknown' if an error occurs.

    % Initialize the finalImage with 'unknown' in case the image processing fails.
    finalImage = repmat({'unknown'}, 4, 4);
    
    try
        % Try block to handle potential errors during image processing.

        % Load the original image from the specified file.
        orgImage = LoadImage(filename);
        % Correct potential issues in the image (e.g., brightness, contrast).
        correctedImage = correctImage(filename);
        
        % Uncomment to detect circles in the corrected image (if part of your processing).
        % findCircles(correctedImage);
        
        % Analyze the corrected image to identify colors.
        colorRecognition = getColours(correctedImage);
        % Update finalImage with the results from color recognition.
        finalImage = colorRecognition;
        
        % Extract the file name and extension from the full file path.
        [~, name, ext] = fileparts(filename);
        imageFileName = [name, ext];
        
        % Create a new figure for displaying images.
        figure;
        % Display the original image in the first subplot.
        subplot(1, 2, 1);
        imshow(orgImage);
        title(sprintf('Original Image: %s', imageFileName));
        % Display the corrected image in the second subplot.
        subplot(1, 2, 2);
        imshow(correctedImage);
        title(sprintf('Corrected Image: %s', imageFileName));
        
        % Set a super title for the figure using the file name.
        sgtitle(sprintf('Image: %s', imageFileName));
        
        % Print the color recognition results to the console.
        disp([imageFileName, ':']);
        disp(finalImage);
        
    catch ME
        % Catch block to handle and report errors during the try block.

        % Log the error message - uncomment to enable.
        %warning('Error processing the image: %s', ME.message);
        
        % Attempt to extract the file name and extension from the full file path.
        [~, name, ext] = fileparts(filename);
        imageFileName = [name, ext];
        
        % Display the original image if it was successfully loaded before the error.
        if exist('orgImage', 'var')
            figure;
            imshow(orgImage);
            title(sprintf('Original Image: %s', imageFileName));
        end
        
        % Print the default 'unknown' color recognition results to the console.
        disp([imageFileName, ':']);
        disp(finalImage);
    end
end
