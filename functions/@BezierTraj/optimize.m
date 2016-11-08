% Arun Lakshmanan
% Bezier spline optimization
function res = optimize(bt)
  options = optimset('Display', 'off', 'MaxIter', bt.iterations);
  T = ones(1, length(bt.waypts)-2)/(length(bt.waypts)-1);
  res = fminsearch(@bt.cost3bez, T, options);
  bt.Tratio = [res 1-sum(res)];
end
