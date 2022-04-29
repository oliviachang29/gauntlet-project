function [potential_field] = generate_potential_field(inliers, potential_field)
% GENERATE_POTENTIAL_FIELD Generate and upate the potential field from
% RANSAC data
%   [potential_field] = generate_potential_field(model, potential_field)
%   updates the pontential_field with the model output from RANSAC.
%   Initialize potential_field = 0.

syms x y

for i=1:length(inliers)
    potential_field = potential_field + ln(sqrt((x-inliers(1))^2 + (y-inliers(2))^2));
end

end