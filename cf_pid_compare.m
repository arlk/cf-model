%{
Geometric control vs PID for crazyflie
Arun Lakshmanan
%}


%% Pre-setup
close all;
clear;
clc;
addpath('/home/arun/git_projs/matlab2tikz/src');

addpath('functions/control_utils');
addpath('functions/model_utils');
addpath('functions/plot_utils');

%% Sim time
k = 2/3;
T = 3*3*pi/(2*k)+0.45;
dt = 0.004;
enable_est = 0;

%Circ traj
circ_amp = 3;
circ_w = k;
x_init = 0.0;
x_vel = 1.0;

%% Initialize crazyflie
ic  = [-3 0 0 0 0 0 0 0 0 0 0 0];
crazyflie
geometric_control
pid_control
est_params

%% Simulate
load_system('cf_compare_model');
if enable_est
  set_param('cf_compare_model/GC_Estimator','commented','off');
  % set_param('cf_compare_model/PID_Estimator','commented','off');
else
  set_param('cf_compare_model/GC_Estimator','commented','through');
  % set_param('cf_compare_model/PID_Estimator','commented','through');
end
sim('cf_compare_model', T);

%% Plot


% plot_traj(state, ref_path);
% cleanfigure;
% matlab2tikz('traj.tex');
% plot_time(perr);
% cleanfigure;
% matlab2tikz('perr.tex');
% plot_time(verr);
% cleanfigure;
% matlab2tikz('verr.tex');
% plot_time(rerr);
% cleanfigure;
% matlab2tikz('rerr.tex');
% plot_time(werr);
% cleanfigure;
% matlab2tikz('werr.tex');
plot_time(ci,ci,ci);
cleanfigure;
matlab2tikz('ci.tex');

% plot_time(perr, pid_perr);
% cleanfigure;
% matlab2tikz('err_compare1.tex');
% figure();
% plot2d(ref_path, state, pid_state);
% cleanfigure;
% matlab2tikz('traj_compare1.tex');
% figure();
% plot_traj(state, ref_path);
