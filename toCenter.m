function [gogo, RGB] = toCenter(ryzeObj, RGB, pos, offsetThreshold)

disp("toCenter");
gogo = false;

% Calculating the size of the image.
nRows = size(RGB, 1); % y
nCols = size(RGB, 2); % x

% Calculating the dist. b/w the drone & the center.
rowOffset = (nRows/2) - pos(2);
colOffset = (nCols/2) - pos(1);
RGB = insertText(RGB, [1,1], "Offset:[" + rowOffset + ", " + colOffset + "]");

% Visualizing the front of the drone.
bbox = [nCols/2 - offsetThreshold,...
    nRows/2 - offsetThreshold,...
    2*offsetThreshold, 2*offsetThreshold];
RGB = insertShape(RGB, "Rectangle", bbox);

if pos(1) < 0 % The drone can't find the gate -> hovering
    RGB = insertText(RGB, [1 30], "Command: Hovering");
else
    if colOffset < -offsetThreshold
        RGB = insertText(RGB, [1 30], "Command: Move right");
        if ryzeObj.State ~= "landed"
            moveright(ryzeObj);
        end
    elseif colOffset > offsetThreshold
        RGB = insertText(RGB, [1 30], "Command: Move left");
        if ryzeObj.State ~= "landed"
            moveleft(ryzeObj);
        end
    elseif rowOffset > offsetThreshold
        RGB = insertText(RGB, [1 30], "Command: Move up");
        if ryzeObj.State ~= "landed"
            moveup(ryzeObj);
        end
    elseif rowOffset < -offsetThreshold
        RGB = insertText(RGB, [1 30], "Command: Move down");
        if ryzeObj.State ~= "landed"
            movedown(ryzeObj);
        end
    else
        RGB = insertText(RGB, [1 30], "Command: Hovering");
        gogo = true;
    end
end
    