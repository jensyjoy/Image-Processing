function [centers, radii] = findCircles(image)
    % findCircles - Detect and visualize circles in an image.
    % Inputs:
    %   image - An image matrix in which circles are to be detected.
    % Outputs:
    %   centers - A Nx2 matrix of [x y] coordinates for the center of each circle.
    %   radii - A Nx1 vector containing the radii of each detected circle.
    
    % Use the 'imfindcircles' function to detect circles in the image. 
    % The function looks for dark circles with radii between 20 and 25 pixels.
    % 'Sensitivity' is set to 0.92 to control the detection sensitivity, and 
    % 'Method' is set to 'twostage' for potentially more accurate but slower detection.
    [Centers, radii] = imfindcircles(image, [20 25], 'ObjectPolarity', 'dark', ...
                                     'Sensitivity', 0.92, 'Method', 'twostage');
    
    % Draw the detected circles on the image using 'viscircles'. 
    % 'Centers' and 'radii' are used to define the circles to be drawn.
    circle = viscircles(Centers, radii); 
    
    % Assign the detected centers to the output variable 'centers'.
    centers = Centers; 
    
    % Assign the detected radii to the output variable 'radii'.
    radii = radii;
end
