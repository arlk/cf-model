% Arun Lakshmanan
% Initialize costs for minimum energy bezier spline
classdef BezierTraj < handle
  properties
    waypts
    bez_cp
    x
    y
    z
    phi
    phi_cp
    der
    Tratio
    iterations
    x_ders
    y_ders
    z_ders
    phi_ders
    u1_max_t
    u2_max_t
    u3_max_t
    veh
    k_res
  end
  methods
    function bt = BezierTraj(waypts, der, iterations, model)
      bt.waypts = waypts;
      bt.x = BezierCurve(waypts(:,1), der);
      bt.y = BezierCurve(waypts(:,2), der);
      bt.z = BezierCurve(waypts(:,3), der);
      bt.der = der;
      bt.iterations = iterations;
      bt.veh = model;
    end
    res = optimize(bt)
    f = cost3bez(bt, x)
    [c, ceq] = collide(bt, x)
    wp = get_phi_wp(bt)
    [c, ceq] = feasible(bt, k)
    ders(bt, kT)
    flag = GJK(bt, shape1,shape2,iterations)
  end
  methods(Static)
      function c = compMinDistBezierPoly_mex(a,b,c,d,e,f,g)
          c=compMinDistBezierPoly_mex(a,b,c,d,e,f,g);
      end
  end
end


% vim:foldmethod=marker:foldlevel=0

