% Arun Lakshmanan
% Bezier spline optimization
function res = optimize(bt)
% options = optimset('Display', 'off', 'MaxIter', bt.iterations);
options = optimoptions('fmincon','Algorithm','interior-point','MaxIterations',bt.iterations,'Display','iter-detailed');
T = 1*ones(1, size(bt.waypts,1)-1)/(size(bt.waypts,1)-1);
% res = fminsearch(@bt.cost3bez, T, options);
A = [];
b = [];
Aeq = ones(1, size(bt.waypts,1)-1);
beq = 1;
% HACK
lb = ones(1, size(bt.waypts,1)-1)*0.01;
ub = ones(1, size(bt.waypts,1)-1)*0.99;
nonlcon = [];



    
% res = fmincon(@bt.cost3bez, T, A, b, Aeq, beq, lb, ub,@bt.collide, options);
res = fmincon(@bt.cost3bez, T, A, b, Aeq, beq, lb, ub,[] , options);

COST = bt.cost3bez(res)
RES = res
bt.Tratio = res;

bt.bez_cp = [bt.x.a ...
              bt.y.a ...
              bt.z.a];

% phi_wp = bt.get_phi_wp();
% bt.waypts = [bt.waypts phi_wp];
% bt.phi = BezierCurve(phi_wp, bt.der);
% bt.phi.costbez(bt.Tratio);
% bt.phi_cp = bt.phi.a;
% bt.phi_cp = zeros(size(bt.waypts,1)-1)*4
%
% bt.ders(1);
% t_p = 0;
% bt.u1_max_t = fminbnd(@(t) (-bt.u1(bt.update_ders(t))), 0, 1, options);
% bt.u2_max_t = fminbnd(@(t) (-abs(bt.u2(bt.rates(bt.update_ders(t))))), 0, 1, options);
% bt.u3_max_t = fminbnd(@(t) (-abs(bt.u3(bt.rates(bt.update_ders(t))))), 0, 1, options);
%
% bt.k_res = fmincon(@(k) k, 1, [], [], [], [], 0.01, 10, @bt.feasible, options);
% bt.k_res
end
