function [points] = datasample(data, k, ~, ~)
% Sample row-major vector with replacement (I don't have the toolkit :[ )

i = randi(length(data), [k 1]);
points = data(i, :);

end