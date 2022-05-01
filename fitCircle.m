function [center] = fitCircle(seed_points, known_radius)
    % find center of the circle using the property of a circle that the
    % perpendicular bisector of any chord of the circle intersects with the
    % center of the circle

    % make chord from two seed points
    % chord = segment with endpoints on circle
    chord = seed_points(1,:) - seed_points(2,:);
    % get length of chord
    chord_length = norm(chord);
    
    % make sure that pythagorean theorem actually works here
    % if the points are too close or too far apart for a circle to be
    % created with the correct radius, then set center to NaN which will
    % skip this iteration
    if (known_radius^2 - (chord_length/2) ^ 2) > 0
        % get distance between the midpoint of the chord and the center of
        % the circle using pythagorean theorem
        midpoint_chord_to_center = sqrt(known_radius^2 - (chord_length/2)^2);
        % get the location of the midpoint
        midpoint_chord = (chord / 2) + seed_points(2,:);
        
        % get the vector perpendicular to the chord
        orthov = [-chord(2); chord(1)];
        % make it a unit vector
        orthov_unit = orthov/norm(orthov);
        % get the vector going from the midpoint of the chord to the center
        orthov_radius = orthov_unit * midpoint_chord_to_center;
        
        % now calculate the center of the circle
        % 2 points and a radius can form two circles
        % we just pick the first one because RANSAC runs enough times
        % that it will end up choosing a good circle
        center = [];
        center(1) = midpoint_chord(1)+orthov_radius(1);
        center(2) = midpoint_chord(2)+orthov_radius(2);
    else
        center = NaN;
    end
end