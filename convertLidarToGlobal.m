function [points] = convertLidarToGlobal(r_lidar, theta_lidar, neato_pos, neato_orientation)
    % r_lidar, theta_lidar are the filtered output of scan.m
    
    % neato_pos is a vector [x_pos y_pos]
    
    % neato_orientation is the orientation of the neato relative to the
    % global frame, in radians. a positive angle means the Neato's
    % ihat_N axis was rotated counterclockwise from the ihat_G axis.
    
    % the origin of the Lidar frame in the Neato frame (ihat_N, jhat_N).
    origin_of_lidar_frame = [-0.084 0];
    
    % FIX: this theta is not the rotation from the global frame, but the
    % rotation from the neato heading!
    cartesian_points_in_l_frame = [cos(theta_lidar).*r_lidar...
                                   sin(theta_lidar).*r_lidar]';
      
    % add a row of all ones so we can use translation matrices
    cartesian_points_in_l_frame(end+1,:) = 1;
    
    % translate frame of reference to neato frame
    cartesian_points_in_n_frame = [1 0 origin_of_lidar_frame(1);...
                                   0 1 origin_of_lidar_frame(2);...
                                   0 0 1]*cartesian_points_in_l_frame;
                           
    % undo the rotation of the Neato so the points are with respected to
    % the global coordinate axes with the origin located at the Neato's
    % position
    rotated_points = [cos(neato_orientation) -sin(neato_orientation) 0;...
                      sin(neato_orientation) cos(neato_orientation) 0;...
                      0 0 1]*cartesian_points_in_n_frame;
                 
    % translate the points to be relative to the Global origin
    cartesian_points_in_g_frame = [1 0 neato_pos(1);...
                                   0 1 neato_pos(2);...
                                   0 0 1]*rotated_points;
                                                
    points = [cartesian_points_in_g_frame(1,:); cartesian_points_in_g_frame(2,:)]';
    
end