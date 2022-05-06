function [line_inliers, circle_inliers, circle_center, end_points] = detectObjects(points, bob_radius)
    current_points = points;
    
    % look for circle
    [circle_center, circle_inliers, circle_outliers] = circleRansac(current_points, bob_radius, 5000, 0.001);
    % if the "circle" inlier set is too small to plausibly be part of a
    % circle, then ignore
    if size(circle_inliers,1) < 5
        circle_center = [];
        circle_inliers = [];
    % if circle found
    % remove circle from points
    else
        current_points = circle_outliers;
    end

    % look for lines
    % assume max number of lines is 10
    total_lines = 20;
    line_inliers = [];
    end_points = zeros(total_lines,4);
    
    for i=1:total_lines
        [best_end_points, inlier_set, outlier_set] = lineRansac(current_points, 1000, 0.05);
        % stop looking for lines when the inlier set gets too small
        % (a wall is going to have more inliers than 5)
        if size(inlier_set,1) < 5|| size(outlier_set,1) < 2
            break;
        end
        % add the inliers to the total inlier set
        line_inliers = [line_inliers; inlier_set];
        
        % flatten end points into a 4x1 for later use
        end_points(i,:) = reshape(best_end_points, [1,4]);
        % set current points to outliers
        % to remove current inlier set from current points
        current_points = outlier_set;
    end    
    
end