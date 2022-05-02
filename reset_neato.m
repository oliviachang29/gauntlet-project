function reset_neato()

pub = rospublisher('/raw_vel');
msg = rosmessage(pub);
msg.Data = [0 0];

send(pub, msg)

placeNeato(0, 0, 1, 0);
pause(2);

end