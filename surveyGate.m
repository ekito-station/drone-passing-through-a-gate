function surveyGate(ryzeObj, cameraObj)

%% Setting
img = snapshot(cameraObj);
videoPlayer = vision.DeployableVideoPlayer;
videoPlayer(img);

frameHeight = 0.7;

radRange = [11 300]; % Radius of the circle to be detected.
bigCircle = 10; % If the radius < this, the drone doesn't back.
radDiff = 3; % If the diff. b/w the circles > this, the drone turns around.

%% Execution
disp("Executing surveyGate.");

while videoPlayer.isOpen
    img = snapshot(cameraObj);
    YRG = img;
    [height, ~] = readHeight(ryzeObj);
    
    if ~isempty(img)
        % Filters
        Y = filterY(img);
        R = filterR(img);
        G = filterG(img);
        % Yellow　Circle
        [centersY, raddiY] = imfindcircles(Y, radRange);
        if ~isempty(centersY)
            %C_Y = centersY(1,:);
            R_Y = raddiY(1);
            YRG = insertObjectMask(YRG, Y, 'Color', 'yellow', 'Opacity', 0.9);
        end

        % Red Circle
        [centersR, raddiR] = imfindcircles(R, radRange);
        if ~isempty(centersR)
            %C_R = centersR(1,:);
            R_R = raddiR(1);
            YRG = insertObjectMask(YRG, R, 'Color', 'red', 'Opacity', 0.9);
        end

        % Green Circle
        [centersG, raddiG] = imfindcircles(G, radRange);
        if ~isempty(centersG)
            %C_G = centersG(1,:);
            R_G = raddiG(1);
            YRG = insertObjectMask(YRG, G, 'Color', 'green', 'Opacity', 0.9);
        end
        
        videoPlayer(YRG);

        % Movement
        if (isempty(centersY) && isempty(centersR) && isempty(centersG)) % Nothing
            if height > frameHeight
                disp("Moving the drone down.");
                movedown(ryzeObj);
            else
                disp("Moving the drone back.");
                moveback(ryzeObj);
            end
        elseif (~isempty(centersY) && isempty(centersR) && isempty(centersG)) % only Y
            if R_Y < bigCircle
                disp("Moving the drone down & right.");
                movedown(ryzeObj);
                moveright(ryzeObj);
            else
                disp("Moving the drone back & down & right.");
                moveback(ryzeObj);
                movedown(ryzeObj);
                moveright(ryzeObj);
            end
        elseif (isempty(centersY) && ~isempty(centersR) && isempty(centersG)) % only R
            if R_R < bigCircle
                disp("Moving the drone down & left.");
                movedown(ryzeObj);
                moveleft(ryzeObj);
            else
                disp("Moving the drone back & down & left.");
                moveback(ryzeObj);
                movedown(ryzeObj);
                moveleft(ryzeObj);
            end
        elseif (isempty(centersY) && isempty(centersR) && ~isempty(centersG)) % only G
            if R_G > bigCircle
                disp("Moving the drone up & right.");
                moveup(ryzeObj);
                moveright(ryzeObj);
            else
                disp("Moving the drone back & up & right");
                moveback(ryzeObj);
                moveup(ryzeObj);
                moveright(ryzeObj);
            end
        elseif (~isempty(centersY) && ~isempty(centersR) && isempty(centersG)) % Y & R
            if R_Y < bigCircle || R_R < bigCircle
                disp("Moving the drone down.");
                movedown(ryzeObj);
            else
                disp("Moving the drone back & down.");
                moveback(ryzeObj);
                movedown(ryzeObj);
            end
        elseif (isempty(centersY) && ~isempty(centersR) && ~isempty(centersG)) % R & G
            if R_R < bigCircle || R_G < bigCircle
                disp("Moving the drone up & left.");
                moveup(ryzeObj);
                moveleft(ryzeObj);
            else
                disp("Moving the drone back & up & left.");
                moveback(ryzeObj);
                moveup(ryzeObj);
                moveleft(ryzeObj);
            end
        elseif (~isempty(centersY) && isempty(centersR) && ~isempty(centersG)) % G & Y
            if R_G < bigCircle || R_Y < bigCircle
                disp("Moving the drone right.");
                moveright(ryzeObj);
            else
                disp("Moving the drone back & right.");
                moveback(ryzeObj);
                moveright(ryzeObj);
            end
        else % Everything　-> Turn around
            if abs(R_Y - R_G) < radDiff
                disp("Init position.");
                return;
            elseif R_Y > R_G
                disp("Turning CCW.");
                turn(ryzeObj, -pi/60);
            else
                disp("Turning CW.");
                turn(ryzeObj, pi/60);
            end
        end
    end
end