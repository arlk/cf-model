%% Pre-setup {{{
close all;
clear;
clc;
fprintf('main...\n\n');
addpath('../');
addpath('../bezier_utils');
addpath('../model_utils');
%%% }}}
warning ('off','all');
cmap = lines;
figure;
hold on;
%% Setup {{{
min_der = 4;

crazyflie;

bcps = min_der*2+2;

rng(15);

waypts = [  -10 0 0; ...
            -10 15 0; ...
            0 12 0;...
            10 17 0];


z = zeros(size(waypts));
N_plt_pts = 1000;

N_wpts = size(waypts,1);
        
obsarray = {};
obsdetarray = {};
obst;

segs = N_wpts - 1;

iters = 100;
%% Solve {{{

tic;

bez = BezierTraj(waypts, min_der, iters, cf2);
res = bez.optimize();

COST = bez.cost3bez(res);        


final_cost    = COST;
final_res     = res;
final_waypts  = bez.waypts;
final_cp      = bez.bez_cp;

toc


traj = final_cp;
ctp = final_cp;
res = final_res;


%%% }}}

%% Plot trajectory {{{

%   Initial
%   Final
prev_ts = 0;
plt=cell(1,segs);
tvec=cell(1,segs);
cltp=cell(1,segs);
for k = 0:(segs-1)
  ts = prev_ts+bez.Tratio(k+1);
  tvec{k+1} = linspace(prev_ts,ts, N_plt_pts);
  cltp{k+1} = final_cp(k*bcps+1:bcps*(k+1),:);
  plt{k+1} = gen_bezier(tvec{k+1}',cltp{k+1});
    
  plot3(plt{k+1}(:,1),plt{k+1}(:,2),plt{k+1}(:,3), ...
  'Color',[.2 .2 .2], 'LineWidth', 2.0);
  prev_ts = ts;
end
tvec_total = [tvec{1} tvec{2} tvec{3}];
plt_total = [plt{1};plt{2};plt{3}];
cltp_total = [cltp{1};cltp{2};cltp{3}];

%%% }}}

%% ADD POST OPT OBSTACLES
%% Plot Obstacle {{{
for i=1:length(obsarray)
      p1 = patch(obsarray{i}(:,1),obsarray{i}(:,2),[.2 .2 .2],'FaceAlpha',.8/i);
      uistack(p1,'bottom')
end
%%% }}}

%% Plot wp and ctrl pts {{{

% Control Points
scatter3(final_cp(:,1), final_cp(:,2), final_cp(:,3), 16, 'k', ...
'filled', 'MarkerEdgeColor', 'k');

% Way Points
scatter3(final_waypts(:,1), final_waypts(:,2),final_waypts(:,3), 56, 'k', 's', 'filled',...
'MarkerFaceColor', [1 1 1],'MarkerEdgeColor','k');
%%% }}}
grid on;
box on;
axis equal;
hold on;
xlabel('X (m)');
ylabel('Y (m)');

%% Collision Detection {{{

col_idx_array=collision_check(plt_total,obsarray);
col_pts_array=cell(size(col_idx_array));

% Collision Locations
for i=1:length(col_idx_array)
    col_pts_array{i} = [plt_total(col_idx_array{i},1),plt_total(col_idx_array{i},2)];
    plot(col_pts_array{i}(:,1),col_pts_array{i}(:,2),'Color',cmap(7,:));
end
%%%}}

%% OBSTACLE AVOIDANCE {{{
% Collision Times
col_t_array = cell(size(col_idx_array));

for i=1:length(col_idx_array)
    % Time in collision with obstacle i
    col_t_array{i} = tvec_total(col_idx_array{i});
end

% Find collision start time
col_start_t_array = cell(size(col_t_array));
for i=1:length(col_t_array)
    col_start_t_array{i} = min(col_t_array{i});
end

% Find location on curve of collision
    % drop to first obstacle here
for i=1:length(col_t_array)
    col_start_t_array{i} = min(col_t_array{i});
end
%%%}}






















