% Arun Lakshmanan
% Calculate costs for 3D minimum energy bezier spline
function J = cost3bez(bt, T)
  Jx = bt.x.costbez(T);
  Jy = bt.y.costbez(T);
  Jz = bt.z.costbez(T);
  J = Jx+Jy+Jz;
end
