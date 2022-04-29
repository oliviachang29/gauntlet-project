function drive(v)
% DRIVE Drive the Neato forwardv
%   drive(v) Drives for the length of v

linear_speed  = 0.75;

% Drive forward for a bit
dist = norm(grad);
time = dist / linear_speed;
msg.Data = [linear_speed, linear_speed];
send(pub, msg);
start = rostic;
while rostoc(start) < time
    pause(0.01);
end

% Stop
msg.Data = [0 0];
send(msg, pub)

end