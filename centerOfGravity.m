function [pos, RGB] = centerOfGravity(img)

disp("CenterOfGravity");
RGB = img;

% Filtering the image
[BW, maskedRGBImage] = filterB(img);

% Row & col of the white area of the binary image
[r, c] = find(BW);

% If the detected area is small -> not detected
if numel(r) < 50
    pos = [-1, -1];
    return;
end

% Calculating the center of gravity
pos = [mean(c) mean(r)];

% For visualization
RGB = insertObjectMask(RGB, BW, 'Color', 'white', 'Opacity', 0.9);
RGB = insertMarker(RGB, pos, '*', 'size', 10);
end


