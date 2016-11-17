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
bt.phi = BezierCurve(phi_wp, bt.der);
bt.phi.costbez(bt.Tratio);
bt.phi_cp = bt.phi.M_inv*bt.phi.a;

bt.ders(1);
t_p = 0;
bt.u1_max_t = fminbnd(@(t) (-bt.u1(bt.update_ders(t))), 0, 1, options);
bt.u2_max_t = fminbnd(@(t) (-abs(bt.u2(bt.rates(bt.update_ders(t))))), 0, 1, options);
bt.u3_max_t = fminbnd(@(t) (-abs(bt.u3(bt.rates(bt.update_ders(t))))), 0, 1, options);

k_res = fmincon(@(k) k, 1, [], [], [], [], 0.01, 100, @bt.feasible, options);
k_res
end
