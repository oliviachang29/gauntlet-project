function gradient_descent(potential_field)
% GRADIENT_DESCENT Run one step of gradient descent.
%   gradient_descent(potential_field) Uses the potential field to calculate
%   the gradient. Instructs the Neato to rotate and drive according to the
%   gradient. Position is stored in an internal state.

persistent position
if isempty(position)
    position = [0 0];
end

syms x y
grad = gradient(potential_field, [x y]);

v = subs(grad, [x y], position);
rotate(v);
drive(v);

end