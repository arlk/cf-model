%% Pre-setup {{{
clear all;
addpath('../');
addpath('../bezier_utils');
addpath('../model_utils');
addpath('/home/arun/git_projs/matlab2tikz/src');
%%% }}}

%% Setup {{{
num_pts = 5;
min_der = 4;

crazyflie;

bcps = min_der*2+2;
waypts = [ 0 0 0; ...
           1 2 0; ...
           2 1 0; ...
           3 3 0; ...
           5 -2 0 ];
segs = size(waypts,1) - 1;
%%% }}}
iters = [0 1 2 4 8 12];
% %% Solve {{{
for iter = 1:6
tic;
bez = BezierTraj(waypts, min_der, iters(iter), cf2);
bez.optimize();
toc
% bez.Tratio
traj = bez.bez_cp;
%%% }}}

%% Plotting tools {{{
%% Plot trajectory {{{
subplot(3,2,iter);
% figure;
trajplot = [];
prev_ts = 0;
blue = [0 0.4470 0.7410];
yellow = [0.9290 0.6940 0.1250];
orange = [0.8500 0.3250 0.0980];
green = [0.4660 0.6740 0.1880];
red = [0.6350 0.0780 0.1840];
for k = 0:(segs-1)
  hold on;
  ts = prev_ts+bez.Tratio(k+1);
  tvec = linspace(prev_ts,ts, 50);
  plt = gen_bezier(tvec',traj(k*bcps+1:bcps*(k+1),:));
  trajplot = [trajplot; plt];
  plot3(plt(:,1),plt(:,2),plt(:,3), ...
  'Color', blue, 'LineWidth', 2.0);
  prev_ts = ts;
end
axis tight;
%%% }}}

%% Plot wp and ctrl pts {{{
% hold on;
scatter3(traj(:,1), traj(:,2), traj(:,3), 16, yellow, ...
'filled', 'MarkerEdgeColor', 'k');
title_string  = sprintf('n = %d',iters(iter));
title(title_string);
grid on;
box on;
hold on;
scatter3(waypts(:,1), waypts(:,2), waypts(:,3), 56, orange, 's', 'filled');
xlim([-1 6]);
ylim([-3 4]);
% grid on;
% hold on;
%%% }}}
xlabel('X (m)');
ylabel('Y (m)');
set(gca,'Xtick',-16:2:16);
set(gca,'Ytick',-16:2:16);
end

% figure;
% ax = gca;
% ax.ColorOrderIndex = 1;
% for k = 1:segs
%   hold on;
%   plot(waypts(k:k+1,1),waypts(k:k+1,2), 'LineWidth', 1.25);
% end
% hold on;
% scatter(waypts(:,1), waypts(:,2), 36, 'r', 'filled');
% xlim([-1 6]);
% ylim([-3 4]);

% %% Plot phi quivers {{{
% q = quiver3(bez.waypts(:,1), bez.waypts(:,2), bez.waypts(:,3), ...
%         cos(bez.waypts(:,4)), sin(bez.waypts(:,4)), zeros(5, 1));
%
% q.LineWidth = 1.5;
% q.MaxHeadSize = 0.2;
% q.Color = 'r';
% q.AutoScaleFactor = 0.1;
% %%% }}}

% axis tight

% %% Plot phi trajectory {{{
% % figure;
% subplot(4,1,1);
% prev_ts = 0;
% for k = 0:(segs-1)
%   grid on
%   hold on
%   box on
%   ts = prev_ts+bez.Tratio(k+1);
%   tvec = linspace(prev_ts,ts, 50);
%   plt = gen_bezier(tvec',bez.bez_cp(k*bcps+1:bcps*(k+1),1));
%   plot(tvec, plt, ...
%   'Color',blue,'LineWidth', 1.5);
%   ylabel('$x_d$','FontSize', 22,'interpreter','latex');
%   prev_ts = ts;
% end
% subplot(4,1,2);
% prev_ts = 0;
% for k = 0:(segs-1)
%   grid on
%   hold on;
%   box on
%   ts = prev_ts+bez.Tratio(k+1);
%   tvec = linspace(prev_ts,ts, 50);
%   plt = gen_bezier(tvec',bez.bez_cp(k*bcps+1:bcps*(k+1),2));
%   plot(tvec, plt, ...
%   'Color',blue,'LineWidth', 1.5);
%   ylabel('$y_d$','FontSize', 22,'interpreter','latex');
%   prev_ts = ts;
% end
% subplot(4,1,3);
% prev_ts = 0;
% for k = 0:(segs-1)
%   grid on
%   hold on;
%   box on
%   ts = prev_ts+bez.Tratio(k+1);
%   tvec = linspace(prev_ts,ts, 50);
%   plt = gen_bezier(tvec',bez.bez_cp(k*bcps+1:bcps*(k+1),3));
%   plot(tvec, plt, ...
%   'Color',blue,'LineWidth', 1.5);
%   ylabel('$z_d$','FontSize', 22,'interpreter','latex');
%   prev_ts = ts;
% end
% subplot(4,1,4);
% prev_ts = 0;
% for k = 0:(segs-1)
%   grid on
%   hold on;
%   box on
%   ts = prev_ts+bez.Tratio(k+1);
%   tvec = linspace(prev_ts,ts, 50);
%   plt = gen_bezier(tvec',bez.phi_cp(k*bcps+1:bcps*(k+1),:));
%   plot(tvec, plt, ...
%   'Color',blue,'LineWidth', 1.5);
%   ylabel('$\phi_d$','FontSize', 22,'interpreter','latex');
%   xlabel('Time (s)');
%   prev_ts = ts;
% end
% %%% }}}
% %% Plot controls {{{
% u1=[];
% for t = 0:0.001:1
%   u1 = [u1; bez.u1(bez.update_ders(t))];
% end
%
% u2=[];
% for t = 0:0.001:1
%   u2 = [u2; bez.u2(bez.rates(bez.update_ders(t)))];
% end
%
% u3=[];
% for t = 0:0.001:1
%   u3 = [u3; bez.u3(bez.rates(bez.update_ders(t)))];
% end
%
% u4=[];
% for t = 0:0.001:1
%   u4 = [u4; bez.u4(bez.rates(bez.update_ders(t)))];
% end
%
% tvec = bez.k_res*(0:0.001:1);
%
% subplot(4,1,1);
% grid on
% hold on
% box on
% plot(tvec, u1, ...
% 'Color',blue,'LineWidth', 1.5);
% ylabel('$u_f$','FontSize', 22,'interpreter','latex');
% set(gca,'Xtick',0:2:10);
%
% subplot(4,1,2);
% grid on
% hold on
% box on
% plot(tvec, u2, ...
% 'Color',blue,'LineWidth', 1.5);
% ylabel('$u_\phi$','FontSize', 22,'interpreter','latex');
% set(gca,'Xtick',0:2:10);
%
% subplot(4,1,3);
% grid on
% hold on
% box on
% plot(tvec, u3, ...
% 'Color',blue,'LineWidth', 1.5);
% ylabel('$u_\theta$','FontSize', 22,'interpreter','latex');
% set(gca,'Xtick',0:2:10);
%
% subplot(4,1,4);
% grid on
% hold on
% box on
% plot(tvec, u4, ...
% 'Color',blue,'LineWidth', 1.5);
% ylabel('$u_\psi$','FontSize', 22,'interpreter','latex');
% xlabel('Time (s)');
% set(gca,'Xtick',0:2:10);
% %%% }}}
% %% }}}
matlab2tikz('../../temp_opt.tex');
% vim:foldmethod=marker:foldlevel=0
