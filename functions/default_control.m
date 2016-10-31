%% Control Matrix Format
% matrix  = [ xp, xi, xd;...
%             yp, yi, yd;...
%             zp, zy, zd];
%

%% Altitude Trim PWM
default_ctl.pwm = cf2.pwm;

%% Position Control
% x; y; z
default_ctl.pos = [-30,-2,0;...
                    30,2,0;...
                   11000,3500,9000];%11000,3500,9000
               


%% Attitutde Control
% roll; pitch; yaw
default_ctl.att = [3.5,0,0;...
                     3.5,0,0;...
                     3,0,0];


%% Rate Control
% roll; pitch; yaw
default_ctl.rates = [70,0,0;...
                     70,0,0;...
                     70,16.7,0];
                 
%% Saturations
% Integration saturations
default_ctl.intSat = [0.1,0.1,1000      ;...  % x,y,z  
                      20,20,inf         ;...  %r,p,y
                      1000,1000,150     ];    %dr,dp,dy     
% Saturations roll; pitch; yaw; thrust
default_ctl.sat = [30;30;200;60000];   
%% Motor Mixing
% X mode
default_ctl.mix = [-1/2 -1/2 -1 1;...
                   -1/2 +1/2 +1 1;...
                   +1/2 +1/2 -1 1;...
                   +1/2 -1/2 +1 1];
% + Mode
% default_ctl.mix = [+0 +1 +1 1;...
%                    -1 +0 -1 1;...
%                    +0 -1 +1 1;...
%                    +1 +0 -1 1];