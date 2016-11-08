%% Setup {{{
clear all;
num_pts = 5;
min_der = 4;

bcps = min_der*2+2;
waypts = rand(num_pts,3);
segs = size(waypts,1) - 1
%%% }}}

%% Solve {{{
bez = BezierTraj(waypts, min_der, segs*bcps);
bez.optimize();
bez.Tratio
traj = [bez.x.M_inv*bez.x.a  bez.y.M_inv*bez.y.a bez.z.M_inv*bez.z.a];
%%% }}}

%% Plot {{{
figure;
trajplot = [];
for k = 0:(segs-1)
  hold on;
  plt = gen_bezier((0:.01:1)',traj(k*bcps+1:bcps*(k+1),:));
  trajplot = [trajplot; plt];
  plot3(plt(:,1),plt(:,2),plt(:,3));
end
hold on;
scatter3(traj(:,1), traj(:,2), traj(:,3), 16, 'g', 'filled');
hold on;
scatter3(waypts(:,1), waypts(:,2), waypts(:,3), 36, 'r', 'filled');
%%% }}}
