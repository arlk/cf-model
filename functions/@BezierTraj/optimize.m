% Arun Lakshmanan
% Bezier spline optimization
function res = optimize(bt)
  options = optimset('Display', 'off', 'MaxIter', bt.iterations);
  T = bt.init_time*ones(1, length(bt.waypts)-2)/(length(bt.waypts)-1);
  res = fminsearch(@bt.cost3bez, T, options);
  bt.Tratio = [res bt.init_time-sum(res)]/bt.init_time;
end
