function [circle_center, best_inlier_set, best_outlier_set] = circleRansac(points, known_radius, n, distance_threshold)
    % define variables for saving the circle fit
    circle_center = [];
    best_inlier_set = zeros(0,2);
    best_outlier_set = zeros(0,2);
    
    for i=1:n
        % select two points at random using datasample
        % these two points along with the given radius
        % define exactly 2 circles
        seed_points = datasample(points,2,'Replace', false);
        % call fit circle to find one of those circles
        [center] = fitCircle(seed_points, known_radius);
        % if these two points and the radius can't form a circle, 
        % skip the rest of this loop
        if isnan(center)
            continue;
        end
        
        diffs = points - repmat([center(1), center(2)], [size(points, 1) 1]);
        % get radius of each point to the defined circle center
        radii = sqrt(sum(diffs.^2,2));
        inliers = abs(radii - known_radius) < distance_threshold;

        % probably deal with gaps

        % compare # of inliers with previous best inlier set
        if sum(inliers) > size(best_inlier_set, 1)
            circle_center = center;
            best_inlier_set = points(inliers,:); % set inliers
            best_outlier_set = points(~inliers,:); % set outliers
        end
    end
end