function colours = getColours(image)
    % getColours - Identifies and classifies colors of squares in an image.
    % Input:
    %   image - A color image from which to identify square colors.
    % Output:
    %   colours - A 4x4 cell array containing the name of the color of each square.

    % Erode the image to eliminate small noise and separate touching objects.
    image = imerode(image, ones(3));

    % Apply a median filter to suppress noise while preserving edges.
    image = medfilt3(image, [11 11 1]);

    % Adjust image contrast using histogram limits.
    image = imadjust(image, stretchlim(image, 0.04));

    % Convert the image to grayscale and threshold it to create a binary mask.
    imageMask = rgb2gray(image) > 0.08;

    % Remove small objects from the binary mask.
    imageMask = bwareaopen(imageMask, 100);

    % Remove small holes from the binary mask.
    imageMask = ~bwareaopen(~imageMask, 100);

    % Clear objects connected to the border of the image.
    imageMask = imclearborder(imageMask);

    % Erode the mask to reduce edge effects in subsequent analysis.
    imageMask = imerode(imageMask, ones(8));

    % Label connected components in the binary mask.
    [L, N] = bwlabel(imageMask);

    % Initialize array to hold the average color in each labeled region.
    maskColors = zeros(N, 3);

    % Calculate the mean color for each segmented region.
    for p = 1:N
        imgmask = L == p;
        mask = image(repmat(imgmask, [1 1 3]));
        maskColors(p, :) = mean(reshape(mask, [], 3), 1);
    end

    % Get the centroids of each labeled region for positioning.
    Stats = regionprops(imageMask, 'centroid');
    Centroids = vertcat(Stats.Centroid);

    % Normalize and round centroid coordinates to fit a 3x3 grid.
    centroidlimits = [min(Centroids, [], 1); max(Centroids, [], 1)];
    Centroids = round((Centroids - centroidlimits(1, :)) ./ range(centroidlimits, 1) * 3 + 1);

    % Map colors to a 4x4 grid based on centroid positions.
    index = sub2ind([4 4], Centroids(:, 2), Centroids(:, 1));

    % Ensure there are exactly 16 color patches.
    if numel(index) ~= 16
        error('Number of color patches detected does not match the expected grid size.');
    end
    maskColors(index, :) = maskColors;

    % Define reference colors and their RGB values.
    colorNames = {'white', 'red', 'green', 'blue', 'yellow'};
    colorReferences = [1 1 1; 1 0 0; 0 1 0; 0 0 1; 1 1 0];

    % Compute distances between detected colors and reference colors in RGB space.
    distance = maskColors - permute(colorReferences, [3 2 1]);
    distance = squeeze(sum(distance.^2, 2));

    % Identify the closest matching reference color for each patch.
    [~, index] = min(distance, [], 2);

    % Map indices to color names and reshape into a 4x4 grid.
    colours = reshape(colorNames(index), 4, 4);
end
