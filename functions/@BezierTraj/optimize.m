% Arun Lakshmanan
% Bezier spline optimization
function res = optimize(bt)
% options = optimset('Display', 'off', 'MaxIter', bt.iterations);
options = optimoptions('fmincon','Algorithm','interior-point','MaxIterations',bt.iterations,'Display','off');
%iter-detailed
T = 1*ones(1, size(bt.waypts,1)-1)/(size(bt.waypts,1)-1);
% res = fminsearch(@bt.cost3bez, T, options);
A = [];
b = [];
Aeq = ones(1, size(bt.waypts,1)-1);
beq = 1;
% HACK
lb = ones(1, size(bt.waypts,1)-1)*0.01;
ub = ones(1, size(bt.waypts,1)-1)*0.99;

res = fmincon(@bt.cost3bez, T, A, b, Aeq, beq, lb, ub,[] , options);

bt.Tratio = res;


bt.bez_cp = [bt.x.a ...
              bt.y.a ...
              bt.z.a];

end