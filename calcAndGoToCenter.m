function calcAndGoToCenter(ryzeObj, cameraObj)

%% Setting
cir = 5; % If nnz(circle) < this, the circle is not visible.
offsetThreshold = 25; % If the dist. b/w the drone & the center < this, it stays.

img = snapshot(cameraObj);
videoPlayer = vision.DeployableVideoPlayer;
videoPlayer(img);

%% Execution
disp("Executing calcAndGoToCenter.");

while videoPlayer.isOpen
    img = snapshot(cameraObj);
    
    if ~isempty(img)
             
        if nnz(filterY(img))>cir && nnz(filterR(img))>cir && nnz(filterG(img))>cir
        
            % Calculating the gate's center of gravity.
            [pos, RGB] = centerOfGravity(img);
            % Moving the drone in front of the gate's center of gravity.
            [gogo, RGB] = toCenter(ryzeObj, RGB, pos, offsetThreshold);
            % Visualization
            videoPlayer(RGB);
            if gogo
                return;
            end            
        else
            % Re-moving the drone so that the entire gate is visible.
            disp("Re-moving the drone so that the entire gate is visible.");
            surveyGate(ryzeObj, cameraObj);
        end
    end
end