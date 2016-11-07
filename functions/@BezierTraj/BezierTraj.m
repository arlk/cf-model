% Arun Lakshmanan
% Initialize costs for minimum energy bezier spline
classdef BezierTraj < handle
  properties
    x
    y
    z
    phi
    T
  end
  methods
    function bt = BezierTraj(waypts, der)
      bt.x = BezierCurve(waypts(:,1), der);
      bt.y = BezierCurve(waypts(:,2), der);
      bt.z = BezierCurve(waypts(:,3), der);
      bt.T = [1 1 1];
    end
    % res = minbez(bt, T)
    J = cost3bez(bt, T)
  end
end

% vim:foldmethod=marker:foldlevel=0

