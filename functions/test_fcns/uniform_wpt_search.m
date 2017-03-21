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
figure;
hold on;
%% Setup {{{
min_der = 4;

crazyflie;

bcps = min_der*2+2;

rng(15);

waypts = [  -10 0 0; ...
            -10 15 0; ...
%             0 12.3 0;
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
% %% Solve {{{
for iter = 1:length(iters)
tic;

N_max = 50;
R = 2;
final_cost = inf;
tempwaypts = zeros(size(waypts));

[x,y]=meshgrid(-1:1,-1:1);
z = [reshape(x,[9,1]) reshape(y,[9,1])];
z=circshift(z,ceil(length(z)/2),1);
z=[z zeros(length(z),1)];

% if N>length(z)
%     z=[z;[2*(rand(N-length(z),2)-.5) zeros(N-length(z),1)]];
% end
N = length(z);
N_var_pts=N_wpts-2;
total = N^2*N_var_pts;
col_pts_array = cell(length(obsarray),1);
startwaypts = waypts;

sarray = [1 2 3 4 5];

for n = 1:length(sarray)
for i=1:N
    for k=1:N_var_pts;   
         
        tempwaypts(k+1,:)=R*z(i,:)/sarray(n);
       
        bez = BezierTraj(startwaypts+tempwaypts, min_der, iters(iter), cf2);
        res = bez.optimize();
        
        COST = bez.cost3bez(res);
        
        % Generate path
        prev_ts = 0;
        plt_total=zeros(segs*N_plt_pts,3);
        for m = 0:(segs-1)
            ts = prev_ts+bez.Tratio(m+1);
            tvec = linspace(prev_ts,ts, N_plt_pts);
            ctp_temp = [bez.x.a bez.y.a bez.z.a];
            plt = gen_bezier(tvec',ctp_temp(m*bcps+1:bcps*(m+1),:));
            plt_total(m*N_plt_pts+1:N_plt_pts*(m+1),:)=plt;
            prev_ts = ts;
        end
        
        % Check for Collision
        col_tf = 0;
        for j=1:length(obsarray)
            [col_pts,on] = ...
                inpolygon(plt_total(:,1),plt_total(:,2),...
                obsarray{j}(:,1),obsarray{j}(:,2));
            if any(col_pts)
                COST = inf;
            end
        end
        
        

        if final_cost>=COST
            final_cost    = COST;
            final_res     = res;
            final_waypts  = bez.waypts;
            final_cp      = bez.bez_cp;
        end
        if 1==i && 1==k && n==1
            initial_cost   = COST;
            initial_res    = res;
            initial_waypts = bez.waypts;
            initial_cp     = bez.bez_cp;
        end
    end
    disp(i);
end
end
toc


traj = final_cp;
ctp = final_cp;
res = final_res;


%% }}}

%% Plotting tools {{{
% subplot(ceil(sqrt(length(iters))),floor(sqrt(length(iters))),iter);
% hold on;
%% Plot Waypoint Regions {{{

for i = 2:N_var_pts+1;
    regions = [waypts(i,:)+[-R -R 0];...
                waypts(i,:)+[R -R 0];...
                waypts(i,:)+[R R 0];...
                waypts(i,:)+[-R R 0]];

    patch('Faces',1:4,'Vertices',regions(:,1:2),...
        'FaceColor','k','FaceAlpha',.2)
    
    scatter(R*z(:,1)+initial_waypts(i,1), R*z(:,2)+initial_waypts(i,2), 4, 'k', ...
        'filled', 'MarkerEdgeColor', 'k');
    
    for j = 1:length(sarray)
        scatter(R*z(:,1)/sarray(j)+initial_waypts(i,1),...
        R*z(:,2)/sarray(j)+initial_waypts(i,2), 4, 'k', ...
        'filled', 'MarkerEdgeColor', 'k');
    end
end
%%% }}}

%% Plot trajectory {{{

%   Initial
prev_ts = 0;
plt=cell(1,segs);
tvec=cell(1,segs);
cltp=cell(1,segs);
for k = 0:(segs-1)
  ts = prev_ts+bez.Tratio(k+1);
  tvec{k+1} = linspace(prev_ts,ts, N_plt_pts);
  cltp{k+1} = initial_cp(k*bcps+1:bcps*(k+1),:);
  plt{k+1} = gen_bezier(tvec{k+1}',cltp{k+1});
    
  plot3(plt{k+1}(:,1),plt{k+1}(:,2),plt{k+1}(:,3), ...
  'Color',[.2 .2 .2], 'LineWidth', 2.0);
  prev_ts = ts;
end
tvec_init = [tvec{1} tvec{2} tvec{3}];
plt_init = [plt{1};plt{2};plt{3}];
cltp_init = [cltp{1};cltp{2};cltp{3}];

for i=1:length(obsarray)
    [col_pts,on] = ...
        inpolygon(plt_init(:,1),plt_init(:,2),...
        obsarray{i}(:,1),obsarray{i}(:,2));

    col_pts=col_pts|on; 
    col_pts_array{i} = col_pts;
    
    plot(plt_init(col_pts,1),plt_init(col_pts,2),'Color',cmap(7,:));
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
cltp_total = [cltp{1};cltp{2};cltp{3}];

%%% }}}

%% Plot Obstacle {{{
for i=1:length(obsarray)
      p1 = patch(obsarray{i}(:,1),obsarray{i}(:,2),[.2 .2 .2],'FaceAlpha',.8);
      uistack(p1,'bottom')
end
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

%% Collision Detection {{{

for i=1:length(obsarray)
    [col_pts,on] = ...
        inpolygon(plt_total(:,1),plt_total(:,2),...
        obsarray{i}(:,1),obsarray{i}(:,2));

    col_pts=col_pts|on; 
    col_pts_array{i} = col_pts;
    
    plot(plt_total(col_pts,1),plt_total(col_pts,2),'Color',cmap(7,:));
end

%% 2-Segment Bilal
tstart = 0;
tend = 1;
col_seg = 2;

g = @(x) (x-tstart)/(tend-tstart);

t_c     = g(min(tvec_total(col_pts)));

t_temp = linspace(0,1,N_plt_pts);

tvec_mvwpt = tvec_total;
cltp_mvwpt = cltp_total;

bb=bernMatrix_a2b(18-1,tvec_total');
b = bb(tvec_total<=.47,:);
b= b(end,:);
% qq = b(6:end-5);
qq = b';
qqq = (qq./(sum(qq.^2)));
qqq=[zeros(6,1);qqq;zeros(6,1)];
qqq(11:14)=qqq(10)*ones(4,1);
qqq(20-3:20)=qqq(21)*ones(4,1);


cltp_mvwpt(:,2) = cltp_mvwpt(:,2)-qqq;
cltp_mvwpt(:,1) = cltp_mvwpt(:,1)-qqq;

% Find plot 
prev_ts = 0;
plt_mvwpt = cell(1,segs);
cltp = cell(1,segs);
for k = 0:(segs-1)
  cltp{k+1}=cltp_mvwpt(k*bcps+1:bcps*(k+1),:);
  plt_mvwpt{k+1} = gen_bezier(tvec{k+1}',cltp{k+1});
    
  plot3(plt_mvwpt{k+1}(:,1),plt_mvwpt{k+1}(:,2),plt_mvwpt{k+1}(:,3), ...
    'Color',cmap(3,:), 'LineWidth', 2.0);
  prev_ts = ts;
end

avoid_pth = gen_bezier(tvec{col_seg}',cltp_mvwpt);

avoid_traj = BezierTraj(waypts, min_der, iters(iter), cf2);

avoid_traj.x.a=cltp_mvwpt(:,1);
avoid_traj.y.a=cltp_mvwpt(:,2);
avoid_traj.z.a=cltp_mvwpt(:,3);

Jx = avoid_traj.x.costbez_manual(res);
Jy = avoid_traj.y.costbez_manual(res);
J3=Jx+Jy;

%%% }}}

fprintf('COST:\t%f\t%f\n',final_cost/final_cost,J3/final_cost);

end