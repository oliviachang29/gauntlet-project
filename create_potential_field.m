function [potential_field] = create_potential_field(inliers, potential_field)

syms x y

for i=1:length(inliers)
    potential_field = potential_field + ln(sqrt((x-inliers(1))^2 + (y-inliers(2))^2));
end

end