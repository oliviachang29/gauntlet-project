function [best_inlier_set, best_outlier_set] = lineRansac(points, n, distance_threshold)
    % define variables for saving the line fit
    best_inlier_set = zeros(0,2);
    best_outlier_set = zeros(0,2);

    % try to fit n number of times
    for i=1:n
        %select two points at random using the 'datasample' function to define
        %the endpoints of the first candidate fit line
        candidates = datasample(points, 2, 'Replace', false);
        
        % find the vector that points from point 2 to point 1
        v=(candidates(1,:)-candidates(2,:))';
        
        % make sure we didn't choose the same point twice
        % check the length - if it is zero, then we need to resample
        if norm(v) == 0
            continue;
        end
        
        % define orthogonal direction from v
        orthv= [-v(2); v(1)];
        % make orthv a unit vector
        orthv_unit=orthv/norm(orthv); 
        
        % find distance from each scan point to one of the endpoints
        diffs = points - candidates(2,:);
        
        % project difference vectors onto orthogonal direction using
        % orthv_unit to get orthogonal distances from candidate fit line
        orth_dists = diffs * orthv_unit;
        
        % identify inliers by checking which distances are less than
        % distance threshold
        % output will be a logic array, with a 1 if the statement is true
        % and 0 if false.
        inliers = abs(orth_dists) < distance_threshold;
        
        % make sure there are no gaps
        % first taking the distance of each inlier away from an
        % endpoint (diffs) and projecting onto the best fit direction. We then
        % sort these from smallest to largest and take difference to find the
        % spacing between adjacent points. We then identify the maximum gap
        biggest_gap = max(diff(sort(diffs(inliers,:)*v/norm(v))));
        
        % compare # of inliers with previous best candidates
        if biggest_gap < 0.2  && sum(inliers) > size(best_inlier_set,1)
            best_inlier_set = points(inliers,:); % points where logical array is true
            best_outlier_set = points(~inliers, :); % points where logical array is not true
        end
    end
    
end