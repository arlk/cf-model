%%
model = cf2;


%% Orientation
geometric_ctl.e3 = [0;0;1];

%% PWM
geometric_ctl.pwm = model.pwm;

%% Motor Mixing
% X mode
geometric_ctl.mix = [-1/2 -1/2 -1 1;...
                   -1/2 +1/2 +1 1;...
                   +1/2 +1/2 -1 1;...
                   +1/2 -1/2 +1 1];


geometric_ctl.gains = [16*model.Mass 5.6*model.Mass 8.81 2.54]; % kx kv kr kw

geometric_ctl.thrust_gain = 1.369715857218715e+05;

% Saturations moment(upper); moment(lower); thrust
geometric_ctl.sat = [32000;-32000;60000];

geometric_ctl.kp = diag([0.35 0.35 0.25])

geometric_ctl.kv = diag([0.25 0.25 0.15])

geometric_ctl.kr = 1000*diag([30 30 20])

geometric_ctl.komg = 1000*diag([5 5 3])
