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
[plt,tvec,cltp] = gen_pw_bez(final_cp,segs,res,N_plt_pts);

for k = 0:(segs-1)
  plot3(plt{k+1}(:,1),plt{k+1}(:,2),plt{k+1}(:,3), ...
  'Color',[.2 .2 .2], 'LineWidth', 2.0);
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

% Find collision start time and segment
col_start_t_array = cell(size(col_t_array));
col_seg = cell(size(col_t_array));
for i=1:length(col_t_array)
    % Start time
    col_start_t_array{i} = min(col_t_array{i});
    
    % Start segment
    for j=1:segs
        if min(tvec{j})<=col_start_t_array{i}...
                && col_start_t_array{i}<=max(tvec{j})
            col_seg{i}=j;
        end
    end
end

% Find location on curve of collision
    % drop complexity to just first obstacle here
    col_t = min(col_start_t_array{:});
    d_ctl = gen_detour(col_t,tvec_total);

    cltp_mvwpt = cltp_total;
    
    cltp_mvwpt = cltp_mvwpt-[d_ctl,d_ctl,zeros(bcps*segs,1)];

    [plt2,tvec2,cltp2] = gen_pw_bez(cltp_mvwpt,segs,res,N_plt_pts);

    for k = 0:(segs-1)
      plot3(plt2{k+1}(:,1),plt2{k+1}(:,2),plt2{k+1}(:,3), ...
      'Color',[.2 .2 .2], 'LineWidth', 2.0);
    end

%%%}}






















