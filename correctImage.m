function correctedImage = correctImage(filename)
    % correctImage - Corrects the image based on projective transformations determined by the circles identified in it.
    % Inputs:
    %   filename - A string specifying the path to the image file.
    % Outputs:
    %   correctedImage - The geometrically corrected image.

    % Load the original image from the specified file path.
    orgImage = LoadImage(filename);

    % Convert the original image to black and white using a threshold.
    BandWimage = ~im2bw(orgImage, 0.33); % Invert the image to focus on darker features

    % Fill any holes in the binary image to ensure complete shapes.
    BandWfill = imfill(BandWimage, 'holes');

    % Apply a median filter to reduce noise and smooth the image.
    medianFilt = medfilt2(BandWfill, [12,12]);

    % Identify connected components in the filtered image.
    connectedComps = bwconncomp(medianFilt);

    % Calculate properties like area and centroid for each component.
    stats = regionprops(medianFilt, 'Area', 'Centroid');
    Areas = [stats.Area];

    % Initialize a matrix to isolate circles based on area conditions.
    Circles = zeros(connectedComps.ImageSize);
    for p = 1:connectedComps.NumObjects
        if stats(p).Area < max(Areas) % Assuming smaller areas likely represent circles
            Circles(connectedComps.PixelIdxList{p}) = 1;
        end
    end

    % Label the isolated circles for further processing.
    circlesLabeled = bwlabel(Circles, 8);

    % Obtain the area and centroid of each labeled circle.
    circlesProps = regionprops(circlesLabeled, 'Area', 'Centroid');
    circlesCentroids = [circlesProps.Centroid];

    % Reshape centroids for transformation calculations.
    varyingPoints = reshape(circlesCentroids, 2, []);

    % Transpose the matrix of centroids to match the required input format for transformations.
    MovingPointsT = transpose(varyingPoints);

    % Load a reference image and find circles to establish fixed points.
    staticPoints = flip(findCircles(LoadImage('images/org_1.png')));

    % Check if the number of detected circles is consistent between images.
    if size(staticPoints, 1) ~= size(MovingPointsT, 1)
        error('Number of circles detected in the two images is different.');
    end

    % Compute a projective transformation matrix based on moving and static points.
    transformation = fitgeotrans(MovingPointsT, staticPoints, 'Projective');

    % Reference the original dimensions of the reference image.
    Reference = imref2d(size(LoadImage('images/org_1.png')));

    % Apply the transformation to the original image to align it with the reference.
    correctedImage = imwarp(orgImage, transformation, 'OutputView', Reference);

end
