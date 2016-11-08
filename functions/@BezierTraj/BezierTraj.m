% Arun Lakshmanan
% Initialize costs for minimum energy bezier spline
classdef BezierTraj < handle
  properties
    waypts
    x
    y
    z
    phi
    Tratio
    kT
    init_time
    iterations
  end
  methods
    function bt = BezierTraj(waypts, der, penalty, total_time, iterations)
      bt.waypts = waypts;
      bt.x = BezierCurve(waypts(:,1), der);
      bt.y = BezierCurve(waypts(:,2), der);
      bt.z = BezierCurve(waypts(:,3), der);
      bt.kT = penalty;
      bt.init_time = total_time;
      bt.iterations = iterations;
    end
    res = optimize(bt)
    f = cost3bez(bt, x)
  end
end

% vim:foldmethod=marker:foldlevel=0

