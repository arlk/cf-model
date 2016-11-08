% Arun Lakshmanan
% Calculate costs for 3D minimum energy bezier spline
function f = cost3bez(bt, x)
  % Expanding time for last step:
  x = [x 1-sum(x)];

  Jx = bt.x.costbez(x);
  Jy = bt.y.costbez(x);
  Jz = bt.z.costbez(x);
  f = Jx+Jy+Jz;
end
