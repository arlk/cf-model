%{
Geometric control for crazyflie
Arun Lakshmanan
%}


%% Pre-setup
close all;
clear;
clc;

addpath('functions/control_utils');
addpath('functions/model_utils');
addpath('functions/plot_utils');

%% Sim time
T = 10;

%% Initialize crazyflie
ic  = [0 0 0 0 0 0 0 0 0 0 0 0];
crazyflie
geometric_control
est_params

%% PID setup for comparison
pid_control

%% Simulate
sim('cf_model', T);

%% Plot
plot_traj(state, ref_path);
