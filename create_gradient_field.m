function [g_field] = create_gradient_field(line_inliers, circle_inliers)

syms x y
g_field = [0 0];

for i=1:length(line_inliers)
    a = line_inliers(i, 1);
    b = line_inliers(i, 2);
    d = (x-a)^2 + (y-b)^2;
    
    g_field = g_field + [(x-a)/d (y-b)/d];
end

for i=1:length(circle_inliers)
    a = circle_inliers(i, 1);
    b = circle_inliers(i, 2);
    d = -(x-a)^2 + (y-b)^2;
    
    g_field = g_field + [(x-a)/d (y-b)/d];
end

end