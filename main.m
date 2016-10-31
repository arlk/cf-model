%{
Crazyflie Model and Simulation
Main function. Defines Quads, Trajectories and runs simulation.
Andrew Patterson
16 September 2016

Purpose:

Contents:
		1.)	House Keeping
		2.)	Create Time
		3.)	Create Quads
        4.) Sim Params
		5.)	Simulate
		6.)	Plot Output
%}


%%	1 House Keeping
close all;
clear;
clc;
addpath('functions');

%%	2 Create Time
% dt = 0.0001;
T = 20;
% t = 0:dt:T;
% L = T/dt+1;

% Useful constants
r2d = 180/pi;
d2r = pi/180;

%%	3 Create Quads
% quad 1 - crazyflie with default control
crazyflie
ic  = [0 0 0 0 0 0 0 0 0 0 0 0];
ic2 = [0 0 0 0 0 0 0 0 0 0 0 0];
default_control
geometric_control

%%  4 Populate Sim Parameters
T_takeoff = 5;
Kp = 0.5;
Ki = 0.004;

%%	5 Simulate
sim('simQuad', T);

%%	6 Plot
% plot_traj(state1,ref_path1);
plot_traj(state2, ref_path2);
% plot_traj(state3);
% plot_traj(state4);

axis square;
