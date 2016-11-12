% Arun Lakshmanan
% Bezier spline optimization
function res = optimize(bt)
  options = optimset('Display', 'off', 'MaxIter', bt.iterations);
  T = ones(1, size(bt.waypts,1)-2)/(size(bt.waypts,1)-1);
  res = fminsearch(@bt.cost3bez, T, options);
  bt.Tratio = [res 1-sum(res)];

  bt.bez_cp = [bt.x.M_inv*bt.x.a ...
                bt.y.M_inv*bt.y.a ...
                bt.z.M_inv*bt.z.a];


  phi_wp = bt.get_phi_wp();
  bt.waypts = [bt.waypts phi_wp];
  bt.phi = BezierCurve(phi_wp, bt.yder);
  bt.phi.costbez(bt.Tratio);
  bt.phi_cp = bt.phi.M_inv*bt.phi.a;

  % phi_wp(bt.x,
end
