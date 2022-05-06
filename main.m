reset_neato();

syms x y
bob_radius = 0.25;

position = [0 0];
heading  = [1 0];
all_line_inliers   = [100 100];
all_circle_inliers = [100 100];

%figure
%hold on

all_positions = [0 0];

save_i = 0;

stop = false;
while ~stop
    save_i = save_i + 1;
    [r, theta] = scan();
    angle = atan2(heading(2), heading(1));
    points = convertLidarToGlobal(r, theta, position, angle);
    [line_inliers, circle_inliers, circle_center, ~] = detectObjects(points, bob_radius);

    save(['scan' num2str(save_i) '.mat'], 'line_inliers', 'circle_inliers');
    
    all_line_inliers   = union(all_line_inliers, line_inliers, 'rows');
    all_circle_inliers = union(all_circle_inliers, circle_inliers, 'rows');
    
    p_field = create_potential_field(all_line_inliers, all_circle_inliers);
    
    % x = [-1.5, 2.5]; y = [-3, 1]
    %[xs, ys] = meshgrid(-1.5:0.1:2.5, -3:0.1:1);
    %v = double(subs(p_field, {x, y}, {xs, ys}));
    
    %contour(xs, ys, v, 'k', 'ShowText', 'On');
    %axis equal
    
    grad = gradient(p_field, [x, y]);
    grad = double(subs(grad, {x, y}, {position(1), position(2)}))';
    
    %plot(line_inliers(:, 1), line_inliers(:, 2), 'bo');
    %plot(circle_inliers(:, 1), circle_inliers(:, 2), 'g.');
    
    %plot(position(1), position(2), 'rx')
    %quiver(position(1), position(2), position(1) + heading(1), position(2) + heading(2))

    grad = grad * 0.03 * (0.5 ^ (save_i-1));
    [position, heading] = drive(grad, position, heading)
    
    all_positions(end+1,:) = position;
    pause(0.1);
end