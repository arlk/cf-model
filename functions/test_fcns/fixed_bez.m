%% Pre-setup {{{
clear;
clc;
fprintf('main...\n\n');
addpath('../');
addpath('../bezier_utils');
addpath('../model_utils');
%%% }}}
warning ('off','all');
cmap = lines;
%% Setup {{{
min_der = 4;

crazyflie;

bcps = min_der*2+2;

rng(15);

waypts = [  -10 0 0; ...
            -5 10 0; ...
%             0 12.3 0;
            5 10 0;...
            10 4 0];

% waypts = [  -10 0 0; ...
%             -5 5 0; ...
%             5 10 0;...
%             10 12 0];

z = zeros(size(waypts));

N_wpts = size(waypts,1);
        
obsarray = {};
obsdetarray = {};
obst;

segs = N_wpts - 1;

iters = 100;
% %% Solve {{{
for iter = 1:length(iters)
tic;

N = 1;
R = 2;
final_cost = inf;
tempwaypts = zeros(size(waypts));

z = [0 0 0;
    0 1 0;
    1 1 0;
    1 0 0;
    1 -1 0;
    0 -1 0;
    -1 -1 0;
    -1 0 0;
    -1 1 0];

if N>length(z)
    z=[z;[2*(rand(N-length(z),2)-.5) zeros(N-length(z),1)]];
end

N_var_pts=N_wpts-2;
total = N^2*N_var_pts;

for i=1:N
    for k=1:N_var_pts;   
            
        tempwaypts(k+1,:)=R*z(i,:);
       
        bez = BezierTraj(waypts+tempwaypts, min_der, iters(iter), cf2);
        res = bez.optimize();

        COST = bez.cost3bez(res);
        if final_cost>COST
            final_cost    = COST;
            final_res     = res;
            final_waypts  = bez.waypts;
            final_cp      = bez.bez_cp;
        end
        if 1==i && 1==k
            initial_cost   = COST;
            initial_res    = res;
            initial_waypts = bez.waypts;
            initial_cp     = bez.bez_cp;
        end
    end
    disp((i)/N);
end

% bez = BezierTraj(waypts, min_der, iters(iter), cf2);
% options = optimoptions('fmincon','Algorithm',...
%             'interior-point','MaxIterations',bez.iterations,'Display','off');
% res = fmincon(@bez.optimize, T, [], [], [], [], lb, ub,[],options);        
toc


traj = final_cp;
ctp = final_cp;
res = final_res;


%% }}}

%% Plotting tools {{{
subplot(ceil(sqrt(length(iters))),floor(sqrt(length(iters))),iter);
hold on;
%% Plot Waypoint Regions {{{

for i = 2:N_var_pts+1;
    regions = [waypts(i,:)+[-R -R 0];...
                waypts(i,:)+[R -R 0];...
                waypts(i,:)+[R R 0];...
                waypts(i,:)+[-R R 0]];

%     patch('Faces',1:4,'Vertices',regions(:,1:2),...
%         'FaceColor','k','FaceAlpha',.2)
%     
%     scatter(R*z(:,1)+initial_waypts(i,1), R*z(:,2)+initial_waypts(i,2), 4, 'k', ...
%         'filled', 'MarkerEdgeColor', 'k');
end
%%% }}}

%% Plot trajectory {{{

%   Initial
N_plt_pts = 1000;
prev_ts = 0;
for k = 0:(segs-1)
  ts = prev_ts+bez.Tratio(k+1);
  tvec = linspace(prev_ts,ts, N_plt_pts);
  plt = gen_bezier(tvec',initial_cp(k*bcps+1:bcps*(k+1),:));

  plot3(plt(:,1),plt(:,2),plt(:,3), ...
  'Color',[.2 .2 .2], 'LineWidth', 2.0);
  prev_ts = ts;
end

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

%   Moved Points
prev_ts = 0;
plt=cell(1,segs);
tvec=cell(1,segs);
cltp=cell(1,segs);
for k = 0:(segs-1)
  ts = prev_ts+bez.Tratio(k+1);
  tvec{k+1} = linspace(prev_ts,ts, N_plt_pts);
  q = final_cp(k*bcps+1:bcps*(k+1),:);
    
  if k==0
      q(end-3:end,2)=q(end-3:end,2)+ones(4,1);
  end
  if k==1
      q(:,2)=q(:,2)+ones(length(q),1);
  end
  if k==2
      q(1:4,2)=q(1:4,2)+ones(4,1);
  end
  
  cltp{k+1} = q;
  plt{k+1} = gen_bezier(tvec{k+1}',cltp{k+1});
  
  plot3(plt{k+1}(:,1),plt{k+1}(:,2),plt{k+1}(:,3), ...
  'Color',[.2 .2 .2], 'LineWidth', 2.0);
  prev_ts = ts;
end
tvec_mvwpt = [tvec{1} tvec{2} tvec{3}];
plt_mvwpt = [plt{1};plt{2};plt{3}];
cltp_mvwpt = [cltp{1};cltp{2};cltp{3}];
%%% }}}

%% Plot Obstacle {{{
for i=1:length(obsarray)
      patch(obsarray{i}(:,1),obsarray{i}(:,2),[.2 .2 .2],'FaceAlpha',.8)
end

p1 = patch(obsdetarray{4}(:,1),obsdetarray{4}(:,2),[.9 .9 .9]);
patch(obsarray{4}(:,1),obsarray{4}(:,2),[.2 .2 .2],'FaceAlpha',.8)

%%% }}}

%% Plot wp and ctrl pts {{{
% hold on;
scatter3(final_cp(:,1), final_cp(:,2), final_cp(:,3), 16, 'k', ...
'filled', 'MarkerEdgeColor', 'k');
title_string  = sprintf('n = %d',iters(iter));
% title(title_string);

scatter3(initial_waypts(:,1), initial_waypts(:,2),initial_waypts(:,3), 56, 'k', 'o', 'filled',...
'MarkerFaceColor', [1 1 1],'MarkerEdgeColor','k');
scatter3(final_waypts(:,1), final_waypts(:,2),final_waypts(:,3), 56, 'k', 's', 'filled',...
'MarkerFaceColor', [1 1 1],'MarkerEdgeColor','k');

%%% }}}
grid on;
box on;
axis tight;
hold on;
xlabel('X (m)');
ylabel('Y (m)');


%% OBSTACLE AVOIDANCE {{{
uistack(p1,'bottom');
[col_wdw_pts,on] = inpolygon(plt_total(:,1),plt_total(:,2),obsdetarray{4}(:,1),obsdetarray{4}(:,2));
col_wdw_pts=col_wdw_pts|on;

[col_pts,on] = inpolygon(plt_total(:,1),plt_total(:,2),obsarray{4}(:,1),obsarray{4}(:,2));
col_pts=col_pts|on;

col_seg = ceil(find(col_wdw_pts,1)/N_plt_pts);

tstart = min(tvec{col_seg});
tend = max(tvec{col_seg});

g = @(x) (x-tstart)/(tend-tstart);

t_ws    = g(min(tvec_total(col_wdw_pts)));  
t_c     = g(min(tvec_total(col_pts)));
t_we    = g(max(tvec_total(col_wdw_pts)));

t_temp = linspace(0,1,N_plt_pts);

q = zeros(bcps,3);
q(5,:) = [0 .8 0];
avoid_ctp = final_cp((col_seg-1)*bcps+1:bcps*(col_seg),:)+5*q;
avoid_pth = gen_bezier(tvec{col_seg}',avoid_ctp);

avoid_ctp_total = [ctp(1:10,:);avoid_ctp;ctp(21:30,:)];

avoid_traj = BezierTraj(waypts, min_der, iters(iter), cf2);
avoid_traj.x.a=avoid_ctp_total(:,1);
avoid_traj.y.a=avoid_ctp_total(:,2);
avoid_traj.z.a=avoid_ctp_total(:,3);

Jx = avoid_traj.x.costbez_manual(res);
Jy = avoid_traj.y.costbez_manual(res);
J1=Jx+Jy;


%%% }}}
%% PLOT OBST AVOID {{{
plot(plt_total(col_wdw_pts,1),plt_total(col_wdw_pts,2),'Color',cmap(3,:));
plot(plt_total(col_pts,1),plt_total(col_pts,2),'Color',cmap(7,:));

plot3(avoid_pth(:,1),avoid_pth(:,2),avoid_pth(:,3), ...
    'Color',cmap(1,:), 'LineWidth', 2.0);
%%% }}}

%% COST WAYPOINT MOVE {{{
avoid2_traj = BezierTraj(waypts, min_der, iters(iter), cf2);
avoid2_traj.x.a=cltp_mvwpt(:,1);
avoid2_traj.y.a=cltp_mvwpt(:,2);
avoid2_traj.z.a=cltp_mvwpt(:,3);

Jx = avoid2_traj.x.costbez_manual(res);
Jy = avoid2_traj.y.costbez_manual(res);
J2=Jx+Jy;
 %%% }}}

fprintf('Cost Difference:\t%f\t%f\t%f\n',final_cost/final_cost,J1/final_cost,J2/final_cost);
fprintf('Time Distribution:\t%f\t%f\t%f\n',res);
end