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

geometric_ctl.thrust_gain = 130500;

% Saturations moment(upper); moment(lower); thrust
geometric_ctl.sat = [32000;-32000;60000];

geometric_ctl.kp = 0.2*eye(3)

geometric_ctl.kv = 0.1*eye(3)

geometric_ctl.kr = 1000*diag([9 9 7])

geometric_ctl.komg = 1000*diag([4 4 3])
