%% World Z axis [the right way ;)]
geometric_ctl.e3 = [0;0;1];

%% Motor Mixing
% X mode
geometric_ctl.mix = [-1/2 -1/2 -1 1;...
                       -1/2 +1/2 +1 1;...
                       +1/2 +1/2 -1 1;...
                       +1/2 -1/2 +1 1];


% PWM gains
geometric_ctl.thrust_gain = 1.369715857218715e+05;
geometric_ctl.moment_gain = 5000;

% Saturations moment(upper_lim); moment(lower_lim); thrust
geometric_ctl.sat = [32000;-32000;60000];

% Controller gains
geometric_ctl.kp = diag([0.35 0.35 0.25])
geometric_ctl.kv = diag([0.25 0.25 0.15])
geometric_ctl.kr = diag([6 6 4])
geometric_ctl.komg = diag([1 1 0.6])
