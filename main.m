placeNeato(0, 0, 1, 0)
pause(2)

syms x y
bob_radius = 0.25;

position = [0 0];
heading  = [1 0];
all_line_inliers   = [NaN NaN];
all_circle_inliers = [NaN NaN];

stop = false;
while ~stop
    [r, theta] = scan();
    angle = atan2(heading(2), heading(1)) * 180/pi;
    points = convertLidarToGlobal(r, theta, position, angle);
    [line_inliers, circle_inliers, circle_center] = detectObjects(points, bob_radius);

    all_line_inliers   = union(all_line_inliers, line_inliers, 'rows');
    all_circle_inliers = union(all_circle_inliers, circle_inliers, 'rows');
    
    p_field = create_potential_field(all_line_inliers, all_circle_inliers);
    grad = gradient(p_field, [x y]);
    grad = double(subs(grad, [x y], position)');

   %[position, heading] = drive(grad, position, heading);
    pause(0.05);
end