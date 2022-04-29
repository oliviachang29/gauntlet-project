function [r, theta] = scan()
    sub = rossubscriber('/scan');
    % assume neato is already in the right place
    % collect data at current neato location
    scan_message = receive(sub);
    r = scan_message.Ranges(1:end-1);
    theta = deg2rad([0:359]');
    
    % filter out zeros
    index = find(r~=0 & r<3);
    r = r(index);
    theta = theta(index);
end