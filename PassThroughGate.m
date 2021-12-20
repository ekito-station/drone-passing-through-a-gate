%% Clear
clear; close all; clc;

%% Set Up
% Set the folder that includes this file as the current folder.
% Power on the drone.
% Connect your computer to the drone's wifi network.
ryzeObj = ryze();
cameraObj = camera(ryzeObj);
img = snapshot(cameraObj);

%% Execution
try
    answer = questdlg('Do you want to allow the drone to take off?', ...
        'Takeoff Clearance', ...
        'Yes', 'No', ...
        'No');
    switch answer
        case 'Yes'
            disp('Taking off.');
            takeoff(ryzeObj);
    end

    % Moving the drone so that the entire gate is visible.
    disp("Moving the drone so that the entire gate is visible.");
    surveyGate(ryzeObj, cameraObj);
    
    % Calculating the gate's center of gravity and moving the drone there.
    disp("Calculating the gate's center of gravity and moving the drone there.");
    calcAndGoToCenter(ryzeObj, cameraObj);

    % Moving the drone through the gate and landing it.
    disp("Moving the drone through the gate and landing it.");
    goAndLand(ryzeObj,cameraObj);
    
catch
    disp("Landing the drone with some cause.");
    land(ryzeObj);
end

%% Clear
land(ryzeObj);
clear ryzeObj;
clear cameraObj;
