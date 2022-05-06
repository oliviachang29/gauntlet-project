function [position, heading] = drive(v, position, heading)

angular_speed = 0.2;
linear_speed  = 0.5;
wheel_base    = 0.235;
lambda        = 1;

pub = rospublisher('/raw_vel');
msg = rosmessage(pub);

prod  = cross([heading 0], [v 0]);
dir   = sign(prod(3));
angle = acos(dot(v, heading) / (norm(v) * norm(heading)));%asin(norm(prod) / (norm(heading) * norm(v)));
time  = double(angle) / angular_speed;
msg.Data = [-dir*angular_speed*wheel_base/2 dir*angular_speed*wheel_base/2];
send(pub, msg);
start = rostic;
while rostoc(start) < time
    pause(0.01);
end

dist = norm(v * lambda);
time = dist / linear_speed;
msg.Data = [linear_speed linear_speed];
send(pub, msg);
start = rostic;
while rostoc(start) < time
    pause(0.01);
end

msg.Data = [0 0];
send(pub, msg);

position = position + v*lambda;
heading  = v / norm(v);

end