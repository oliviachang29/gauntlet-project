function rotate(v)
% ROTATE Rotate the robot. Heading is saving in an internal
% state.
%   rotate(v) Rotates to align the heading with v.

persistent heading
if isempty(heading)
    heading = [1 0];
end

angular_speed = 0.2;

pub = rospublisher('/raw_vel');
msg = rosmessage(pub);

prod  = cross([heading ; 0], [v ; 0]);
dir   = sign(prod);
angle = asin(norm(prod) / norm(heading) * norm(v));
time  = double(angle) / angular_speed;
msg.Data = [-dir*angular_speed*wheel_base/2; dir*angular_speed*wheel_base/2];
send(pub, msg);
start = rostic;
while rostoc(start) < time
    pause(0.01);
end

end