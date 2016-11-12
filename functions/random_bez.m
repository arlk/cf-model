%% Setup {{{
clear all;
num_pts = 5;
min_der = 4;
yaw_der = 2;

bcps = min_der*2+2;
ybcps = yaw_der*2+2;
waypts = rand(num_pts,3);
% waypts = [ 0 0 0; ...
%            1 2 0; ...
%            2 1 0; ...
%            3 3 0; ...
%            4 -2 0 ];
segs = size(waypts,1) - 1;
%%% }}}

%% Solve {{{
tic;
bez = BezierTraj(waypts, min_der, yaw_der, segs*bcps);
bez.optimize();
toc
bez.Tratio
traj = bez.bez_cp;
%%% }}}

%% Plotting tools {{{
%% Plot trajectory {{{
figure;
trajplot = [];
prev_ts = 0;
for k = 0:(segs-1)
  hold on;
  ts = prev_ts+bez.Tratio(k+1);
  tvec = linspace(prev_ts,ts, 50);
  plt = gen_bezier(tvec',traj(k*bcps+1:bcps*(k+1),:));
  trajplot = [trajplot; plt];
  plot3(plt(:,1),plt(:,2),plt(:,3), 'LineWidth', 1.25);
  prev_ts = ts;
end
%%% }}}

%% Plot wp and ctrl pts {{{
hold on;
scatter3(traj(:,1), traj(:,2), traj(:,3), 16, 'g', 'filled');
hold on;
scatter3(waypts(:,1), waypts(:,2), waypts(:,3), 36, 'r', 'filled');
hold on;
%%% }}}

%% Plot phi quivers {{{
q = quiver3(bez.waypts(:,1), bez.waypts(:,2), bez.waypts(:,3), ...
        cos(bez.waypts(:,4)), sin(bez.waypts(:,4)), zeros(5, 1));

q.LineWidth = 1.5;
q.MaxHeadSize = 0.2;
q.Color = 'r';
q.AutoScaleFactor = 0.1;
%%% }}}

axis tight

%% Plot phi trajectory {{{
figure;
prev_ts = 0;
for k = 0:(segs-1)
  hold on;
  ts = prev_ts+bez.Tratio(k+1);
  tvec = linspace(prev_ts,ts, 50);
  plt = gen_bezier(tvec',bez.phi_cp(k*ybcps+1:ybcps*(k+1),:));
  plot(tvec, plt,'LineWidth', 1.25);
  prev_ts = ts;
end
%%% }}}
%%% }}}
% vim:foldmethod=marker:foldlevel=0
