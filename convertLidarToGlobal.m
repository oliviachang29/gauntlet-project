function [points] = convertLidarToGlobal(r_lidar, theta_lidar, neato_pos, neato_orientation)
    % r_lidar, theta_lidar are the filtered output of scan.m
    
    % neato_pos is a vector [x_pos y_pos]
    
    % neato_orientation is the orientation of the neato relative to the
    % global frame, in radians. a positive angle means the Neato's
    % ihat_N axis was rotated counterclockwise from the ihat_G axis.
    
    % the origin of the Lidar frame in the Neato frame (ihat_N, jhat_N).
    origin_of_lidar_frame = [-0.084 0];
    
    cartesianPointsInLFrame = [cos(theta_lidar).*r_lidar...
                               sin(theta_lidar).*r_lidar]';
                           
    % add a row of all ones so we can use translation matrices
    cartesianPointsInLFrame(end+1,:) = 1;
    cartesianPointsInNFrame = [1 0 origin_of_lidar_frame(1);...
                               0 1 origin_of_lidar_frame(2);...
                               0 0 1]*cartesianPointsInLFrame;

    % undo the rotation of the Neato so the points are with respected to
    % the global coordinate axes with the origin located at the Neato's
    % position
    rotatedPoints = [cos(neato_orientation) -sin(neato_orientation) 0;...
                     sin(neato_orientation) cos(neato_orientation) 0;...
                     0 0 1]*cartesianPointsInNFrame;
                 
    % translate the points to be relative to the Global origin
    cartesianPointsInGFrame = [1 0 neato_pos(1);...
                               0 1 neato_pos(2);...
                               0 0 1]*rotatedPoints;
                           
    points = cartesianPointsInGFrame;
    
end