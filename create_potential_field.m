function [p_field] = create_potential_field(line_inliers, circle_inliers)

syms x y

p_field = 0;

for i=1:length(line_inliers)
    p_field = p_field + log(sqrt((x-line_inliers(1))^2 + (y-line_inliers(2))^2));
end

for i=1:length(circle_inliers)
    p_field = p_field - log(sqrt((x-circle_inliers(1))^2 + (y-circle_inliers(2))^2));
end

end