function u = u4(bt, w)
u = - bt.veh.Inertia(1, 1)*w(1, 1)*w(1, 2) ...
  + bt.veh.Inertia(2, 2)*w(1, 1)*w(1, 2) ...
  + bt.veh.Inertia(3, 3)*w(2, 3);
end
