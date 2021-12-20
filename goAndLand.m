function goAndLand(ryzeObj, cameraObj)

img = snapshot(cameraObj);
videoPlayer = vision.DeployableVideoPlayer;
videoPlayer(img);

while videoPlayer.isOpen
    
    if ~isempty(img)

        % Moving the drone through the gate.
        disp("Moving the drone through the gate.");
        img = snapshot(cameraObj);
        videoPlayer(img);
        movedown(ryzeObj);
        img = snapshot(cameraObj);
        videoPlayer(img);
        movedown(ryzeObj);
        img = snapshot(cameraObj);
        videoPlayer(img);
        for i = 1:8
            moveforward(ryzeObj);
            img = snapshot(cameraObj);
            videoPlayer(img);
        end

        % Turning the drone around & Landing it.
        around = true;
        while around
            disp("Turning the drone around.");
            for j = 1:6
                turn(ryzeObj, pi/6);
                img = snapshot(cameraObj);
                videoPlayer(img);
            end
            if nnz(filterB(img)) > 15 % If the drone see the gate -> land
                disp("Landing the drone.");
                land(ryzeObj);
                around = false;
            else
                turn(ryzeObj, pi);
                moveforward(ryzeObj);
            end
        end
        return;
    end
end