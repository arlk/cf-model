%% Pre-setup {{{
clear;
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



waypts = [  -10 0 0; ...
            -5 10 0; ...
            5 10 0;...
            10 0 0];
z = zeros(size(waypts));

N_wpts = size(waypts,1);
        
obsarray = {};

segs = N_wpts - 1;

iters = 100;
% %% Solve {{{
for iter = 1:length(iters)
tic;

N = 9;
R = 1;
final_cost = inf;
N_var_pts=N_wpts-2;
total = N^2*N_var_pts;

for i=0:N-1
  for j=0:N-1
      for k=1:N_var_pts;   
          
        z(k+1,:) = R*[i/N j/N 0];
        
        bez = BezierTraj(waypts+z, min_der, iters(iter), cf2);
        res = bez.optimize();

          COST = bez.cost3bez(res);
          if final_cost>COST
              final_cost    = COST;
              final_res     = res;
              final_waypts  = bez.waypts;
              final_cp      = bez.bez_cp;
          end
          if 0==i && 0==j && 1==k
              initial_cost   = COST;
              initial_res    = res;
              initial_waypts = bez.waypts;
              initial_cp     = bez.bez_cp;
          end
      end
  end
  disp(i+1);
end

% bez = BezierTraj(waypts, min_der, iters(iter), cf2);
% options = optimoptions('fmincon','Algorithm',...
%             'interior-point','MaxIterations',bez.iterations,'Display','off');
% res = fmincon(@bez.optimize, T, [], [], [], [], lb, ub,[],options);        
toc


traj = final_cp;


%% }}}

%% Plotting tools {{{

%% Plot Waypoint Regions {{{
for i = 2:N_var_pts+1;
    regions = [waypts(i,:)+[-R -R 0];...
                waypts(i,:)+[R -R 0];...
                waypts(i,:)+[R R 0];...
                waypts(i,:)+[-R R 0]];

    patch('Faces',1:4,'Vertices',regions(:,1:2),...
        'FaceColor','k','FaceAlpha',.2)
end
%%% }}}

%% Plot trajectory {{{
%   Final
subplot(ceil(sqrt(length(iters))),floor(sqrt(length(iters))),iter);

prev_ts = 0;
for k = 0:(segs-1)
  hold on;
  ts = prev_ts+bez.Tratio(k+1);
  tvec = linspace(prev_ts,ts, 50);
  plt = gen_bezier(tvec',final_cp(k*bcps+1:bcps*(k+1),:));

  plot3(plt(:,1),plt(:,2),plt(:,3), ...
  'Color',[.2 .2 .2], 'LineWidth', 2.0);
  prev_ts = ts;
end

%   Initial
for k = 0:(segs-1)
  hold on;
  ts = prev_ts+bez.Tratio(k+1);
  tvec = linspace(prev_ts,ts, 50);
  plt = gen_bezier(tvec',initial_cp(k*bcps+1:bcps*(k+1),:));

  plot3(plt(:,1),plt(:,2),plt(:,3), ...
  'Color',[.2 .2 .2], 'LineWidth', 2.0);
  prev_ts = ts;
end
%%% }}}

%% Plot Obstacle {{{
for i=1:length(obsarray)
      patch(obsarray{i}(:,1),obsarray{i}(:,2),[.5 .5 .5])
end
axis tight;
%%% }}}

%% Plot wp and ctrl pts {{{
% hold on;
scatter3(final_cp(:,1), final_cp(:,2), final_cp(:,3), 16, 'k', ...
'filled', 'MarkerEdgeColor', 'k');
title_string  = sprintf('n = %d',iters(iter));
% title(title_string);
grid on;
box on;
hold on;
scatter3(initial_waypts(:,1), initial_waypts(:,2),initial_waypts(:,3), 56, 'k', 'o', 'filled',...
'MarkerFaceColor', [1 1 1],'MarkerEdgeColor','k');
scatter3(final_waypts(:,1), final_waypts(:,2),final_waypts(:,3), 56, 'k', 's', 'filled',...
'MarkerFaceColor', [1 1 1],'MarkerEdgeColor','k');

%%% }}}
xlabel('X (m)');
ylabel('Y (m)');

end
