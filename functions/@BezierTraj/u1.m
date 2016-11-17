function u = u1(bt, der)
thrust = [der(1, 3) der(2, 3) der(3, 3)+bt.veh.Gravity];
u = bt.veh.Mass*norm(thrust);
end
